require_relative 'roman_numerals_file_processor'

puts 'file being downloaded and read'
RomanNumeralsFileProcessor.process_s3_file('sktraining', 'roman_numerals/roman_numeral_sample.txt')
puts 'file successfully uploaded'

