module Parsers
  module Creator
    extend ActiveSupport::Concern

    included do
      # Парсинг лиг
      #
      # @param [Object] category    - текущая категория
      # @param [Object] country     - текущая страна
      # @param [String] url         - ссылка с которой парсим
      # @param [String] name_prefix - необязательное начало названия лиги
      # @return [NilClass]
      #
      def parse_leagues(category, country, url, name_prefix = '')
        page    = load_html(url)               # загружаем страницу
        years   = extract_years(page)          # парсим сезоны
        leagues = extract_leagues(page, years) # парсим лиги по сезонам
        # заводим счетчик, чтобы на последнем круге запустить парсинг команд
        league_num = 0
        # сохраняем
        # в цикле inject необходимо указывать стартовое значение результата (nil),
        # иначе за него будет принято первое значение хеша и оно будет пропущено в цикле
        leagues.inject(nil) do |_, (cur_year, cur_year_leagues)|
          league_num += 1
          cur_year_leagues.each do |cur_league|
            # находим или создаем лигу
            league = League.where(title: "#{name_prefix}#{cur_league[:title]}", country_id: country.id, category_id: category.id).first_or_create!(content: "#{name_prefix}#{cur_league[:title]}")
            # добавляем связь лиги с сезоном
            year = Year.where(league_year: cur_year, league_id: league.id).first_or_create!(title: years[cur_year])
            if league_num == leagues.length
              parse_teams(category, country, cur_league)
              parse_league_groups(cur_league, category, country, league, year)
            end
          end
        end
      end

      # Парсинг групп(туров)
      #
      # @param [Hash] league_info - инфо о лиге, с которой парсим команды. Необходимые ключи: {:id, :url}
      # @param [Object] category  - категория
      # @param [Object] country   - страна
      # @param [Object] league    - лига
      # @param [Object] year      - год(сезон)
      # @return [NilClass]
      #
      def parse_league_groups(league_info, category, country, league, year)
        puts '      Группы'
        # формируем ссылку
        url = "#{league_info[:url].gsub(/#{league_info[:id]}.*$/, league_info[:id].to_s)}/calendar/tour.html"
        # загружаем страницу
        page = load_html(url)
        # парсим и сохраняем группы
        extract_groups(page).inject(nil) do |_, cur_group|
          group = LeaguesGroup.where(year_id: year.id, league_id: league.id, title: cur_group[:title], date_at: cur_group[:date_at]).first_or_create!
          # парсим и сохраняем матчи группы
          extract_matches(cur_group[:schedule]).inject(nil) do |_, cur_match|
            match = Match.new({
              title:       "#{cur_match[:team_home_title]} - #{cur_match[:team_guest_title]}",
              count_home:  cur_match[:count_home],
              count_guest: cur_match[:count_guest],
              date_at:     cur_match[:date],
              start_at:    cur_match[:start_at],
              is_published: 1
            })
            match.leagues_group = group
            match.team_home  = Team.where(title: cur_match[:team_home_title], country_id: country.id, category_id: category.id).first
            match.team_guest = Team.where(title: cur_match[:team_guest_title], country_id: country.id, category_id: category.id).first
            match.save!
          end
        end
      end

      # Парсинг команд
      #
      # @param [Object] category  - текущая категория
      # @param [Object] country   - текущая страна
      # @param [Hash] league_info - инфо о лиге, с которой парсим команды. Необходимые ключи: {:id, :url}
      # @return [NilClass]
      #
      def parse_teams(category, country, league_info)
        puts '      Команды'
        # формируем ссылку
        url = "#{league_info[:url].gsub(/#{league_info[:id]}.*$/, league_info[:id].to_s)}/teams.html"
        # загружаем страницу
        page = load_html(url)
        # парсим команды
        extract_teams(page).inject(nil) do |_, cur_team|
          subtitle = cur_team[:city].blank? ? cur_team[:title] : "#{cur_team[:title]} (#{cur_team[:city]})"
          puts "        #{subtitle}"
          team = Team.includes(:main_image)
                     .where(title: cur_team[:title], subtitle: subtitle, country_id: country.id, category_id: category.id, is_published: 1)
                     .first_or_create! do |this|
                       # определяем id команды на сайте-источнике
                       team_id = cur_team[:url].scan(/\d+/).last
                       # формируем ссылку
                       team_info_url = "#{cur_team[:url].gsub(/#{team_id}.*?$/, team_id)}/result.html"
                       # загружаем информацию
                       this.content = "<p>#{extract_team_info(load_html(team_info_url))}</p>"
                     end
          update_team_image(team, cur_team) if @load_main_image && team.main_image.nil?

          parse_players(cur_team[:url], team) #if ['Локомотив (Москва)'].include? subtitle
        end
      end

      # Парсинг игроков
      #
      # @param [String] team_url - ссылкв на страницу текущей команды
      # @param [Object] team     - текущая команда
      # @return [NilClass]
      #
      def parse_players(team_url, team)
        team_id = team_url.scan(/\d+/).last
        # формируем ссылку
        players_url = "#{team_url.gsub(/#{team_id}.*?$/, team_id)}/players.html"
        # загружаем страницу и парсим игроков
        extract_players(load_html players_url).inject(nil) do |_, cur_player|
          names = cur_player[:name].split(/\s+/, 3)
          if names.length == 2
            name_first, name_last = names
            name_v = nil
          else
            name_first, name_v, name_last = names
          end
          content = "Гражданство: #{cur_player[:citizenship]}, День рождения: #{cur_player[:birthday]}, Рост: #{cur_player[:height]} см, Вес: #{cur_player[:weight]} кг"
          player = Person.includes(:main_image, :teams, :character)
                         .where(name_first: name_first, name_last: name_last, name_v: name_v, content: content).first
          unless player
            role = Character.where(title: cur_player[:amplua]).first_or_create!
            player = Person.new(name_first: name_first, name_last: name_last, name_v: name_v, content: content, is_published: 1)
            player.character = role
            player.teams << team
            player.save!
          end
          update_player_image(player, cur_player) if @load_main_image && player.main_image.nil?
        end
      end
    end # included

    # Создание логотипа команды
    #
    # @param [Object] team   - текущая команда
    # @param [Hash] cur_team - хэш с информацией о команде, содержащий ключи :name и :image_url
    # @return [NilClass]
    #
    def update_team_image(team, cur_team)
      if logo = logo_exists?(team.id, 'teams')
        insert_main_image(team, logo, 'Team::MainImage')
      else
        puts "        Фото для #{cur_team[:name]}"
        file = load_file cur_team[:image_url]
        team.put_image File.new(file)
        File.delete file
      end
    end

    # Создание фото игрока
    #
    # @param [Object] player   - текущий игрок
    # @param [Hash] cur_player - хэш с информацией об игроке, содержащий ключи :name и :image_url
    # @return [NilClass]
    #
    def update_player_image(player, cur_player)
      if logo = logo_exists?(player.id, 'persons')
        insert_main_image(player, logo, 'Person::MainImage')
      else
        puts "        Фото для #{cur_player[:name]}"
        file = load_file cur_player[:image_url]
        player.put_image File.new(file)
        File.delete file
      end
    end

    # Принудительное создание записи в таблице media_files для файлов, уже загруженных на sftp-сервер ранее
    #
    # @param [Object] resource - объект, для которого создается запись
    # @param [Hash] file       - хэш с информацией о файле на сервере. Обязательные ключи - :path, :name, :mime, :size, :time
    # @param [String] model    - название модели, обрабатывающей изображение
    # @return [NilClass]
    #
    def insert_main_image(resource, file, model)
      ActiveRecord::Base.connection.execute(
        "INSERT INTO media_files
           (media_file_id, class_name, file_file_path, file_file_name, file_content_type, file_file_size, created_at, updated_at)
         VALUES(#{resource.id}, '#{model}', '#{file[:path]}', '#{file[:name]}', '#{file[:mime]}', #{file[:size]}, FROM_UNIXTIME(#{file[:time]}), FROM_UNIXTIME(#{file[:time]}))"
      )
    end #insert_main_image

  end # creator
end # Parsers