# encoding: utf-8
namespace :parse do

  desc 'Парсит данные с разных сайтов'
  task all: :environment do
    puts 'parsing started'

    sources = {
      categories: [{
        name:      'Футбол',
        countries: [{
        #  name:    'Весь мир',
        #  leagues: [{
        #    name:   'Чемпионат мира',
        #    url:    'http://www.championat.com/football/_worldcup.html',
        #    parser: Parsers::ChampionatCom
        #  },{
        #    name:   'Лига чемпионов',
        #    url:    'http://www.championat.com/football/_ucl.html',
        #    parser: Parsers::ChampionatCom
        #  },{
        #    name:  'Лига Европы',
        #    url:   'http://www.championat.com/football/_europeleague.html',
        #    parser: Parsers::ChampionatCom
        #  }]
        #},{
          name:    'Россия',
          leagues: [{
            name:  'Премьер-Лига',
            url:   'http://www.championat.com/football/_russiapl.html',
            parser: Parsers::ChampionatCom
          },{
           name:  'Кубок России',
           url:   'http://www.championat.com/football/_russiacup.html',
           parser: Parsers::ChampionatCom
          # },{
          #  name:  'ФНЛ - Первый дивизион',
          #  url:   'http://www.championat.com/football/_russia1d.html',
          #  parser: Parsers::ChampionatCom
          #},{
          #  name:  'ПФЛ - Второй дивизион',
          #  url:   'http://www.championat.com/football/_russia2d.html',
          #  parser: Parsers::ChampionatCom
          #},{
          #  name:  'Молодёжное первенство',
          #  url:   'http://www.championat.com/football/_junior.html',
          #  parser: Parsers::ChampionatCom
          }]
        #},{
        #  name:  'Германия',
        #  url:   'http://www.championat.com/football/_germany.html',
        #  parser: Parsers::ChampionatCom
        #},{
        #  name:  'Франция',
        #  url:   'http://www.championat.com/football/_france.html',
        #  parser: Parsers::ChampionatCom
        #},{
        #  name:  'Испания',
        #  url:   'http://www.championat.com/football/_spain.html',
        #  parser: Parsers::ChampionatCom
        #},{
        #  name:  'Италия',
        #  url:   'http://www.championat.com/football/_italy.html',
        #  parser: Parsers::ChampionatCom
        #},{
        #  name:  'Англия',
        #  url:   'http://www.championat.com/football/_england.html',
        #  parser: Parsers::ChampionatCom
        }]
      #},{
      #  name:      'Хоккей',
      #  countries: [{
      #    name:    'Весь мир',
      #    leagues: [{
      #      name:  'Чемпионат мира',
      #      url:   'http://www.championat.com/hockey/_whc.html',
      #      parser: Parsers::ChampionatCom
      #    },{
      #      name:  'Евротур',
      #      url:   'http://www.championat.com/hockey/_eurotour.html',
      #      parser: Parsers::ChampionatCom
      #    }]
      #  },{
      #    name:    'Россия',
      #    leagues: [{
      #      name:  'КХЛ',
      #      url:   'http://www.championat.com/hockey/_superleague.html',
      #      parser: Parsers::ChampionatCom
      #    },{
      #      name:  'МХЛ',
      #      url:   'http://www.championat.com/hockey/_mhl.html',
      #      parser: Parsers::ChampionatCom
      #    },{
      #      name:  'ВХЛ',
      #      url:   'http://www.championat.com/hockey/_highleague.html',
      #      parser: Parsers::ChampionatCom
      #    }]
      #  },{
      #    name:    'Северная Америка',
      #    leagues: [{
      #      name:  'НХЛ',
      #      url:   'http://www.championat.com/hockey/_nhl.html',
      #      parser: Parsers::ChampionatCom
      #    }]
      #  }]
      }]
    }

    # Перебираем заданные виды спорта
    sources[:categories].each do |cur_category|
      puts cur_category[:name]

      # Загружаем текущую категорию
      category = Category.find_or_create_by_title(cur_category[:name])
      # category = Category.find_by_title(cur_category[:name]) || begin
      #   # или создаем, если она не найдена
      #   Category.create!({title: cur_category[:name]})
      # end

      # Перебираем заданные в текущем виде спорта страны
      cur_category[:countries].each do |cur_country|
        puts "  #{cur_country[:name]}"

        # Загружаем текущую страну
        country = Country.find_by_title(cur_country[:name]) || begin
          # или создаем, если она не найдена
          temp = Country.new({title: cur_country[:name]})
          temp.categories << category
          temp.save!
          temp
        end

        # Если в параметрах текущей страны переданы :url и :parser,
        # значит вложенность закончилась.
        # Парсим лиги текущей страны.
        if cur_country[:url] && cur_country[:parser]
          cur_country[:parser].new.parse_leagues category, country, cur_country[:url]

        # иначе, перебираем заданные в текущей стране лиги
        else
          cur_country[:leagues].each do |cur_league|
            puts "    #{cur_league[:name]}"

            # Если в параметрах текущей лиги переданы :name, :url и :parser,
            # парсим турниры текущей лиги, Название лиги передаем как префикс.
            if cur_league[:name] && cur_league[:url] && cur_league[:parser]
              cur_league[:parser].new.parse_leagues category, country, cur_league[:url], "#{cur_league[:name]}. "
            end
          end
        end
      end
    end

    puts 'parsing finished'
  end

end