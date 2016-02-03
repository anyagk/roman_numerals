require_relative 'roman_numeral'
require_relative 's3_storage'

class RomanNumeralsFileProcessor
  def self.process_s3_file(directory, file)
    s3_storage = S3Storage.new(directory)
    downloaded_file = s3_storage.download(file)
    result = RomanNumeralsFileProcessor.new.convert_body(downloaded_file.body)
    s3_storage.upload(file, result)
  end

  def convert_body(body)
    numbers  = []
    body.each_line do |line|
      roman_number = RomanNumeral.new(line.strip)
      numbers << roman_number.int_value
    end
    numbers
  end
end

