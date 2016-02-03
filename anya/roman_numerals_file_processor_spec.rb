require_relative 'roman_numerals_file_processor'

describe RomanNumeralsFileProcessor do
  describe '#convert_body' do
    context 'with one value' do
      let(:body) { "X" }
      let(:results) { [ 10 ] }

      specify { expect(described_class.new.convert_body(body)).to eq results }
    end

    context 'with two values' do
      let(:body) { "VII\nIX" }
      let(:results) { [ 7, 9] }

      specify { expect(described_class.new.convert_body(body)).to eq results }
    end

    context 'with no input' do
      let(:body) { "" }
      let(:results) { [] }

      specify { expect(described_class.new.convert_body(body)).to eq results }
    end

    context 'with invalid input' do
      let(:body) { "23nlo" }

      specify { expect { described_class.new.convert_body(body) }.to raise_exception(ArgumentError, "invalid input") }
    end
  end

  describe '.process_s3_file' do
    let(:file) { 'roman_file.txt' }
    let(:directory) { 'roman' }
    let(:body) { 'I am the file body!' }
    let(:converted_body) { ['My body has ben converted!'] }
    let(:storage) { double('storage', download: downloaded_file, upload: nil) }
    let(:processor_instance) { double('processor instance', convert_body: converted_body) }
    let(:downloaded_file) { double('downloaded file', body: body) }

    before do
      allow(S3Storage).to receive(:new) { storage }
      allow(described_class).to receive(:new) { processor_instance }
      described_class.process_s3_file(directory, file)
    end

    context 'success' do
      specify { expect(S3Storage).to have_received(:new).with(directory) }
      specify { expect(storage).to have_received(:download).with(file) }
      specify { expect(storage).to have_received(:upload).with(file, converted_body) }
    end
  end
end

