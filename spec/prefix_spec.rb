require 'minitest/autorun'
require_relative '../app/prefix'

describe Prefix do
  it 'has an equality comparer' do
    p1 = Prefix.new('hello', 'world')
    p2 = Prefix.new('hello', 'world')
    p1.must_equal(p2)
  end

  it 'has a negative case' do
    p1 = Prefix.new('hello', 'world')
    p2 = Prefix.new('world', 'hello')
    p1.wont_equal(p2)
  end

  it 'works as expected in hashes' do
    p1 = Prefix.new('hello', 'world')
    p2 = Prefix.new('hello', 'world')
    h = {p1=>1}
    h[p2] = 2

    h.size.must_equal(1)
    h[p1].must_equal(2)
  end
end
