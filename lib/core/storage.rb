# encoding: utf-8
require 'zip'
require 'net/sftp'

class Core::Storage

  attr_accessor :uploads_dirs

  ###########################################################
  # Общие для файлов и папок методы
  ###########################################################

  def initialize
    # Название папок, зарезервированных под загружаемый контент
    @uploads_dirs = %w(announce audios blog_posts blogs employees galleries poll posts stories user_offers users videos)
    # Устанавливаем связь с удаленным сервером
    @error = nil
    begin
      @sftp = Net::SFTP.start(
              FILE_STORAGE['sftp']['host'],
              FILE_STORAGE['sftp']['user'],
              password: FILE_STORAGE['sftp']['password'])
    rescue SocketError => ex
      @error = ex.message
    end
  end

  # Структура корневой директории для первоначальной загрузки
  # 
  # * *Returns* :
  #   - Hash структура для инициализации первоначальной загрузки
  #
  def init
    respond = Hash.new
    unless @error.nil?
      respond[:error] = @error 
    else
    # Создаем папку под сегодняшний день, если её нет
    create_current_day(FILE_STORAGE['sftp']['media_path'] + "/uploads")
    dt = Time.new
    #.strftime("/%Y/%m/%d")

    uploads = Array.new
    basedir = FILE_STORAGE['sftp']['path'] + "/" + FILE_STORAGE['sftp']['media_path'] + "/uploads"
    base = FILE_STORAGE['sftp']['media_path'] + "/uploads"
    @sftp.dir.foreach(basedir) do |entry|
      next unless entry.name != '.' && entry.name != '..' && entry.name != '.thumb' && entry.directory?
      dirname = base + '/' + entry.name
      subdirectory = {
        name: entry.name,
        readable: true,
        writable: is_writable_dir?(dirname),
        removable: false,
        hasDirs: is_subdir?(dirname)}
      if(entry.name == dt.strftime("%Y"))
        years = Array.new
        @sftp.dir.foreach(basedir + dt.strftime("/%Y")) do |entry|
          next unless entry.name != '.' && entry.name != '..' && entry.name != '.thumb' && entry.directory?
          diryear = dirname + '/' + entry.name
          subyear = {
            name: entry.name,
            readable: true,
            writable: is_writable_dir?(diryear),
            removable: false,
            hasDirs: is_subdir?(diryear)
          }
          if(entry.name == dt.strftime("%m"))
            months = Array.new
            @sftp.dir.foreach(basedir + dt.strftime("/%Y/%m")) do |entry|
              next unless entry.name != '.' && entry.name != '..' && entry.name != '.thumb' && entry.directory?
              dirmonth = diryear + '/' + entry.name
              submonth = {
                name: entry.name,
                readable: true,
                writable: is_writable_dir?(dirmonth),
                removable: false,
                hasDirs: is_subdir?(dirmonth)
              }
              submonth[:current] = true if(entry.name == dt.strftime("%d"))
              months << submonth
            end
            subyear[:dirs] = months.sort {|x, y| x[:name] <=> y[:name]}
          end
          years << subyear
        end
        subdirectory[:dirs] = years.sort {|x, y| x[:name] <=> y[:name]}
      end
      uploads << subdirectory
    end

    # Инициируем медиабиблиотеку сегодняшним днем
    respond = {
      tree: {
        name: FILE_STORAGE['sftp']['media_path'],
        readable: true,
        writable: true,
        removable: false,
        hasDirs: true,
        dirs: [
        {
          name: "uploads",
          readable: true,
          writable: true,
          removable: false,
          hasDirs: true,
          dirs: uploads
        }]
      },
      files: self.files_list(FILE_STORAGE['sftp']['media_path'] + "/uploads" + Time.new.strftime("/%Y/%m/%d")),
      dirWritable: true}
    end
    respond
  end

  # Переименование файла, каталога
  # 
  # * *Args*    :
  #   - +old_name+ String путь (относительно папки media) к переименовываемум файлу, каталогу
  #   - +new_name+ String путь (относительно папки media) с новым именем для переменовываемого файла
  # * *Returns* :
  #   - Hash возвращает пустой хэш с случае успеха и сообщение об ошибке {error: "..."},
  #          в случае невозможности переименования директории
  #
  def rename(old_name, new_name)
    # Проверяем нет ли в каталоге и его подкаталогах файлов,
    # на которые имеются ссылки из контента
    return {error: "Каталог содержит изображения, на которые ссылаются публикации"} unless is_dir_use?(old_name)

    # Переименование на уровне модели
    rm_file = MediaFile.find_by_file_file_path_and_file_file_name(
      File.dirname(old_name),
      File.basename(old_name))
    unless rm_file.nil?
      rm_file.file_file_name = File.basename(new_name)
      rm_file.file_file_path = File.dirname(new_name)
      rm_file.save!
    end

    # Переименование на уровне SFTP
    @sftp.rename!(
      FILE_STORAGE['sftp']['path'] + '/' + old_name,
      FILE_STORAGE['sftp']['path'] + '/' + new_name)
    begin
      @sftp.rename!(
        FILE_STORAGE['sftp']['path'] + '/' + old_name.gsub(/media/, "media/.thumb"),
        FILE_STORAGE['sftp']['path'] + '/' + new_name.gsub(/media/, "media/.thumb"))
    rescue => ex

    # Уменьшенной копии может не быть
    end
    if is_dir?(new_name)
      sql = %Q(
          UPDATE
            media
          SET
            file_file_path = REPLACE(file_file_path, #{ActiveRecord::Base.connection.quote(old_name)}, #{ActiveRecord::Base.connection.quote(new_name)})
          WHERE
            file_file_path like #{ActiveRecord::Base.connection.quote(old_name + '%')}
        )
      ActiveRecord::Base.connection.execute(sql);
    end

    return {name: new_name}
  end

  ###########################################################
  # Обработка папок
  ###########################################################

  # Список подкаталогов, текущего каталога
  # 
  # * *Args*    :
  #   - +dir+ String путь к текущему каталогу
  # * *Returns* :
  #   - Array список подкаталогов текущего каталога
  #
  def dirs_list(dir)
    dirs = Array.new
    @sftp.dir.foreach(FILE_STORAGE['sftp']['path'] + '/' + dir) do |entry|
      if entry.name != '.' && entry.name != '..' && entry.name != '.thumb' && entry.directory?
        dirname = dir + '/' + entry.name
        dirs << {
          name: entry.name,
          readable: true,
          writable: is_writable_dir?(dirname),
          removable: is_dir_use?(dirname) && is_writable_dir?(dirname),
          hasDirs: is_subdir?(dirname)}
      end
    end
    dirs
  end

  # Подготавливает архив каталога и всех вложенных подкаталогов
  # 
  # * *Args*    :
  #   - +basedir+ String путь к базовому каталогу, содержимое которого необходимо упаковать в архив
  #   - +currentdir+ String текущий каталог, который подвергается архивации
  #   - +zipfile+ дескриптор доступа к zip-архиву
  # * *Returns* :
  #   - String путь к архиву
  #
  def download_dirs(basedir, currentdir, zipfile = nil)
    exists_dirs = Array.new
    zip = Tempfile.new('clipboard').path + ".zip"
    files = structure_dirs(basedir, currentdir)
    Zip::ZipFile.open(zip, Zip::ZipFile::CREATE) do |zipfile|
      files.each do |line|
        # Создаем файл
        dir = File.dirname(line)
        if dir != '.' && !exists_dirs.include?(dir)
          exists_dirs << dir
          zipfile.mkdir(dir)
        end
        filename_local = Tempfile.new(File.basename(line))
        filename_remote = FILE_STORAGE['sftp']['path'] + "/" + basedir + "/" + line
        @sftp.download!(filename_remote, filename_local.path)
        zipfile.get_output_stream(line) { |f| f.puts open(filename_local.path, "rb").read }
      end
    end
    zip
  end

  def structure_dirs(basedir, currentdir)
    result = Array.new
    nextdir = ""
    @sftp.dir.foreach(FILE_STORAGE['sftp']['path'] + '/' + basedir + '/' + currentdir) do |entry|
      if entry.name != '.' && entry.name != '..' && entry.name != '.thumb'
        if entry.directory?
          if currentdir.blank?
            nextdir = entry.name
          else
            nextdir = currentdir + "/" + entry.name
          end
          result += structure_dirs(basedir, nextdir)
        else
          if currentdir.blank?
            zipname = entry.name
          else
            zipname = currentdir + "/" + entry.name
          end
          result << zipname
        end
      end
    end
    result
  end

  # Создание нового каталога, воссоздаются все несуществующие
  # папки по всему пути следования
  # 
  # * *Args*    :
  #   - +dir+ String путь (относительно папки media) к создаваемому
  #           каталогу
  # * *Returns* :
  #   - true
  #
  def mkdir(dir)
    # Создание основного дерева
    sftp_mkdir(dir)
    # Помимо основного каталога в скрытом разделе .thumb создается
    # дерево дополнительного каталога
    sftp_mkdir(dir.gsub(/media/, "media/.thumb"))
  end

  def sftp_mkdir(dir)
    arr = dir.split('/')
    current = ""
    arr.each do |dir_name|
      dir_exists = false
      @sftp.dir.foreach(FILE_STORAGE['sftp']['path'] + "/" + current) do |entry|
        dir_exists = true if entry.name == dir_name
      end
      current += "/" + dir_name
      unless dir_exists
        @sftp.mkdir!(FILE_STORAGE['sftp']['path'] + current, permissions: 0755)
      end
    end
  end

  # Создание в текущей папке dir каталога вида 2013/08/02
  # 
  # * *Args*    :
  #   - +dir+ String путь (относительно папки media) к создаваемому
  #           каталогу
  # * *Returns* :
  #   - true
  #
  def create_current_day(dir)
    dt = Time.new
    year = dt.strftime("%Y")
    month = dt.strftime("%m")
    day = dt.strftime("%d")
    path = dir + "/" + year
    mkdir(path) unless is_dir?(path)
    path = path + "/" + month
    mkdir(path) unless is_dir?(path)
    path = path + "/" + day
    mkdir(path) unless is_dir?(path)
  end

  # Удаление каталога, включая вложенные подкаталоги
  # 
  # * *Args*    :
  #   - +dir+ String путь к удаляемому каталогу
  # * *Returns* :
  #   - true
  #
  def rmdir(dir)
    # Создание основного дерева
    sftp_rmdir(dir)
    # Помимо основного каталога в скрытом разделе .thumb создается
    # дерево дополнительного каталога
    # sftp_rmdir(dir.gsub(/media/, "media/.thumb"))
  end

  def sftp_rmdir(dir)
    # Удаляем содержимое каталога
    @sftp.dir.foreach(FILE_STORAGE['sftp']['path'] + '/' + dir) do |entry|
      if entry.name != '.' && entry.name != '..'
        if entry.directory?
          sftp_rmdir(dir + '/' + entry.name)
        else
          file_unlink(dir + '/' + entry.name)
        end
      end
    end
    # Удаление не требуется, об этом заботится paperclip
    begin
      @sftp.rmdir!(FILE_STORAGE['sftp']['path'] + '/' + dir)
    rescue
      # Папку может удалять PapareClip, если она в модели в базе данных,
      # А может не удалять, если её в модели нет
    end
  end

  ###########################################################
  # Групповая обработка файлов
  ###########################################################

  # Поиск файлов по базе данных
  # 
  # * *Args*    :
  #   - +query+ String поисковая фраза
  #   - +limit+ Integer количество отдаваемых результатов, если 0 - не ограничено
  # * *Returns* :
  #   - Array 
  #
  def search(query, limit = 0)
    options = Hash.new
    files = Array.new

    return files if query.nil?

    options[:limit] = limit if limit > 0
    result = MediaFile.search(CGI::unescape(query), options)
    result.each do |entry|
      filename = FILE_STORAGE['sftp']['path'] + '/' + entry.file_file_path + '/' + entry.file_file_name

      property = properties(entry.file_file_path, entry.file_file_name)

      file_entry =
        {
          name: entry.file_file_name,
          dir: entry.file_file_path,
          size: entry.file_file_size,
          mtime: entry.file_content_type,
          date: DateTime.parse(entry.updated_at.to_s).to_time.strftime("%d\/%m\/%Y %H:%I %p"),
          readable: true,
          writable: is_file_use?(entry.file_file_path, entry.file_file_name),
          bigIcon: true,
          smallIcon: true,
          thumb: is_image?(filename) ? true : false,
          smallThumb: false,
          thumbName: entry.file_file_name,
          video: is_video?(filename) ? true : false
        }
        file_entry[:properties] = property unless property.blank?

      files << file_entry

    end
    files
  end

  # Загрузка файлов на сервер
  # 
  # * *Args*    :
  #   - +dir+ String путь (относительно папки media)
  #           к каталогу, в который загружаются файлы
  #   - +upload+ Array массив UploadedFile-объектов, загруженных на сервер
  # * *Returns* :
  #   - String список имен, загруженных файлов
  #
  def files_upload(dir, upload)
    response = Array.new
    upload.each do |file|

      original_filename = sanitizer(file.original_filename)
      if file.respond_to?("original_filename=")
        file.original_filename = original_filename
      end

      old_file = MediaFile.find_by_file_file_name_and_file_file_path(
        original_filename,
        dir)

      if old_file
        old_file.file = file
        old_file.save!

        if old_file.class_name == 'MediaFile::Clip'
          Delayed::Job.where("handler LIKE '%\\nmodel: !ruby/ActiveRecord:MediaFile::Clip\\n%\\n    id: ?\\n%'", old_file.id).destroy_all
          Delayed::Job.enqueue(::ConvertJob.new(old_file.file.path, old_file.file.path, old_file), queue: 'converting')
        end
      else
        upload_file = media_by_content_type(file.content_type)

        unless upload_file.nil?

          upload_file.file_file_path = dir
          upload_file.file_file_name = original_filename
          upload_file.file = file
          upload_file.save!
        end
      end
      
      response << "/#{original_filename}"

    end
    response.join("\n")
  end  

  # Удаление файла с сервера
  # 
  # * *Args*    :
  #   - +file+ String путь (относительно папки media)
  #           к удаляемому файлу
  # * *Returns* :
  #   - true
  #
  def file_unlink(file)
    result = Hash.new
    rm_file = MediaFile.find_by_file_file_name_and_file_file_path(
      File.basename(file),
      File.dirname(file))
    unless rm_file.nil?
      # Проверяем нет ли ссылок
      return {error: "Файл невозможно удалить, так как на него имеются ссылки из публикаций"} if rm_file.counter_media_publications.size > 0
      # Удаление файла и записи в базе данных
      rm_file.destroy
    else
      # Удаляем только файл
      @sftp.remove!(FILE_STORAGE['sftp']['path'] + '/' + file)
      thumb_file = file.gsub(/media/, "media/.thumb")
      begin
        @sftp.remove!(FILE_STORAGE['sftp']['path'] + '/' + thumb_file)
      rescue => ex
        # Уменьшенной копии может не быть
      end
    end
    result
  end

  # Список файлов, текущего каталога
  # 
  # * *Args*    :
  #   - +dir+ String путь к текущему каталогу
  # * *Returns* :
  #   - Array список файлов текущего каталога
  #
  def files_list(dir)
    files = Array.new
    return files if dir.nil?
    return unless is_dir?(dir)
    is_writable_dir = is_writable_dir?(dir)
    @sftp.dir.foreach(FILE_STORAGE['sftp']['path'] + '/' + dir) do |entry|
      if entry.name != '.' && entry.name != '..' && entry.file?

        next if entry.name =~ /__[0-9]+x[0-9]+\.[a-z0-9]+$/i

        filename = FILE_STORAGE['sftp']['path'] + '/' + dir + '/' + entry.name
        attributs = @sftp.lstat!(filename)
        permissions = attributs.permissions.to_s(8)[3, 3] # В формате 644

        file_entry =
        {
          name: entry.name,
          size: attributs.size,
          mtime: attributs.mtime,
          date: Time.at(attributs.mtime).strftime("%d\/%m\/%Y %H:%I %p"),
          readable: true,
          writable: is_writable_dir,
          bigIcon: true,
          smallIcon: true,
          thumb: is_image?(filename) ? true : false,
          smallThumb: false,
          thumbName: is_writable_dir ? entry.name : entry.name.gsub("_original", "_thumb"),
          video: is_video?(filename) ? true : false
        }

        files << file_entry
      end
    end
    # Формируем полученный массив
    properties_list = properties(dir, files.collect{|f| f[:name] })
    files.each do |file|
      file[:properties] = properties_list[file[:name]]
      file[:writable] = properties_list[file[:name]][:can_change] && is_writable_dir unless properties_list[file[:name]].nil?
    end
    files
  end

  # Возвращает свойства файла
  # 
  # * *Args*    :
  #   - +dir+ String путь (относительно папки media)
  #           к каталогу на сервере, где расположен файл
  #   - +file+ String|Array название файла, свойства которого запрашиваются
  #                         или массив названий в случае массива
  # * *Returns* :
  #   - Hash|Array свойства файла или массив свойств
  #
  def properties(dir, file)
    if file.kind_of?(Array)
      result = {}
      medias = MediaFile.where("file_file_path = ? AND file_file_name IN (?)", dir, file)
      return result if medias.nil?
      medias.each do |media|
        result[media.file_file_name] = {
          title: media.title,
          description: media.description,
          tags: media.keyword_list.find_all.collect {|x| x},
          authors: media.authors.collect {|x| x.name},
          can_change: media.counter_media_publications.size > 0 ? false : true
        }
      end
      result
    else
      media = MediaFile.find_by_file_file_path_and_file_file_name(dir, file)
      return {} if media.nil?

      {
        title: media.title,
        description: media.description,
        tags: media.keyword_list.find_all.collect {|x| x},
        authors: media.authors.collect {|x| x.name},
        can_change: media.counter_media_publications.size > 0 ? false : true
      }
    end
  end

  # Изменение параметров файла (описание, ключевые слова, авторы)
  # 
  # * *Args*    :
  #   - +dir+ String путь (относительно папки media) к папке с файлом
  #   - +file+ String название файла
  #   - +title+ String заголовок файла
  #   - +description+ String описание файла
  #   - +tags+ String ключевые слова через запятую (Тэги)
  #   - +authors+ String авторы через запятую
  # * *Returns* :
  #   - true
  #
  def change_properties_file(dir, file, title, description, tags, authors)
    media = MediaFile.find_or_create_by_file_file_path_and_file_file_name(dir, file)

    return if media.nil?

    media.title = title
    media.description = description
    media.class_name = mime(file) if media.class_name.nil?
    media.class_name = "MediaFile::Image" if media.class_name.blank?

    media.keyword_list.find_all.each do |tag|
      media.keyword_list.remove(tag)
    end

    unless tags.nil?
      tags.split(",").each do |tag|
        media.keyword_list.add(tag.strip)
      end
    end

    authors_list = Array.new
    unless authors.nil?
      authors.split(",").each do |author|
        author = Author.find_or_create_by_name(author.strip)
        authors_list << author.id
      end
      media.author_ids = authors_list
    end

    media.save!
  end

  # Копирование группы файлов
  # 
  # * *Args*    :
  #   - +dir+ String путь (относительно папки media)
  #           к каталогу на сервере, где расположен файл
  #   - +files+ Array список копируемых файлов
  # * *Returns* :
  #   - true
  #
  def copy_files(dir, files)
    return unless files.size > 0
    files.each do |file_path|
      filename_remote = FILE_STORAGE['sftp']['path'] + "/" + file_path
      filename_local = Tempfile.new(File.basename(file_path))

      @sftp.download!(filename_remote, filename_local.path)

      # Загрузка основного файла
      filename_remote =  dir + '/' + File.basename(file_path)
      @sftp.upload!(filename_local, FILE_STORAGE['sftp']['path'] + '/' + filename_remote)

      # Загрузка уменьшенной копии на сервер
      thumb(filename_local.path, filename_remote)
    end
  end

  # Удаление группы файлов
  # 
  # * *Args*    :
  #   - +files+ Array список удаляемых файлов
  # * *Returns* :
  #   - true
  #
  def delete_files(files)
    # Удаляем старые файлы
    files.each do |file_path|
      file_unlink(file_path)
    end
  end

  # Перемещение группы файлов
  # 
  # * *Args*    :
  #   - +dir+ String путь (относительно папки media)
  #           к каталогу на сервере, где расположен файл
  #   - +files+ Array список перемещаемых файлов
  # * *Returns* :
  #   - true
  #
  def move_files(dir, files)
    return unless files.size > 0
    files.each do |file_path|
      rename(file_path, dir + '/' + File.basename(file_path))
    end
  end

  # Подготавливает архив файлов
  # 
  # * *Args*    :
  #   - +files+ Array массив файлов, которые необходимо скачать и упаковать в архив
  # * *Returns* :
  #   - String путь к архиву
  #
  def download_files(files)
    return unless files.size > 0
    zip = Tempfile.new('clipboard').path + ".zip"
    Zip::ZipFile.open(zip, Zip::ZipFile::CREATE) do |zipfile|
      files.each do |file|
        filename_local = Tempfile.new(File.basename(file))
        filename_remote = FILE_STORAGE['sftp']['path'] + "/" + file
        @sftp.download!(filename_remote, filename_local.path)
        zipfile.get_output_stream(File.basename(file)) { |f| f.puts open(filename_local.path, "rb").read }
      end
    end
    zip
  end

  ###########################################################
  # Группа вспомогательных методов (utils)
  ###########################################################

  # Возвращает ссылку на файл
  # 
  # * *Args*    :
  #   - +file+ String путь (относительно папки media) к файлу
  # * *Returns* :
  #   - String путь к локальной копии файла
  #
  def file_path(file)
    FILE_STORAGE['sftp']['url'] + '/' + file
  end

  # Очищаем имена директорий и файлов от спецсимволов,
  # оставляя только буквы английского алфавита, цифры, 
  # точку и символ подчеркивания
  # Пробельные символы заменяются символом подчеркивания
  # 
  # * *Args*    :
  #   - +name+ String имя файла или пользователя
  # * *Returns* :
  #   - String имя 
  #
  def sanitizer(name)
    Russian::transliterate(name).gsub(/\s+/iu, "_").gsub(/[^_.a-z0-9]+/iu, "")
  end

  # Возвращает MIME-тип по типу файла
  # 
  # * *Args*    :
  #   - +file+ String имя или путь к файлу
  # * *Returns* :
  #   - String MIME-тип файла в формате "image/jpeg"
  #
  def mime(file)
    extname = File.extname(file)[1..-1]
    mime_type = Mime::Type.lookup_by_extension(extname)
    mime_type = "audio/mp3" if mime_type.nil? && extname == "mp3"
    content_type = mime_type.to_s unless mime_type.nil?
  end

  # Возвращает true, если на файл ссылаются из контента и false в противном случае
  # Используемый файл нельзя переименовывать и удалять
  # Ориентируется на счетчик ссылок в counter_media_publications
  # 
  # * *Args*    :
  #   - +dir+ String путь (относительно папки media)
  #           к каталогу на сервере, где расположен файл
  #   - +file+ String имя или путь к файлу
  # * *Returns* :
  #   - boolean возвращает true, если файл можно переименовывать и false в противном случае
  #
  def is_file_use?(dir, file)
    can_change = true
    model = MediaFile.find_by_file_file_path_and_file_file_name(dir, file)
    unless model.nil?
      can_change = false if model.counter_media_publications.size > 0
    end
    can_change
  end

  # Возвращает true, если каталог содержит файлы, на которые ссылаются из контента и false в противном случае
  # Каталоги для которых возвращается true нельзя переименовывать или удалять
  # Ориентируется на счетчик ссылок в counter_media_publications
  # 
  # * *Args*    :
  #   - +dir+ String путь (относительно папки media)
  #           к каталогу на сервере, который необходимо переименовать
  # * *Returns* :
  #   - boolean возвращает true, если каталог можно переименовывать и false в противном случае
  #
  def is_dir_use?(dir)
    # Проверяем нет ли в каталоге и его подкаталогах файлов,
    # на которые имеются ссылки из контента
    sql = %Q(
        SELECT
          *
        FROM
          media_files
        WHERE
          file_file_path LIKE #{ActiveRecord::Base.connection.quote(dir + '%')}
        AND
          NOT class_name LIKE 'MediaFile::%'
      )
    res = ActiveRecord::Base.connection.select_all(sql);
    return res.size == 0
  end

  # Возвращает true, если файл является изображением или false, в противном случае
  # 
  # * *Args*    :
  #   - +file+ String название или путь к файлу (существование файла не обязательно)
  # * *Returns* :
  #   - boolean
  #
  def is_image?(file)
    mime = mime(file)
    mime == "image/jpeg" || mime == "image/png" || mime == "image/gif"
  end

  # Возвращает true, если файл является видео-файлом или false, в противном случае
  # 
  # * *Args*    :
  #   - +file+ String название или путь к файлу (существование файла не обязательно)
  # * *Returns* :
  #   - boolean
  #
  def is_video?(file)
    mime = mime(file)
    mime == "video/mp4" || mime == "video/flv" || mime == "video/webm" || mime == "video/m4v" || mime == "video/avi"
  end

  # Возвращает true, если файл является аудио-записью или false, в противном случае
  # 
  # * *Args*    :
  #   - +file+ String название или путь к файлу (существование файла не обязательно)
  # * *Returns* :
  #   - boolean
  #
  def is_audio?(file)
    mime = mime(file)
    mime == "audio/mp3" || mime == "audio/wav"
  end

  # Содержит ли каталог подкаталоги
  # 
  # * *Args*    :
  #   - +dir+ Stirng путь к текущему каталогу
  # * *Returns* :
  #   - boolean возвращает true, если у каталога имеются подкаталоги и false в противном случае
  #
  def is_subdir?(dir)
    @sftp.dir.foreach(FILE_STORAGE['sftp']['path'] + '/' + dir) do |entry|
      return true if entry.name != '.' && entry.name != '..' && entry.directory?
    end
    return false
  end

  # Возвращает true, если проверяемый файл является директорией или false, в противном случае
  # 
  # * *Args*    :
  #   - +dir+ String путь (относительно папки media) к проверяемому файлу
  # * *Returns* :
  #   - boolean
  #
  def is_dir?(dir)
    begin
      filename = FILE_STORAGE['sftp']['path'] + '/' + dir
      attributs = @sftp.lstat!(filename)
      permissions = attributs.permissions.to_s(8)[0, 1]
      permissions.to_i == 4
    rescue => ex
      return false
    end
  end

  # Возвращает true, если в папку dir можно загружать файлы и false - в противном случае
  # 
  # * *Args*    :
  #   - +dir+ String 
  # * *Returns* :
  #   - boolean
  #
  def is_writable_dir?(dir)
    # Формируем регулярное выражение с 
    exp = Regexp.new("/media/" + uploads_dirs.join("|"))
    !(exp =~ dir)
  end

  # Фабричный метод для создания объекта MediaFile-модели (Image, Clip, Record) по медиа-типу
  # 
  # * *Args*    :
  #   - +content_type+ String MEDIA-тип "image/jpeg", "image/gif" и т.п.
  # * *Returns* :
  #   - объект, наследующий от MediaFile
  #
  def media_by_content_type(content_type)
    result = nil
    if content_type =~ /^image/
      result = MediaFile::Image.new
    elsif content_type =~ /^video/
      result = MediaFile::Clip.new
    elsif content_type =~ /^audio/
      result = MediaFile::Record.new
    end
    result
  end

  private

  # Загрузка на сервер уменьшенной копии изображения
  # 
  # * *Args*    :
  #   - +local_file+ String путь к локальной версии полного изображения
  #   - +remote_file+ String путь к полной версии полного изображения (относительно media)
  # * *Returns* :
  #   - true
  #
  def thumb(local_file, remote_file)
    if(is_image? remote_file)
      filename_local = "#{local_file}_thumb"
      filename_remote = FILE_STORAGE['sftp']['path'] + '/' + remote_file.gsub(/^media/, "media/.thumb")
      system "convert #{local_file} -gravity north -resize '100x100^' -crop '100x100+0+0' +repage #{filename_local}"
      @sftp.upload!(filename_local, filename_remote)
    end
  end

end