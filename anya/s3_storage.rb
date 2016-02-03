require 'fog'

class S3Storage
  def initialize(directory_name)
    @directory_name = directory_name
  end

  def download(file)
    directory.files.get(file) if directory
  end

  def storage
    @storage ||= Fog::Storage.new({
      provider: 'AWS',
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    })
  end

  def directory
    @directory ||= storage.directories.get @directory_name
  end

  def upload(file_name, numbers)
    directory.files.create({
      key: "roman_numerals/anya/converted_#{Time.now.strftime("%H:%M:%S-%m-%d-%Y")}",
      body: numbers.join("\n"),
      public: false
    })
  end
end

