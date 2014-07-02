# encoding: utf-8
require 'simplecov'
SimpleCov.start

require 'rubygems'
require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'faker'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

  counter = -1

  RSpec.configure do |config|
    # ## Mock Framework
    config.mock_with :rspec

    config.use_transactional_fixtures = false

    # Авторматический вход для Devise
    config.include Devise::TestHelpers, type: :controller
    config.include ValidUserRequestHelper, type: :request

    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false

    # Run specs in random order to surface order dependencies. If you find an
    # order dependency and want to debug it, you can fix the order by providing
    # the seed, which is printed after each run.
    #     --seed 1234
    config.order = "random"

    config.before(:suite) do
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.clean_with(:truncation)            
    end

    # Перед прогоном каждого выражения
    config.before(:each) do      
      DatabaseCleaner.start

      # отключаем сборщик мусора
      counter += 1
      if counter > 9
        GC.enable
        GC.start
        GC.disable
        counter = 0
      end
    end

    # По заврешении каждого выражения
    config.after(:each) do
      DatabaseCleaner.clean
    end

    config.after(:suite) do
      counter = 0
    end

    # Тестирование представления (метод visit)
    config.include Capybara::DSL

  end
end

Spork.each_run do
  # This code will be run each time you run your specs.
  FactoryGirl.reload
end