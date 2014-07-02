# encoding: utf-8


######################################################################
# Статусы инсада
######################################################################
def seed_inside_statuses
  ActiveRecord::Base.connection.execute('TRUNCATE TABLE `inside_statuses`')
  ['Переговоры ведутся', 'Слухи', 'Официально'].each do |status|
    if status === 'Официально'
      color = 'green'
    else
      color = 'red'
    end
    InsideStatus.create!({title: status, color: color})
  end

end


######################################################################
# Категории контента
######################################################################
def seed_categories
  ActiveRecord::Base.connection.execute('TRUNCATE TABLE `categories`')
  ActiveRecord::Base.connection.execute('TRUNCATE TABLE `categories_countries`')
  arr = []
  arr << {title: 'Футбол', is_published: 1, color: 'green_page'}
  arr << {title: 'Хоккей', is_published: 1, color: 'blue_page'}
  Category.create arr
end

######################################################################
# Загрузка категорий используемых при заполнении таблицы leagues
######################################################################
def load_categories
  cat_objects = Category.where("title IN ('Футбол','Хоккей')")
  cats = {}
  cat_objects.each{|cat| cats[cat.title] = cat}
  cats
end

######################################################################
# Страны
######################################################################
def seed_countries
  ActiveRecord::Base.connection.execute('TRUNCATE TABLE `countries`')
  ActiveRecord::Base.connection.execute('TRUNCATE TABLE `categories_countries`')
  countries = [{
    title: 'Россия',
    categories: %w(Футбол Хоккей),
  }, {
    title: 'Англия',
    categories: %w(Футбол Хоккей),
  }, {
    title: 'Испания',
    categories: %w(Хоккей),
  }, {
    title: 'Италия',
    categories: %w(Футбол Хоккей),
  }, {
    title: 'Германия',
    categories: %w(Футбол),
  }, {
    title: 'Франция',
    categories: %w(Футбол Хоккей),
  }, {
    title: 'Украина',
    categories: %w(Хоккей),
  }, {
    title: 'Португалия',
    categories: %w(Футбол Хоккей),
  }, {
    title: 'Шотландия',
    categories: %w(Футбол),
  }, {
    title: 'Бельгия',
    categories: %w(Хоккей),
  }, {
    title: 'Турция',
    categories: %w(Футбол Хоккей),
  }, {
    title: 'Голландия',
    categories: %w(Футбол),
  }, {
    title: 'Румыния',
    categories: %w(Футбол Хоккей),
  }]

  categories = load_categories
  countries.each do |current_country|
    country = Country.new({title: current_country[:title]})
    current_country[:categories].each do |cat|
      country.categories << categories[cat]
    end
    country.save
  end
end

######################################################################
# Загрузка стран
######################################################################
def load_countries
  Country.all.inject({}) do |result, country|
    result[country.title] = country
    result
  end
end

######################################################################
# Года
######################################################################
def seed_years
  ActiveRecord::Base.connection.execute('TRUNCATE TABLE years')
  years = (1980..2015).to_a.map{|year| {league_year: year} }
  Year.create!(years)
end

######################################################################
# Лиги
######################################################################
def seed_leagues
  years = Year.all
  leagues = []
  leagues << {category: 'Футбол', country: 'Россия', title: 'Премьер-Лига', content: 'какое-то описание,', is_published: 1}
  leagues << {category: 'Футбол', country: 'Англия', title: 'Чемпионат Англии', content: 'какое-то описание,', is_published: 1}
  leagues << {category: 'Футбол', country: 'Германия', title: 'Чемпионат Германии', content: 'не знаю что в нем должно быть.', is_published: 1}
  leagues << {category: 'Футбол', country: 'Испания', title: 'Чемпионат Испании', content: 'Вероятно какая-то история', is_published: 1}
  leagues << {category: 'Футбол', country: 'Италия', title: 'Чемпионат Италии', content: 'происхождения турнира', is_published: 1}
  leagues << {category: 'Футбол', country: 'Франция', title: 'Чемпионат Франции', content: 'или еще какая-то ерунда.', is_published: 1}
  leagues << {category: 'Хоккей', country: 'Россия', title: 'КХЛ. Регулярный чемпионат.', content: 'Возможно даже тут могут', is_published: 1}
  leagues << {category: 'Хоккей', country: 'Португалия', title: 'ВХЛ. Регулярный чемпионат.', content: 'перечисляться награды', is_published: 1}
  leagues << {category: 'Хоккей', country: 'Россия', title: 'МХЛ. Регулярный чемпионат.', content: 'вручаемые победителям', is_published: 1}
  leagues << {category: 'Хоккей', country: 'Англия', title: 'НХЛ. Регулярный чемпионат.', content: 'победители разных лет', is_published: 1}
  leagues << {category: 'Хоккей', country: 'Россия', title: 'Чемпионат мира', content: 'возможно даже связанные курьезы', is_published: 1}
  leagues << {category: 'Хоккей', country: 'Россия', title: 'Молодежный чемпионат мира', content: 'или самые тяжелые травмы', is_published: 1}
  ActiveRecord::Base.connection.execute('TRUNCATE TABLE `leagues`')
  # ActiveRecord::Base.connection.execute('TRUNCATE TABLE `years`')

  years = Year.pluck(:id)
  categories = load_categories
  countries = load_countries
  leagues.each do |current_league|
    league = League.new({title: current_league[:title], content: current_league[:content], is_published: current_league[:is_published]})
    league.category = categories[current_league[:category]]
    league.country = countries[current_league[:country]]
    league.save
    (2010...2015).to_a.map{|year| Year.create!(league_year: year, league_id: league.id) }
  end
end

######################################################################
# Загрузка лиг используемых при заполнении таблицы leagues_groups
######################################################################
def load_leagues
  leagues_objects = League.first(7)
  leagues = {}
  leagues_objects.each do |league|
    leagues[league.title] = league
  end
  leagues
end

######################################################################
# Связь групповых этапов и лиг
######################################################################
def seed_leagues_groups
  ActiveRecord::Base.connection.execute('TRUNCATE TABLE `leagues_groups`')
  arr = []
  arr << {league_title: 'Чемпионат Англии',     title: 'Тур 1', date_at: '2013-11-09'}
  arr << {league_title: 'Чемпионат Англии',     title: 'Тур 2', date_at: '2013-11-23'}
  arr << {league_title: 'Чемпионат Англии',     title: 'Тур 3', date_at: '2013-11-09'}
  arr << {league_title: 'Чемпионат Англии',     title: 'Тур 4', date_at: '2013-11-23'}
  arr << {league_title: 'Чемпионат Англии',     title: 'Тур 5', date_at: '2013-11-09'}
  arr << {league_title: 'Чемпионат Англии',     title: 'Тур 6', date_at: '2013-11-23'}
  arr << {league_title: 'Чемпионат Англии',     title: 'Тур 7', date_at: '2013-11-09'}
  arr << {league_title: 'Чемпионат Англии',     title: 'Тур 8', date_at: '2013-11-23'}
  arr << {league_title: 'Чемпионат Англии',     title: 'Тур 9', date_at: '2013-11-09'}
  arr << {league_title: 'Чемпионат Англии',     title: 'Тур 10', date_at: '2013-11-23'}

  arr << {league_title: 'Чемпионат Германии',     title: 'Тур 1', date_at: '2013-11-09'}
  arr << {league_title: 'Чемпионат Германии',     title: 'Тур 2', date_at: '2013-11-23'}
  arr << {league_title: 'Чемпионат Германии',     title: 'Тур 3', date_at: '2013-11-09'}
  arr << {league_title: 'Чемпионат Германии',     title: 'Тур 4', date_at: '2013-11-23'}
  arr << {league_title: 'Чемпионат Германии',     title: 'Тур 5', date_at: '2013-11-09'}
  arr << {league_title: 'Чемпионат Германии',     title: 'Тур 6', date_at: '2013-11-23'}
  arr << {league_title: 'Чемпионат Германии',     title: 'Тур 7', date_at: '2013-11-09'}
  arr << {league_title: 'Чемпионат Германии',     title: 'Тур 8', date_at: '2013-11-23'}
  arr << {league_title: 'Чемпионат Германии',     title: 'Тур 9', date_at: '2013-11-09'}
  arr << {league_title: 'Чемпионат Германии',     title: 'Тур 10', date_at: '2013-11-23'}

  arr << {league_title: 'Чемпионат Испании',     title: 'Тур 1', date_at: '2013-11-09'}
  arr << {league_title: 'Чемпионат Испании',     title: 'Тур 2', date_at: '2013-11-23'}
  arr << {league_title: 'Чемпионат Испании',     title: 'Тур 3', date_at: '2013-11-09'}
  arr << {league_title: 'Чемпионат Испании',     title: 'Тур 4', date_at: '2013-11-23'}
  arr << {league_title: 'Чемпионат Испании',     title: 'Тур 5', date_at: '2013-11-09'}
  arr << {league_title: 'Чемпионат Испании',     title: 'Тур 6', date_at: '2013-11-23'}
  arr << {league_title: 'Чемпионат Испании',     title: 'Тур 7', date_at: '2013-11-09'}
  arr << {league_title: 'Чемпионат Испании',     title: 'Тур 8', date_at: '2013-11-23'}
  arr << {league_title: 'Чемпионат Испании',     title: 'Тур 9', date_at: '2013-11-09'}
  arr << {league_title: 'Чемпионат Испании',     title: 'Тур 10', date_at: '2013-11-23'}

  arr << {league_title: 'Чемпионат Италии',     title: 'Тур 1', date_at: '2013-11-09'}
  arr << {league_title: 'Чемпионат Италии',     title: 'Тур 2', date_at: '2013-11-23'}
  arr << {league_title: 'Чемпионат Италии',     title: 'Тур 3', date_at: '2013-11-09'}
  arr << {league_title: 'Чемпионат Италии',     title: 'Тур 4', date_at: '2013-11-23'}
  arr << {league_title: 'Чемпионат Италии',     title: 'Тур 5', date_at: '2013-11-09'}
  arr << {league_title: 'Чемпионат Италии',     title: 'Тур 6', date_at: '2013-11-23'}
  arr << {league_title: 'Чемпионат Италии',     title: 'Тур 7', date_at: '2013-11-09'}
  arr << {league_title: 'Чемпионат Италии',     title: 'Тур 8', date_at: '2013-11-23'}
  arr << {league_title: 'Чемпионат Италии',     title: 'Тур 9', date_at: '2013-11-09'}
  arr << {league_title: 'Чемпионат Италии',     title: 'Тур 10', date_at: '2013-11-23'}

  arr << {league_title: 'Чемпионат Франции',     title: 'Тур 1', date_at: '2013-11-09'}
  arr << {league_title: 'Чемпионат Франции',     title: 'Тур 2', date_at: '2013-11-23'}
  arr << {league_title: 'Чемпионат Франции',     title: 'Тур 3', date_at: '2013-11-09'}
  arr << {league_title: 'Чемпионат Франции',     title: 'Тур 4', date_at: '2013-11-23'}
  arr << {league_title: 'Чемпионат Франции',     title: 'Тур 5', date_at: '2013-11-09'}
  arr << {league_title: 'Чемпионат Франции',     title: 'Тур 6', date_at: '2013-11-23'}
  arr << {league_title: 'Чемпионат Франции',     title: 'Тур 7', date_at: '2013-11-09'}
  arr << {league_title: 'Чемпионат Франции',     title: 'Тур 8', date_at: '2013-11-23'}
  arr << {league_title: 'Чемпионат Франции',     title: 'Тур 9', date_at: '2013-11-09'}
  arr << {league_title: 'Чемпионат Франции',     title: 'Тур 10', date_at: '2013-11-23'}

  leagues = load_leagues
  arr.each do |current_league_group|
    if current_league_group[:league_title] != 'Премьер-Лига'
      league_group = LeaguesGroup.new({title: current_league_group[:title], date_at: current_league_group[:date_at]})
      league_group.league = leagues[current_league_group[:league_title]]
      league_group.year_id = League.find_by_title(current_league_group[:league_title]).years.sample.id
      league_group.save
    else
      league_group = LeaguesGroup.new({title: current_league_group[:title], date_at: current_league_group[:date_at]})
      league_group.league = leagues[current_league_group[:league_title]]
      league_group.year_id = 2013
      league_group.save
    end
  end
end

######################################################################
# Загрузка групповых этапов
######################################################################
def load_leagues_groups
  LeaguesGroup.all.inject({}) do |result, lg|
    result["#{lg.league.title}:#{lg.title}"] = lg
    result
  end
end

######################################################################
# Игроки
######################################################################
def seed_persons
  ActiveRecord::Base.connection.execute('TRUNCATE TABLE persons')
  ActiveRecord::Base.connection.execute('TRUNCATE TABLE teams_persons')
  persons = []
  60.times do
    persons << {
      name_first: Faker::Name.first_name,
      name_last: Faker::Name.last_name,
      name_v: Faker::Name.first_name,
      content: Faker::Lorem.paragraph(2),
      twitter: Faker::Internet.url,
      instagram: Faker::Internet.url,
      is_published: true,
      character_id: Character.where("characters.title != 'Гл. тренер'").sample.id
    }
  end
  6.times do
    persons << {
      name_first: Faker::Name.first_name,
      name_last: Faker::Name.last_name,
      name_v: Faker::Name.first_name,
      content: Faker::Lorem.paragraph(2),
      twitter: Faker::Internet.url,
      instagram: Faker::Internet.url,
      is_published: true,
      character_id: Character.where("characters.title = 'Гл. тренер'").first.id
    }
  end
  Person.create!(persons)
end


######################################################################
# Команды
######################################################################
def seed_teams
  ActiveRecord::Base.connection.execute('TRUNCATE TABLE teams')
  ActiveRecord::Base.connection.execute('TRUNCATE TABLE teams_persons')

  persons = Person.includes(:character).where("characters.title != 'Гл. тренер'")
  coachs = Person.includes(:character).where("characters.title = 'Гл. тренер'")
  categories = load_categories
  teams = [{
    title:    'Андорра',
    content:  Faker::Lorem.paragraph(2),
    category: 'Футбол',
    subtitle: Faker::Commerce.department
  }, {
    title:    'Арсенал',
    content:  Faker::Lorem.paragraph(2),
    category: 'Футбол',
    subtitle: Faker::Commerce.department
  }, {
    title:    'Сандерленд',
    content:  Faker::Lorem.paragraph(2),
    category: 'Футбол',
    subtitle: Faker::Commerce.department
  }, {
    title:    'Сток Сити',
    content:  Faker::Lorem.paragraph(2),
    category: 'Футбол',
    subtitle: Faker::Commerce.department
  }, {
    title:    'Эвертон',
    content:  Faker::Lorem.paragraph(2),
    category: 'Футбол',
    subtitle: Faker::Commerce.department
  }, {
    title:    'СКА',
    content:  Faker::Lorem.paragraph(2),
    category: 'Хоккей',
    subtitle: Faker::Commerce.department
  }]
  teams.each do |cur_team|
    team = Team.new({title: cur_team[:title], content: cur_team[:content], subtitle: cur_team[:subtitle], is_published: true})
    team.category = categories[cur_team[:category]]
    team.country = categories[cur_team[:category]].countries.sample
    10.times do
      team.persons << persons.shift
    end
    team.persons << coachs.shift
    team.save
  end
end
######################################################################
# Загрузка команд
######################################################################
def load_teams
  Team.all.inject({}) do |result, team|
    result[team.title] = team
    result
  end
end

######################################################################
# Матчи
######################################################################
def seed_matches
  teams = load_teams
  leagues_groups = load_leagues_groups
  matches = [{
    team_home:     'Андорра',
    team_guest:    'Арсенал',
    leagues_group: 'Чемпионат Англии:Тур 11',
    title:         Faker::Company.name,
    content:       Faker::Lorem.paragraph(2),
    start_at:      Time.now + 30.minutes,
    finish_at:     Time.now + 120.minutes
  }, {
    team_home:     'Сандерленд',
    team_guest:    'Сток Сити',
    leagues_group: 'Чемпионат Англии:Тур 11',
    title:         Faker::Company.name,
    content:       Faker::Lorem.paragraph(2),
    start_at:      Time.now + 30.minutes,
    finish_at:     Time.now + 120.minutes
  }, {
    team_home:     'Эвертон',
    team_guest:    'Арсенал',
    leagues_group: 'Чемпионат Англии:Тур 12',
    title:         Faker::Company.name,
    content:       Faker::Lorem.paragraph(2),
    start_at:      Time.now + 30.minutes + 1.week,
    finish_at:     Time.now + 120.minutes + 1.week
  }, {
    team_home:     'СКА',
    team_guest:    '«Динамо» Москва',
    leagues_group: 'КХЛ. Регулярный чемпионат.:Тур 13',
    title:         Faker::Company.name,
    content:       Faker::Lorem.paragraph(2),
    start_at:      Time.now + 30.minutes,
    finish_at:     Time.now + 120.minutes
  }]
  matches.each do |cur_match|
    match = Match.new({title: cur_match[:title], content: cur_match[:content], start_at: cur_match[:start_at], finish_at: cur_match[:finish_at]})
    match.team_home = teams[cur_match[:team_home]]
    match.team_guest = teams[cur_match[:team_guest]]
    match.leagues_group = leagues_groups[cur_match[:leagues_group]]
    match.save
  end

end


##########################
# Заполнение таблицы users
##########################
def seed_users
  ActiveRecord::Base.connection.execute('TRUNCATE TABLE `users`')
  arr = [
    {email: 'MiheevDS@mail.ru', password: '321321', name_first: 'Дмитрий', name_last: 'Михеев', nickname: 'Дмитрий'},
    {email: 'vzharko@gmail.com', password: '321321', name_first: 'Вадим', name_last: 'Жарко', nickname: 'Вадим'},
    {email: 'igor@softtime.ru', password: '321321', name_first: 'Игорь', name_last: 'Симдянов', nickname: 'Игорь'},
  ]
  arr.each do |current_user|
    u = User.new(current_user)
    u.skip_confirmation!
    u.save
  end
end

user_ids = []

#############################
# Загрузка всех пользователей
#############################
def load_all_users
  User.where 1
end

#####################################################################
# Заполнение таблицы pages
#####################################################################
def seed_pages
  ActiveRecord::Base.connection.execute('TRUNCATE TABLE `pages`')
  pages = []
  ['РЕДАКЦИЯ', 'КОНТАКТЫ', 'ВАКАНСИИ', 'РЕКЛАМА', 'ПРЕДЛОЖЕНИЯ', 'ОПЕЧАТКА?'].each do |title|
    pages << {
      title:               title.mb_chars.downcase.to_s,
      content:             Faker::Lorem.words(50 + Random.rand(100)).join(' '),
      is_published:        Random.rand(2) == 1 ? true : false,
      is_comments_enabled: Random.rand(2) == 1 ? true : false
    }
  end
  Page.create!(pages)
end

#####################################################################
# Заполнение таблиц posts, comments и votes для комментариев к постам
#####################################################################

def seed_posts_and_comments_and_votes_for_posts_comments
  ActiveRecord::Base.connection.execute('TRUNCATE TABLE `posts`')
  ActiveRecord::Base.connection.execute('TRUNCATE TABLE `comments`')
  ActiveRecord::Base.connection.execute('TRUNCATE TABLE `votes`')
  categories = load_categories
  users = load_all_users
  %w(Футбол Хоккей).each do |cur_cat|
    posts = []
    100.times do |min|
      posts << {
        title:               Faker::Name.title,
        subtitle:            Faker::Name.title,
        content:             Faker::Lorem.paragraph(Random.rand(2..6)),
        is_published:        true,
        is_comments_enabled: Random.rand(2) == 1 ? true : false,
        published_at:        Time.now + (min - 30).minutes,
        category_id:         categories[cur_cat].id
      }
    end
    Post.create!(posts)
    categories[cur_cat].posts.each do |cur_post|
      # 10.times do
      #   comment = Comment.new({
      #     title:        Faker::Name.title,
      #     content:      Faker::Lorem.paragraph(Random.rand(2..6)),
      #     is_published: Random.rand(2) == 1 ? true : false,
      #     is_deleted:   Random.rand(2) == 1 ? true : false
      #   })
      #   comment.user = users[Random.rand(users.count)]
      #   comment.commentable = cur_post
      #   comment.save
      #   voted_users = []
      #   Random.rand(10).times do
      #     break if voted_users.count == users.count
      #     will_vote = users[Random.rand(users.count)]
      #     next if voted_users.include? will_vote
      #     voted_users << will_vote
      #     comment.liked_by will_vote
      #   end
      # end
    end
  end
end

###############################
# Права доступа
###############################
def seed_abilities
  Core::Permissions::rebuild
end

def seed_galleries
  ActiveRecord::Base.connection.execute('TRUNCATE TABLE galleries')
  categories = Category.all
  galleries = []
  40.times do
    galleries << {
      title: Faker::Lorem.words(3 + Random.rand(3)).join(' '),
      content: Faker::Lorem.words(8 + Random.rand(7)).join(' '),
      is_published:        Random.rand(2) == 1 ? true : false,
      is_comments_enabled: Random.rand(2) == 1 ? true : false,
      category_id: categories.sample.id,
      published_at: Time.now
    }
  end
  begin
    Gallery.create!(galleries)
  rescue ActiveRecord::RecordNotUnique => exception
  end
end

def seed_groups
  ActiveRecord::Base.connection.execute('TRUNCATE TABLE groups')
  abilities = Ability.pluck(:id)
  Group.create!(title: 'admin_group', description: 'Описание группы', ability_ids: abilities)
end

def load_group
  Group.first.id
end

def seed_employees
  ActiveRecord::Base.connection.execute('TRUNCATE TABLE employees')
  group_id = load_group
  Employee.create!({
    nickname: 'dev',
    email: 'guy@gmail.com',
    password: '321321',
    password_confirmation: '321321',
    group_id: group_id
  })
end

###############################
# Авторы
###############################
def create_authors
  Author.destroy_all
  ActiveRecord::Base.connection.execute('TRUNCATE TABLE authors')
  @employee_ids ||= Employee.pluck(:id)
  titles = ['Шишкин Иван Иванович', 'Блинов Федор Абрамович', 'Минин Кузьма', 'Пожарский Дмитрий Михайлович', 'Чкалов Валерий Павлович',
    'Стажер1', 'Стажер2', 'Стажер3', 'Стажер4', 'Стажер5', 'Стажер6', 'Стажер7', 'Стажер8', 'Стажер9', 'Стажер10']
  titles.each do |title|
    Author.create({
      name: title,
      employee_id: (@employee_ids << nil).sample
    })
  end
end


def seed_characters
  ActiveRecord::Base.connection.execute('TRUNCATE TABLE characters')
  chars = []
  chars << {title: 'Гл. тренер'}
  chars << {title: 'Вратарь'}
  chars << {title: 'Защитник'}
  chars << {title: 'Полузащитник'}
  chars << {title: 'Нападающий'}
  Character.create!(chars)
end

######################################
# Статистика хитов и хостов публикаций
######################################
def seed_redis_statistics
  hits_key = 'sportscup.ru:statistics:hits'
  hosts_key = 'sportscup.ru:statistics:hosts'
  $redis.del(hits_key)
  $redis.del(hosts_key)
  Post.is_published.not_deleted.each do |publication|
    hits = rand 1000
    hosts = rand hits
    $redis.hset(hits_key, "posts:#{publication.id}", hits)
    $redis.hset(hosts_key, "posts:#{publication.id}", hosts)
  end
  Gallery.is_published.not_deleted.each do |publication|
    hits = rand 1000
    hosts = rand hits
    $redis.hset(hits_key, "galleries:#{publication.id}", hits)
    $redis.hset(hosts_key, "galleries:#{publication.id}", hosts)
  end
  Video.is_published.not_deleted.each do |publication|
    hits = rand 1000
    hosts = rand hits
    $redis.hset(hits_key, "videos:#{publication.id}", hits)
    $redis.hset(hosts_key, "videos:#{publication.id}", hosts)
  end
end

#############################################################
# Публикации - нужно заполнять все сразу, т.к. важен порядок.
# Заполнение начинается с очистки таблицы feeds,
# затем создаются публикации,
# затем статистика просмотров в редисе
#############################################################
def seed_publications
  ActiveRecord::Base.connection.execute('TRUNCATE TABLE feeds')
  seed_posts_and_comments_and_votes_for_posts_comments
  # seed_galleries # TODO Добавить _and_comments_and_votes_for_galleries_comments
  # seed_videos_and_comments_and_votes_for_videos_comments TODO - реализовать
  # seed_redis_statistics
end


def seed_brasil
  country = Country.create(title: 'Brasil')

  league = League.new({
    title: 'World Cup 2014 Brazil',
    content: 'World Cup 2014 Brazil',
    is_published: 1,
    country_id: country.id,
    category_id: Category.find_by_title('Футбол').id
  })
  league.save
  year = Year.create!(league_year: 2014, league_id: league.id)

  leagues_groups = []
  ('A'..'H').to_a.each do |letter|
    leagues_groups << {
      title: letter,
      year_id: year.id,
      league_id: league.id,
    }
  end
  LeaguesGroup.create!(leagues_groups)
end

def seed_settings
  Core::Settings::rebuild
end

# seed_years
# seed_brasil
# seed_characters
# seed_persons
# create_authors
# seed_abilities
# seed_groups
# seed_employees

# seed_categories
# seed_countries
# seed_leagues
# seed_leagues_groups

# seed_users
# seed_pages
# seed_teams
# seed_matches
# seed_publications
# seed_settings

seed_inside_statuses
