Rails.application.config.sorcery.submodules = [:external]

# Here you can configure each submodule's features.
Rails.application.config.sorcery.configure do |config|

  config.external_providers = [:twitter, :facebook]

  config.twitter.key = Rails.application.secrets.twitter_app_key
  config.twitter.secret = Rails.application.secrets.twitter_app_secret
  config.twitter.callback_url = Rails.application.secrets.twitter_app_callback_url
  config.twitter.user_info_mapping = {name: 'screen_name'}

  config.facebook.key = Rails.application.secrets.facebook_app_key
  config.facebook.secret = Rails.application.secrets.facebook_app_secret
  config.facebook.callback_url = Rails.application.secrets.facebook_app_callback_url
  config.facebook.user_info_mapping = {email: 'email', name: 'first_name'}
  config.facebook.scope = [:email]
  config.facebook.display = 'page'
  config.facebook.user_info_path = 'me?fields=id,email,first_name'


  config.user_config do |user|
    user.authentications_class = Authentication
  end

  config.user_class = 'User'
end
