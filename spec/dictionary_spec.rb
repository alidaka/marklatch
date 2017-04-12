require 'minitest/autorun'
require_relative '../app/dictionary'

describe Dictionary do
  before do
    @d = Dictionary.new
  end

  it 'initializes n-gram count to 2 by default' do
    @d.n.must_equal 2
  end

  it 'allows override n-gram count' do
    Dictionary.new(5).n.must_equal 5
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

  describe 'when parsing text' do
    it 'handles a simple case' do
      @d.add_text('hello world')
      @d.speak.must_equal 'hello world'
    end
  end
end
