module Parsers
  module FileLoader
    extend ActiveSupport::Concern

    included do

      # Загрузка файла по ссылке и сохранение локально во временную дирректорию
      #
      # @param url [String] ссылка на файл
      # @return [String] имя сохраненного локального файла
      #
      def load_file(url)

        tmp = 'tmp/files'
        Dir.mkdir(Rails.root.join(tmp)) unless Rails.root.join(tmp).exist?
        url = File.join(@base_url, url) unless url[0..6] == 'http://'

        uri = URI.parse(url)
        file = Rails.root.join(tmp, File.basename(uri.path))

        File.open(file, 'wb') do |f|
          Net::HTTP.start(uri.host, uri.port) do |http|
            http.request_get(uri.path) do |res|
              res.read_body do |seg|
                f << seg
              end
            end
          end
        end
        file
      end

      # Проверка нет ли на sftp-сервере загруженного лого для запрошенной команды, и всех необходимых размеров изображений.
      #
      # @param [Integer] parent_id - ID команды
      # @return [FalseClass|Hash] - false в случае отсутстывия, либо хеш со свойствами файла на сервере
      #
      def logo_exists? parent_id, table_name
        Net::SFTP.start(FILE_STORAGE['sftp']['host'], FILE_STORAGE['sftp']['user'], password: FILE_STORAGE['sftp']['password']) do |sftp|
          begin
            files = []
            original = nil
            sftp.dir.foreach("#{FILE_STORAGE['sftp']['path']}/media/#{table_name}/#{parent_id}/") do |entry|
              files << entry.name if entry.longname[0] != 'd'
              original = entry if /_original\.(jpe?g|gif|png)$/ =~ entry.name
            end
            return false unless original
            all_exists = true
            base_name = original.name.gsub(/_original\.(jpe?g|gif|png)$/, '')
            ext = original.name.scan(/[^\.]+$/)[0]
            sizes = case table_name
                      when 'teams'
                        then %w(_620x345 _435x260 _300x200 _140x80 _150x150 _90x90 _65x65 thumb)
                      when 'persons'
                        then %w(_620x345 _435x260 _300x200 _140x80 _150x150 _90x90 _68x68 _48x48 thumb)
                    end
            sizes.each do |size|
              all_exists = false unless files.include? "#{base_name}_#{size}.#{ext}"
            end
            if all_exists
              return {
                path: "media/#{table_name}/#{parent_id}",
                name: "#{base_name}.#{ext}",
                mime: "image/#{ext == 'jpg' ? 'jpeg' : ext.downcase}",
                size: original.attributes.size,
                time: original.attributes.atime
              }
            else
              return false
            end
          rescue Net::SFTP::StatusException
            false
          end
        end
      end

      # Преобразование русского названия месяца в его номер
      #
      # @param [String] month - название месяца
      # @return [String] - номер месяца в году в формате mm
      #
      def rus_month_to_num(month)
        month.gsub('января',   '01')
             .gsub('февраля',  '02')
             .gsub('марта',    '03')
             .gsub('апреля',   '04')
             .gsub('мая',      '05')
             .gsub('июня',     '06')
             .gsub('июля',     '07')
             .gsub('августа',  '08')
             .gsub('сентября', '09')
             .gsub('октября',  '10')
             .gsub('ноября',   '11')
             .gsub('декабря',  '12')
      end

    end
  end
end