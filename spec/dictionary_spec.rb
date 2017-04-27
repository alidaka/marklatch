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
    before do
      @d = Dictionary.new(3)
    end

    it 'handles a simple case' do
      @d.add_text('hello world')
      @d.speak.must_equal 'hello world'
    end

    it 'splits words' do
      @d.add_text('a b')

      @d.chain.size.must_equal(1)
      @d.chain['a'].frequency.must_equal(1)
      @d.chain['a'].frequency(2).must_equal(2)
      @d.chain['a'].children.size.must_equal(1)
      @d.chain['a'].children.first[0].must_equal('b')
      @d.chain['a'].children['b'].children.size.must_equal(1)
      @d.chain['a'].children['b'].children.first[0].must_equal('.')
    end

    it 'splits words and inserts final punctuation' do
      @d.add_text('a b c')

      @d.chain.size.must_equal(1)
      @d.chain['a'].frequency.must_equal(1)
      @d.chain['a'].frequency(2).must_equal(3)
      @d.chain['a'].children.size.must_equal(2)
      @d.chain['a'].children.map{|w| w.word}.must_contain('b')
      @d.chain['a'].children.map{|w| w.word}.must_contain('c')

      @d.chain['a'].children['b'].frequency.must_equal(1)
      @d.chain['a'].children['b'].frequency(2).must_equal(2)
      @d.chain['a'].children['b'].children.size.must_equal(2)
      @d.chain['a'].children['b'].children.map{|w| w.word}.must_contain('.')
    end

    it 'splits words with punctuation' do
      @d.add_text('a b. c')
    end

    it 'counts correctly' do
      @d.add_text('a b. c b. a c')
    end

    it 'position matters' do
      @d.add_text('a b. b')
    end
  end
end
