require_relative 'roman_numerals_file_processor'
require 'fog'

describe RomanNumeralsFileProcessor do
  describe '#download_from_s3' do
    let(:storage) { double('storage', directories: directories) }
    let(:directories) { double('directories') }
    let(:directory) { double('directory', files: files) }
    let(:files) { double('files') }
    let(:file) { double('file') }
    let(:directory_name) { 'roman_numerals' }
    let(:file_name) { 'roman_numeral_sample.txt' }

    subject { described_class.new }

    before do
      allow(Fog::Storage).to receive(:new) { storage }
      allow(directories).to receive(:get).with(directory_name) { directory }
      allow(files).to receive(:get).with(file_name) { file }
    end

    context 'when the file is successfully downloaded' do
      specify { expect(subject.download_from_s3(directory_name, file_name)).to eq(file) }
    end

     context 'when directory does not exist' do
      let(:directory_name) { 'bad directory name' }
      before { allow(directories).to receive(:get).with(directory_name) { nil } }
      specify { expect(subject.download_from_s3(directory_name, file_name)).to eq(nil) }
    end

    context 'when file does not exist' do
      let(:file_name) { 'bad file name' }
      before { allow(files).to receive(:get).with(file_name) { nil } }
      specify { expect(subject.download_from_s3(directory_name, file_name)).to eq(nil) }
    end
  end
end
