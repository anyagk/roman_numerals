class RomanNumeralsFileProcessor
  def download_from_s3(directory, file)
    storage = Fog::Storage.new({
      :provider => 'AWS',
      :aws_access_key_id => ENV['ACCESS_KEY_ID'],
      :aws_secret_access_key => ENV['SECRET_ACCESS_KEY']
    })
    s3_directory = storage.directories.get directory
    s3_directory.files.get(file) if s3_directory
  end
end
