require 'minitest/autorun'
require_relative '../app/word_node'

describe WordNode do
  before do
    @node = WordNode.new('hello', 5)
  end

  it 'has a terminal state with properties' do
    @node.leaf?.must_equal true
    @node.frequency.must_equal 5
  end

  it 'can hold a child' do
    @node.add(WordNode.new('world', 1))

    @node.leaf?.must_equal false
    @node.frequency.must_equal 5
    @node.child_space.must_equal 1
  end

  it 'can hold children' do
    @node.add(WordNode.new('world', 1))
    @node.add(WordNode.new('foo', 10))

    @node.child_space.must_equal 11
  end

  it 'does n-gram frequency' do
    child = WordNode.new('world', 1)
    child.add(WordNode.new('foo', 10))
    @node.add(child)

    @node.frequency(1).must_equal 5
    @node.frequency(2).must_equal 6
    @node.frequency(3).must_equal 16
  end
end
