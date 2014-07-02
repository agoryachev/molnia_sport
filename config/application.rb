require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(assets: %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Sport
  class Application < Rails::Application
    I18n.enforce_available_locales = false

    # Дополнительные пути
    config.autoload_paths += ["#{config.root}/lib",
                              "#{config.root}/lib/job",
                              "#{config.root}/lib/concerns",
                              "#{config.root}/lib/validators",
                              ]

    config.autoload_paths += Dir["#{config.root}/app/models/**/"]
    config.assets.paths << "#{Rails.root}/app/assets/fonts"

    config.active_record.observers = :broadcast_message_observer

    config.i18n.default_locale = :ru
    config.time_zone = 'Europe/Moscow'
    config.encoding = 'utf-8'
    config.filter_parameters += [:password]
    config.active_support.escape_html_entities_in_json = true
    config.active_record.whitelist_attributes = true
    config.assets.enabled = true
    config.assets.version = '1.0'
    config.assets.initialize_on_precompile = false

    config.action_view.sanitized_allowed_tags = ['iframe']
    config.action_view.sanitized_allowed_attributes = 'frameborder', 'allowfullscreen', 'style'

    config.generators do |g|
      g.template_engine :haml
      g.test_framework :rspec, fixture: false, view: false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.view_specs      false
      g.helper_specs    false
      g.integration_tool :rspec
      g.performance_tool :rspec 
    end

    config.middleware.use 'StatisticsMiddleware'

  end
end
