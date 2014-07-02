module Parsers
  module Extractor
    extend ActiveSupport::Concern

    included do
      # Извлечение из кода страницы списка годов проведения лиги/турнира
      #
      # @param [Object] page - страница в формате Nokogiri
      # @return [Hash] - ключ: год начала, значение: название сезона
      # @example - {"2006"=>"2006/2007", "2007"=>"2007/2008", "2008"=>"2008/2009", "2009"=>"2009/2010", "2010"=>"2010/2011", "2011"=>"2011/2012", "2012"=>"2012/2013", "2013"=>"2013/2014"}
      #
      def extract_years(page)
        page.css('#tournir_year_selector option').reduce({}) do |result, option|
          result[option[:value]] = option.children.text
          result
        end
      end

      # Извлечение из кода страницы списка лиг/турниров по годам
      #
      # @param [Object] page - страница в формате Nokogiri
      # @param [Hash] years - список годов проведения лиг/турниров, полученный в методе get_years
      # @return [Hash] - ключ: год начала сезона, значение: массив хешей, содержащих :id, :url, :title турнира
      # @example - {"2006"=>[{:id=>9, :url=>"/football/_germany/9/table/all.html", :title=>"Бундеслига"}], "2007"=>[{:id=>25, :url=>"/football/_germany/25/table/all.html", :title=>"Бундеслига"}], "2008"=>[{:id=>60, :url=>"/football/_germany/60/table/all.html", :title=>"Бундеслига"}], "2009"=>[{:id=>100, :url=>"/football/_germany/100/table/all.html", :title=>"Бундеслига"}, {:id=>135, :url=>"/football/_germany/135/table/all/playoff.html", :title=>"Кубок Германии"}, {:id=>190, :url=>"/football/_germany/190/table/all/playoff.html", :title=>"Переходные матчи"}, {:id=>200, :url=>"/football/_germany/200/table/all/playoff.html", :title=>"Суперкубок Германии"}], "2010"=>[{:id=>224, :url=>"/football/_germany/224/table/all.html", :title=>"Бундеслига"}, {:id=>264, :url=>"/football/_germany/264/table/all/playoff.html", :title=>"Кубок Германии"}, {:id=>352, :url=>"/football/_germany/352/table/all/playoff.html", :title=>"Переходные матчи"}, {:id=>376, :url=>"/football/_germany/376/table/all/playoff.html", :title=>"Суперкубок Германии"}], "2011"=>[{:id=>392, :url=>"/football/_germany/392/table/all.html", :title=>"Бундеслига"}, {:id=>443, :url=>"/football/_germany/443/table/all/playoff.html", :title=>"Кубок Германии"}, {:id=>516, :url=>"/football/_germany/516/table/all/playoff.html", :title=>"Переходные матчи"}, {:id=>558, :url=>"/football/_germany/558/table/all/playoff.html", :title=>"Суперкубок Германии"}], "2012"=>[{:id=>564, :url=>"/football/_germany/564/table/all.html", :title=>"Бундеслига"}, {:id=>655, :url=>"/football/_germany/655/table/all/playoff.html", :title=>"Кубок Германии"}, {:id=>745, :url=>"/football/_germany/745/table/all/playoff.html", :title=>"Переходные матчи"}, {:id=>801, :url=>"/football/_germany/801/table/all/playoff.html", :title=>"Суперкубок Германии"}], "2013"=>[{:id=>769, :url=>"/football/_germany/769/table/all.html", :title=>"Бундеслига"}, {:id=>906, :url=>"/football/_germany/906/table/all/playoff.html", :title=>"Кубок Германии"}]}
      #
      def extract_leagues(page, years)
        years.reduce({}) do |result, (key, _)|
          result[key] = page.css("select.sport__list-selector_#{key} option").reduce([]) do |inner_result, option|
            inner_result << {
              id:           option[:id].gsub(/^t_/, '').to_i,
              url:          option[:value],
              title:        option.children.text,
              is_published: 1
            }
            inner_result
          end
          result
        end
      end

      # Извлечение из кода страницы списка команд
      #
      # @param [Object] page - страница в формате Nokogiri
      # @return [Array of Hash] - хеши содержат ключи: :url (страница команды), :image_url (ссылка на лого), :title и :city
      # @example - [{:url=>"/football/_germany/769/team/16827/result.html", :image_url=>"http://img.championat.com/team/logo/136732639523440125_eintracht_logo.jpg", :title=>"Айнтрахт Б", :city=>"Брауншвейг"}, {:url=>"/football/_germany/769/team/16797/result.html", :image_url=>"http://img.championat.com/team/logo/12822540991176996855_eintracht.jpg", :title=>"Айнтрахт Ф", :city=>"Франкфурт-на-Майне"}, {:url=>"/football/_germany/769/team/16821/result.html", :image_url=>"http://img.championat.com/team/logo/12913986591584440469_augsburg.jpg", :title=>"Аугсбург", :city=>"Аугсбург"}, {:url=>"/football/_germany/769/team/16807/result.html", :image_url=>"http://img.championat.com/team/logo/12822538381375074524_bavaria.jpg", :title=>"Бавария", :city=>"Мюнхен"}, {:url=>"/football/_germany/769/team/16811/result.html", :image_url=>"http://img.championat.com/team/logo/1282253876578011760_bayer.jpg", :title=>"Байер", :city=>"Леверкузен"}, {:url=>"/football/_germany/769/team/16809/result.html", :image_url=>"http://img.championat.com/team/logo/12822540131421501523_dortmund.jpg", :title=>"Боруссия Д", :city=>"Дортмунд"}, {:url=>"/football/_germany/769/team/16801/result.html", :image_url=>"http://img.championat.com/team/logo/1282254532918411258_monchengladbah.jpg", :title=>"Боруссия М", :city=>"Мёнхенгладбах"}, {:url=>"/football/_germany/769/team/16819/result.html", :image_url=>"http://img.championat.com/team/logo/12822548221740848630_werder.jpg", :title=>"Вердер", :city=>"Бремен"}, {:url=>"/football/_germany/769/team/16813/result.html", :image_url=>"http://img.championat.com/team/logo/1282254853200100958_wolfsburg.jpg", :title=>"Вольфсбург", :city=>"Вольфсбург"}, {:url=>"/football/_germany/769/team/16799/result.html", :image_url=>"http://img.championat.com/team/logo/1282254198761665181_gamburg.jpg", :title=>"Гамбург", :city=>"Гамбург"}, {:url=>"/football/_germany/769/team/16803/result.html", :image_url=>"http://img.championat.com/team/logo/1282254339408721548_hannover.jpg", :title=>"Ганновер-96", :city=>"Ганновер"}, {:url=>"/football/_germany/769/team/16825/result.html", :image_url=>"http://img.championat.com/team/logo/13812432011161765344_hertha.jpg", :title=>"Герта", :city=>"Берлин"}, {:url=>"/football/_germany/769/team/16817/result.html", :image_url=>"http://img.championat.com/team/logo/12822545071106762912_mainz.jpg", :title=>"Майнц", :city=>"Майнц"}, {:url=>"/football/_germany/769/team/16805/result.html", :image_url=>"http://img.championat.com/team/logo/13763193251302363817_fcn.jpg", :title=>"Нюрнберг", :city=>"Нюрнберг"}, {:url=>"/football/_germany/769/team/16795/result.html", :image_url=>"http://img.championat.com/team/logo/1282254164662026411_freiburg.jpg", :title=>"Фрайбург", :city=>"Фрайбург"}, {:url=>"/football/_germany/769/team/16823/result.html", :image_url=>"http://img.championat.com/team/logo/1282254378624796140_hoffenhaim.jpg", :title=>"Хоффенхайм", :city=>"Зинсхайм"}, {:url=>"/football/_germany/769/team/16793/result.html", :image_url=>"http://img.championat.com/team/logo/12822546291562164277_shalke.jpg", :title=>"Шальке-04", :city=>"Гельзенкирхен"}, {:url=>"/football/_germany/769/team/16815/result.html", :image_url=>"http://img.championat.com/team/logo/12822547891518089897_stuttgart.jpg", :title=>"Штутгарт", :city=>"Штутгарт"}]
      #
      def extract_teams(page)
        page.css('.sport__tiles__i').inject([]) do |result, cur_team|
          result << {
            url:          cur_team[:href],
            image_url:    cur_team.css('img')[0][:src],
            title:        cur_team.css('strong')[0].children.text,
            city:         cur_team.css('span')[0].children.text,
            is_published: 1
          }
          result
        end
      end

      # Извлечение из кода информации об игроках
      #
      # @param [Object] page - страница в формате Nokogiri
      # @return [Array of Hash] - информация об игроках
      # @example - [{:name=>"Мохаммед  Абделлауйе", :image_url=>"http://img.championat.com/team/player/13596684421737610028_abdellaoue.jpg", :number=>"25", :amplua=>"нападающий", :citizenship=>"Норвегия", :birthday=>"23.10.1985", :height=>"184", :weight=>"82"}]
      #
      def extract_players(page)
        page.css('.sport__table')[0].css('tr td a').inject([]) do |result, cur_player|
          player_info = load_html(cur_player[:href]).css('.sport__info')
          player_info.css('span').remove
          image_url = player_info.css('.sport__info__image img')[0][:src]
          player_info.css('.sport__info__image img').remove
          puts "          #{player_info.css('.sport__info__name')[0].children.text}"
          data = player_info.css('.sport__info__data__i')
          result << {
            name:         player_info.css('.sport__info__name')[0].children.text.strip,
            image_url:    image_url,
            # number:       player_info.css('img')[0][:src].gsub(/[^\d]+/, ''),
            amplua:       data[0].children.text.strip,
            citizenship:  data[1] ? data[1].children.text.strip.gsub(/\s{2,}/, ' ') : 'неизвестно',
            birthday:     data[2] ? data[2].children.text.strip : 'неизвестно',
            height:       data[3] ? data[3].children.text.gsub(/[^\d]+/, '') : 'неизвестно',
            weight:       data[4] ? data[4].children.text.gsub(/[^\d]+/, '') : 'неизвестно',
            is_published: 1
          }
          result
        end
      end

      # Извлечение из кода информации о команде
      #
      # @param [Object] page - страница в формате Nokogiri
      # @return [String] - информация о команде
      #
      def extract_team_info(page)
        desc = page.css('.sport__info__desc')[0].children.text.strip
        info = page.css('.sport__info__data__i').inject('') do |result, cur_line|
          "#{result} | #{cur_line.children.text.gsub(/\s{2,}/, ' ').strip}"
        end
        result = "#{desc}#{info}".split(' | ')
        result.pop
        result.join('</p><p>')
      end

      # Извлечение из кода информации о группах(турах)
      #
      # @param [Object] page - страница в формате Nokogiri
      # @return [Array of Hash] - информация о группах(турах)
      #
      def extract_groups(page)
        page.css('.sport__table._big').inject([]) do |result, cur_group|
          schedule = cur_group.css('.table')[0]
          date_at = schedule.css('.sport__date')[0].children.text.strip.split /\s+/
          result << {
            title:    cur_group.css('.sport__table__head')[0].children.text.strip,
            date_at:  Date.parse("#{date_at[2]}-#{rus_month_to_num(date_at[1])}-#{date_at[0]}"),
            schedule: schedule
          }
          result
        end
      end

      # Извлечение из расписания группы(тура) информации о матчах
      #
      # @param [Object] page - расписание группы(тура) в формате Nokogiri
      # @return [Array of Hash] - информация о матчах
      # @example - [{:team_home_title=>"Амкар", :team_guest_title=>"Краснодар", :count_home=>nil, :count_guest=>nil, :date=>Thu, 15 May 2014, :start_at=>2014-05-15 18:30:00 +0400}, ...]
      #
      def extract_matches(schedule)
        cur_date = ''
        schedule.css('tr').inject([]) do |result, cur_row|
          date = cur_row.css('.sport__date')
          if date.length > 0
            date = date[0].children.text.strip.split /\s+/
            cur_date = Date.parse("#{date[2]}-#{rus_month_to_num(date[1])}-#{date[0]}")
          else
            match = cur_row.css('td')
            time = match[0].children.text.strip
            time = if time == '––:––'
                     nil
                   else
                     Time.parse("#{cur_date} #{time}:00")
                   end
            teams = match[1].css('a')
            score = match[2].children.text.strip.split ':'
            result << {
              team_home_title:  teams[0].children.text.strip,
              team_guest_title: teams[1].children.text.strip,
              count_home:       score[0] == '–' ? nil : score[0].to_i,
              count_guest:      score[1] == '–' ? nil : score[1].to_i,
              date:             cur_date,
              start_at:         time,
              is_published: 1
            }
          end
          result
        end
      end # extract_matches
    end # included
  end # Extractor
end # Parsers