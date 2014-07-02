Devise.setup do |config|
  require 'devise/orm/active_record'
  config.mailer_sender = "please-change-me-at-config-initializers-devise@example.com"
  config.case_insensitive_keys = [ :email ]
  config.strip_whitespace_keys = [ :email ]
  config.authentication_keys = [ :nickname ]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 10
  config.reconfirmable = false
  config.password_length = 6..128
  config.reset_password_within = 6.hours
  config.scoped_views = true
  config.sign_out_via = :delete
  config.secret_key = 'bb1fdc44e3f7eae787590d353e5a33bba81b0542a23142a08f3dd8c747853f1b59be39f9be799cc3e13341940667277a8f7973b400572dd1c6abd9032439d639'

  config.omniauth :facebook, OAUTH['facebook']['app_id'], OAUTH['facebook']['app_secret']
  config.omniauth :twitter, OAUTH['twitter']['consumer_key'], OAUTH['twitter']['consumer_secret'], {image_size: 'original'}
  config.omniauth(:vkontakte, OAUTH['vkontakte']['app_id'], OAUTH['vkontakte']['app_secret'], { image_size: 'photo_200_orig'})
end
