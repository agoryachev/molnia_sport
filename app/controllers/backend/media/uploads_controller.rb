# -*- coding: utf-8 -*-
class Backend::Media::UploadsController < ActionController::Base
  before_filter :authenticate_employee!, :check_employee_abilities!
  layout "backend"

  # GET /backend/media
  def index
    render layout: "backend"
  end
  
  # GET /backend/media/uploader
  def uploader
    render layout: false, locals: {
      assetsPath: "/assets",
    }
  end

  # GET /backend/media/uploader_tinymce?type=(:type)
  def uploader_tinymce
    render layout: false, locals: {
      assetsPath: "/assets",
      tinyMCEPath: "/tinymce",
      type: params[:type].present? ? params[:type].to_s : "files"
    }
  end

  # GET /backend/media/:type(/:act)
  def action
    # Устанавливаем связь с контент-сервером
    @storage = Core::Storage.new
    # Менеджер действий
    case 
      # Разное
      when params[:act] == "init"
        init
      when params[:act] == "authors_list"
        authors_list(params[:query])
      when params[:act] == "tags_list"
        tags_list(params[:query])
      when params[:act] == "search"
        search_list(params[:query])
      # Обработка файлов
      when params[:act] == "upload"
        upload_file(params[:dir], params[:upload])
      when params[:act] == "rename"
        edit_file(
          params[:dir],
          params[:file],
          params[:newName],
          params[:newTitle],
          params[:newDesc],
          params[:newTags],
          params[:newAuthors])
      when params[:act] == "delete"
        delete_file(params[:dir], params[:file])
      when params[:act] == "download"
        download_file(params[:dir], params[:file])
      when params[:act] == "thumb"
        thumb_file(params[:dir], params[:file])
      when params[:act] == "properties"
        properties_file(params[:dir], params[:file])
      # Групповые операции над файлами
      when params[:act] == "cp_cbd"
        copy_files(params[:dir], params[:files])
      when params[:act] == "mv_cbd"
        move_files(params[:dir], params[:files])
      when params[:act] == "rm_cbd"
        delete_files(params[:files])
      when params[:act] == "downloadClipboard"
        download_files(params[:files])
      when params[:act] == "downloadDir"
        download_dir(params[:dir])
      # Обработка папок
      when params[:act] == "expand"
        expand(params[:dir])
      when params[:act] == "newDir"
        new_dir(params[:dir], params[:newDir])
      when params[:act] == "renameDir"
        rename_dir(params[:dir], params[:newName])
      when params[:act] == "chDir"
        ch_dir(params[:dir])
      when params[:act] == "deleteDir"
        delete_dir(params[:dir])
      else
        error = {error: "Событие отсутствует"}
        render json: error.to_json
    end
  end

  private

  ##############################################################
  # Набор действий из медиабиблиотеки
  ##############################################################

  # Действие init
  # Инициализация библиотеки, загружаются подкаталоге корневого каталога, файлы
  # 
  # * *Returns* :
  #   - JSON-ответ для отдачи клиенту
  #
  def init
    respond = @storage.init
    render json: respond.to_json
  end

  # Действие authors_list
  # Возвращает список авторов в виде JSON-объекта
  # 
  # * *Args*    :
  #   - +query+ String Начальные буквы в имени автора
  # * *Returns* :
  #   - JSON-ответ для отдачи клиенту
  #
  def authors_list query = nil
    authors = Hash.new
    if params[:query].present?
      authors[:suggestions] = Array.new
      authors[:data] = Array.new
      query = "#{query}%"
      list = Author
        .order("name")
        .limit(7)
      list = list.where("name like ?", query) unless query.nil?
      list.each do |preson|
        authors[:suggestions] << preson[:name]
        authors[:data] << preson[:id]
      end
    end
    render json: authors.to_json
  end

  # Действие tags_list
  # возвращает список тэгов в виде JSON-объекта
  # 
  # * *Args*    :
  #   - +query+ String Начальные буквы в названии тэга
  # * *Returns* :
  #   - JSON-ответ для отдачи клиенту
  #
  def tags_list query = nil
    tags = Hash.new
    if params[:query].present?
      tags[:suggestions] = Array.new
      tags[:data] = Array.new
      query = "#{query}%"
      list = ActsAsTaggableOn::Tag.order("name").limit(7)
      list = list.where("name like ?", query) unless query.nil?
      list.each do |res|
        tags[:suggestions] << res.name
        tags[:data] << res.id
      end
    end
    render json: tags.to_json
  end

  # Действие search
  # Полнотекстовый поиск по заголовкам, описаниям и ключевым словам
  # 
  # * *Args*    :
  #   - +query+ String Поисковый запрос со стороны клиента
  # * *Returns* :
  #   - JSON-ответ для отдачи клиенту
  #
  def search_list query
    results = Hash.new
    results[:files] = @storage.search(query)
    render json: results.to_json
  end

  # Действие upload
  # Загружает на сервер один или несколько файлов
  # 
  # * *Args*    :
  #   - +dir+ String путь (относительно папки media) к каталогу
  #              в который осуществляется загрузка файлов
  #   - +upload+ Array массив UploadedFile-объектов, загруженных
  #              во временную директорию сервером
  # * *Returns* :
  #   - String список файлов в формате
  #            /FileName1.jpg
  #            /FileName2.jpg
  #
  def upload_file(dir, upload)
    respond = @storage.files_upload(dir, upload)
    render text: respond, content_type: 'text/plain'
  end

  # Действие download
  # Загрузка файла с сервера
  # 
  # * *Args*    :
  #   - +dir+ String путь (относительно папки media)
  #           к каталогу на сервере, где расположен загружаемый файл
  #   - +file+ Stirng имя загружаемого файла
  # * *Returns* :
  #   - Бинарное содержимое файла для отдачи клиенту
  #
  def download_file(dir, file)
    file_url = @storage.file_path(dir + '/' + file)
    
    content_type = @storage.mime file

    # Формируем HTTP-заголовки
    response.headers['Content-Type'] = content_type
    response.headers['Content-Disposition'] = "attachment; filename=#{file}"

    render text: open(file_url, "rb").read, layout: false
  end

  # Действие thumb
  # Выдача уменьшенной копии файла
  # 
  # * *Args*    :
  #   - +dir+ String путь (относительно папки media)
  #           к каталогу на сервере, где расположен файл
  #   - +file+ Stirng имя файла
  # * *Returns* :
  #   - Бинарное содержимое файла для отдачи клиенту
  #
  def thumb_file(dir, file)
    begin
      file_url = @storage.file_path(dir.gsub(/media/, "media/.thumb") + '/' + file)
      uri = URI(file_url)
      Net::HTTP.start(uri.host, uri.port) do |http|
        resp = http.get uri.request_uri

        # Формируем MIME-тип
        content_type = @storage.mime file

        render text: resp.body, layout: false, content_type: content_type
      end
    rescue => ex
      # Уменьшенной копии может не быть
    end
  end

  # Действие properties
  # Получение информации о файле
  # 
  # * *Args*    :
  #   - +dir+ String путь (относительно папки media)
  #           к каталогу на сервере, где расположен файл
  #   - +file+ Stirng имя файла
  # * *Returns* :
  #   - JSON-ответ для отдачи клиенту
  #
  def properties_file(dir, file)
    respond = @storage.properties(dir, file)
    render json: respond.to_json
  end

  # Действие rename
  # Редактирование параметров файла
  # 
  # * *Args*    :
  #   - +dir+ String путь (относительно папки media)
  #           к каталогу на сервере, где расположен файл
  #   - +old_file+ String старое имя файла
  #   - +new_file+ String новое имя файла (NB: файл без расширения)
  #   - +descr+ String описание
  #   - +tags+ String список ключевых слов через запятую (тэги)
  #   - +authors+ String список авторов через запятую
  # * *Returns* :
  #   - JSON-ответ для отдачи клиенту
  #
  def edit_file(dir, old_file, new_file, title, descr, tags, authors)
    
    # Предотвращаем смену расширения, если осуществляется такая попытка
    new_file = @storage.sanitizer(new_file)
    extname_new = File.extname(@storage.sanitizer(new_file))
    unless extname_new.blank?
      new_file = new_file[0, new_file.size - extname_new.size] + File.extname(old_file)
    else
      new_file += File.extname(old_file)
    end

    filename = old_file
    # Можно ли переименовывать файл?
    if @storage.is_file_use?(dir, old_file)
      # Переименовываем название файла (физическое на storage-сервере)
      if (old_file != new_file)
        @storage.rename(
          dir + '/' + old_file,
          dir + '/' + new_file)
        filename = new_file
      end
    end

    # Меняем свойства файла (на уровне модели)
    @storage.change_properties_file(dir, filename, title, descr, tags, authors)

    respond = {}
    render json: respond.to_json

  end

  # Действие delete
  # Удаление файла с сервера
  # 
  # * *Args*    :
  #   - +dir+ String путь (относительно папки media)
  #           к каталогу, из которого удаляется файл
  #   - +file+ String название файла
  # * *Returns* :
  #   - JSON-ответ для отдачи клиенту
  #
  def delete_file(dir, file)
    respond = @storage.file_unlink(dir + '/' + file)
    render json: respond.to_json
  end

  # Действие cp_cbd
  # Копирование файлов из буфера обмена в папку
  # 
  # * *Args*    :
  #   - +dir+ String путь (относительно папки media)
  #           к каталогу на сервере, где расположен файл
  #   - +file+ Array список файлов, которые необходимо скопировать
  # * *Returns* :
  #   - JSON-ответ для отдачи клиенту
  #
  def copy_files(dir, files)
    @storage.copy_files(dir, files)
    respond = {}
    render json: respond.to_json
  end

  # Действие mv_cbd
  # Перенос файлов из буфера обмена в папку
  # 
  # * *Args*    :
  #   - +dir+ String путь (относительно папки media)
  #           к каталогу на сервере, где расположен файл
  #   - +file+ Array список файлов, которые необходимо переместить
  # * *Returns* :
  #   - JSON-ответ для отдачи клиенту
  #
  def move_files(dir, files)
    @storage.move_files(dir, files)
    respond = {}
    render json: respond.to_json
  end

  # Действие rm_cbd
  # Удаление файлов, отмеченных в буфере обмена
  # 
  # * *Args*    :
  #   - +file+ Array список файлов, которые необходимо удалить
  # * *Returns* :
  #   - JSON-ответ для отдачи клиенту
  #
  def delete_files(files)
    @storage.delete_files(files)
    respond = {}
    render json: respond.to_json
  end

  # Действие downloadClipboard
  # Загрузка архива с файлами
  # 
  # * *Args*    :
  #   - +files+ Array список файлов, которые необходимо упаковать в архив
  # * *Returns* :
  #   - ZIP-архив
  #
  def download_files(files)
    zip = @storage.download_files(files)

    # Формируем MIME-тип
    content_type = @storage.mime zip

    # Формируем HTTP-заголовки
    response.headers['Content-Type'] = content_type
    response.headers['Content-Disposition'] = "attachment; filename=clipboard.zip"

    render text: open(zip, "rb").read, layout: false
  end

  # Действие downloadDir
  # Загрузка архива с содержимым директории
  # 
  # * *Args*    :
  #   - +dir+ String путь (относительно папки media) к архивируемому каталогу
  # * *Returns* :
  #   - true
  #
  def download_dir(dir)
    zip = @storage.download_dirs(dir, "")

    # Формируем MIME-тип
    content_type = @storage.mime zip
    # Формируем HTTP-заголовки
    response.headers['Content-Type'] = content_type
    response.headers['Content-Disposition'] = "attachment; filename=#{File.basename(dir)}.zip"

    render text: open(zip, "rb").read, layout: false
  end

  # Действие expand
  # "Раскрытие" текущего каталога - отображаем подкаталоги и файлы
  # 
  # * *Args*    :
  #   - +dir+ String путь (относительно папки media) к раскрываемому каталогу
  # * *Returns* :
  #   - JSON-ответ для отдачи клиенту
  #
  def expand(dir)
    respond = {
      dirs: @storage.dirs_list(dir)
    }
    render json: respond.to_json
  end

  # Действие chDir
  # Смена текущего каталога
  # 
  # * *Args*    :
  #   - +dir+ String путь (относительно папки media) к каталогу, в который переходит пользователь
  # * *Returns* :
  #   - JSON-ответ для отдачи клиенту
  #
  def ch_dir(dir)
    respond = {
      files: @storage.files_list(dir),
      dirWritable: @storage.is_writable_dir?(dir)}
    render json: respond.to_json
  end

  # Действие newDir
  # Создание нового подкаталога
  # 
  # * *Args*    :
  #   - +dir+ String путь (относительно папки media) к каталогу, в котором создается новый подкаталога
  #   - +new_dir+ String имя нового подкаталога
  # * *Returns* :
  #   - JSON-ответ для отдачи клиенту
  #
  def new_dir(dir, new_dir)
    @storage.mkdir(dir + '/' + @storage.sanitizer(new_dir))
    respond = {}
    render json: respond.to_json
  end

  # Действие renameDir
  # Переименование каталога
  # 
  # * *Args*    :
  #   - +old_dir+ String путь (относительно папки media) к переименовываемум каталогу
  #   - +new_dir+ String новое название каталога
  # * *Returns* :
  #   - JSON-ответ для отдачи клиенту
  #
  def rename_dir(old_dir, new_dir)
    new_dir = @storage.sanitizer(new_dir)
    respond = @storage.rename(old_dir, File.dirname(old_dir) + '/' + new_dir)
    render json: respond.to_json
  end

  # Действие deleteDir
  # Удаление каталога и всех вложенных подкаталогов
  # 
  # * *Args*    :
  #   - +dir+ String путь (относительно папки media) к удаляемому каталогу
  # * *Returns* :
  #   - JSON-ответ для отдачи клиенту
  # 
  def delete_dir(dir)
    @storage.rmdir(dir)
    respond = {}
    render json: respond.to_json
  end

  ##############################################################
  # Вспомогательные функции для пространства Backend::Media
  ##############################################################

  def check_employee_abilities!
    true
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
  
end