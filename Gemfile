source 'https://rubygems.org'

gem 'comments', path: './lib/comments'
gem 'acts_as_votable', path: './lib/acts_as_votable'



gem 'rails', '3.2.18'
gem 'russian'
gem "jquery-fileupload-rails", git: 'https://github.com/tors/jquery-fileupload-rails.git'
gem 'momentjs-rails'
gem 'open_uri_redirections'
gem "rails-backbone", git: 'https://github.com/codebrew/backbone-rails.git'
# Голосование
# gem 'acts_as_votable', '~> 0.8.0'
# Обслуживание базы данных MySQL
gem 'mysql2'
# Комментарии к таблицам и столбцам базы данных
gem 'migration_comments'
# Полнотекстовый поиск в рамках отдельного сервера Sphinx
gem 'thinking-sphinx', '>= 3.0.0'
# Работа с Redis
gem 'redis-rails'

# Пагинация
gem 'will_paginate'
gem 'will_paginate-bootstrap'

# Jquery Ui
gem 'jquery-ui-rails'

# Аутентификация пользователей
gem 'omniauth'
gem 'devise'
gem "omniauth-facebook", "1.5.1"
gem "omniauth-vkontakte", "1.3.2"
gem "omniauth-twitter", github: 'arunagw/omniauth-twitter'

# Теги
gem 'acts-as-taggable-on'

# Unicode
gem 'unidecode'
  
# Cron-tasks (config/schedule.rb)
gem 'whenever'  

# Управление загружаемым контентом (изображения, видео)
gem 'paperclip'
# Загрузка изображений на удаленный SFTP-сервер
# Разделяем код и контент для раздельного масштабирования
gem 'paperclip-sftp', '~> 1.0.0'

# Перекодировка видео-файлов
gem 'streamio-ffmpeg'
# работа с zip-архивами
gem "rubyzip"

# HAML-шаблонизатор HTML-файлов
gem 'haml'
# JS-фреймворк jQuery
gem 'jquery-rails'

# Отложенные задания
gem "delayed_job_active_record"

gem 'execjs'
gem 'therubyracer', platforms: :ruby

# Управление таблицами
gem 'jquery-datatables-rails', git: 'https://github.com/rweng/jquery-datatables-rails.git'

# Генерация контента
gem 'faker'

gem 'tinymce-rails', '3.5.9'
gem 'tinymce-rails-langs', '~> 3.0'

# API clients
gem 'twitter'
gem 'instagram'

# API
gem 'sinatra'
gem 'sinatra-websocket'

group :development do
  gem 'thin'
  gem 'rails-dev-tweaks'
  # Работа с XML
  gem 'nokogiri'
  # Деплой приложения
  gem 'capistrano'
  gem 'rvm-capistrano'
  # Открытие почты в development mode
  gem 'letter_opener'
  # Аннотации к моделям
  gem 'annotate', '>=2.5.0'
  # Отображение красивых ошибок
  gem 'better_errors'
  gem 'binding_of_caller'
  # debug
  gem 'pry'
  gem 'pry-nav'
  # partials в браузере
  gem 'xray-rails'
  # человекочитаемый вывод стандартных ruby классов
  gem 'awesome_print'
  # яркий и заметный вывод debug информации в консоль/лог
  gem 'priscilla'
end

group :assets do
  gem 'sass', '3.2.10' # 3.2.11 broke the app
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'bourbon'
  gem 'hogan_assets'
end

group :test do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'
  gem 'childprocess'
  gem 'spork'
  gem 'database_cleaner'
  gem 'capybara'
  gem 'guard-spork'
  gem 'guard-rspec'
  gem 'rb-inotify'
  gem 'libnotify'
  # Определяем покрытие тестов
  gem 'simplecov', require: false
end

group :production do
  gem 'unicorn'
end
