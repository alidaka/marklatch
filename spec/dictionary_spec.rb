require 'minitest/autorun'
require_relative '../app/dictionary'

describe Dictionary do
  before do
    @d = Dictionary.new
  end

  describe 'when interacting with files' do
    before do
      @file = Tempfile.new('dictionary_spec')
    end

    after do
      @file.unlink
    end

    it 'reads a file' do
      @file.write('hello world')
      @file.close

      @d.read(@file.path)
    end
  end
end
