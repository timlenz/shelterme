CarrierWave.configure do |config|
  config.fog_credentials = {
    provider: "AWS",
    aws_access_key_id: "AKIAI27IZMEGC7FUYMIQ",
    aws_secret_access_key: "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",
    region: "us-east-1"
  }
  config.fog_directory = "smphotos"
end