class RomanNumeralsFileProcessor

  def initialize(directory_name)
    @directory_name = directory_name
  end

  def download_from_s3(file)
    directory.files.get(file) if directory
  end

  def process_body(file)
   file = download_from_s3(file)
   result = convert_body(file.body)
   upload_to_s3(result)
  end

  def convert_body(body)
    number = []
    body.each_line do |line|
      roman_number = RomanNumeral.new(line)
      numbers << roman_number.int_value
    end
    number
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

  def upload_to_s3(file_name, numbers)
    directory.files.create({
      key: "Anya/#{file_name}_converted_#{Time.now.strftime("%H:%M:%S-%m-%d-%Y")}",
      body: numbers.join("\n"),
      public: false
    })
  end
end


