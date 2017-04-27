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

      @d.prefixes.size.must_equal(3)

      @d.prefixes.keys.must_include(Prefix.new(nil, nil))
      @d.prefixes[Prefix.new(nil, nil)].must_equal({'a'=>1})

      @d.prefixes.keys.must_include(Prefix.new(nil, 'a'))
      @d.prefixes[Prefix.new(nil, 'a')].must_equal({'b'=>1})

      @d.prefixes.keys.must_include(Prefix.new('a', 'b'))
      @d.prefixes[Prefix.new('a', 'b')].must_equal({'.'=>1})
    end

    it 'splits sentences with punctuation' do
      @d.add_text('a b. c')

      @d.prefixes.size.must_equal(4)

      @d.prefixes.keys.must_include(Prefix.new(nil, nil))
      @d.prefixes[Prefix.new(nil, nil)].must_equal({'a'=>1, 'c'=>1})

      @d.prefixes.keys.must_include(Prefix.new(nil, 'a'))
      @d.prefixes[Prefix.new(nil, 'a')].must_equal({'b'=>1})

      @d.prefixes.keys.must_include(Prefix.new('a', 'b'))
      @d.prefixes[Prefix.new('a', 'b')].must_equal({'.'=>1})

      @d.prefixes.keys.must_include(Prefix.new(nil, 'c'))
      @d.prefixes[Prefix.new(nil, 'c')].must_equal({'.'=>1})
    end

    it 'counts correctly' do
      @d.add_text('a b. c b. a c')

      @d.prefixes.size.must_equal(6)

      @d.prefixes.keys.must_include(Prefix.new(nil, nil))
      @d.prefixes[Prefix.new(nil, nil)].must_equal({'a'=>2, 'c'=>1})
    end
  end
end
