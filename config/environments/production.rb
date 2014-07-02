Sport::Application.configure do
  config.cache_classes = true
  config.consider_all_requests_local       = false

  config.action_controller.perform_caching = true
  config.cache_store = :redis_store, {
    host: "127.0.0.1",
    port: 6379,
    db: 1,
    namespace: "sport.nnbs.ru:cache",
    expires_in: 7*24*60*60
  }

  config.serve_static_assets = false
  config.assets.compress = false
  config.assets.compile = false
  config.assets.digest = true
  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'
  config.assets.precompile += %w(application.css devise.css backend.css application.js backend.js
    tinymce/tiny_mce_popup.js tinymce/plugins/embcode/editor_plugin.js tinymce/plugins/embcode/js/dialog.js
    vendor/nmd/nmdVideoPlayerJw.js backend/popup/popup.js matches_page_slider.js)
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.delivery_method = :sendmail
  config.action_mailer.default_url_options = { host: 'molniasport.ru'}
  config.logger = Logger.new(Rails.root.join("log",Rails.env + ".log"))
end
