CarrierWave.configure do |config|
  if Rails.env.test?
    config.storage = :file
  else
    config.fog_credentials = {
      provider:              'AWS',
      use_iam_profile:        true,
      region: Rails.application.secrets.aws_region
    }
    config.fog_directory = Rails.application.secrets.fog_directory
  end
end
