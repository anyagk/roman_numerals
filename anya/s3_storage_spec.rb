require_relative 's3_storage'

describe S3Storage do
  let(:storage) { double('storage', directories: directories) }
  let(:directories) { double('directories') }
  let(:directory) { double('directory', files: files) }
  let(:files) { double('files') }
  let(:file) { double('file') }
  let(:access_key) { 'my access key' }
  let(:secret_key) { 'my secret key' }
  let(:directory_name) { 'roman_numerals' }
  let(:file_name) { 'roman_numeral_sample.txt' }
  let(:fog_params) do
    {
      provider: 'AWS',
      aws_access_key_id: access_key,
      aws_secret_access_key: secret_key
    }
  end

  subject { described_class.new(directory_name)  }

  before do
    ENV['AWS_ACCESS_KEY_ID'] = access_key
    ENV['AWS_SECRET_ACCESS_KEY'] = secret_key
    allow(Fog::Storage).to receive(:new).with(fog_params) { storage }
    allow(directories).to receive(:get).with(directory_name) { directory }
  end

  describe '#download' do
    before do
      allow(files).to receive(:get).with(file_name) { file }
    end

    context 'when the file is successfully downloaded' do
      specify { expect(subject.download(file_name)).to eq(file) }
    end

    context 'when directory does not exist' do
      let(:directory_name) { 'bad directory name' }
      before { allow(directories).to receive(:get).with(directory_name) { nil } }
      specify { expect(subject.download(file_name)).to eq(nil) }
    end

    context 'when file does not exist' do
      let(:file_name) { 'bad file name' }
      before { allow(files).to receive(:get).with(file_name) { nil } }
      specify { expect(subject.download(file_name)).to eq(nil) }
    end
  end

  describe '#upload' do
    context 'when the file is correctly uploaded' do
      let(:generated_file_name) { "roman_numerals/anya/converted_#{Time.now.strftime("%H:%M:%S-%m-%d-%Y")}" }
      let(:public) { false }
      let(:body) { 'these are numbers' }
      let(:numbers) { double('numbers', join: body) }
      let(:frozen_time) { Time.parse("2016-02-02 16:19:25 -0600") }

      before do
        allow(Time).to receive(:frozen_time) { now }
        allow(files).to receive(:create)
        allow(file).to receive(:body) { body }
        subject.upload(file_name, numbers)
      end

      specify { expect(files).to have_received(:create).with(key: generated_file_name, body: body, public: public) }
    end
  end
end
