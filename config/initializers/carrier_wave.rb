if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      # AWS S3用の設定
      # アクセスキー等絶対に直接書き込まないこと！
      :provider => 'AWS',
      :region => ENV['S3_REGION'],
      :aws_access_key_id => ENV['S3_ACCESS_KEY'],
      :aws_secret_access_key => ENV['S3_SECRET_KEY']
    }
    config.fog_directory = ENV['S3_BUCKET']
  end
end