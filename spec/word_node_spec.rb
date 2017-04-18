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
    @node.children['world'] = WordNode.new('world', 1)

    @node.leaf?.must_equal false
    @node.frequency.must_equal 5
    @node.child_space(2).must_equal 1
  end

  it 'can hold children' do
    @node.children['world'] = WordNode.new('world', 1)
    @node.children['foo'] = WordNode.new('foo', 10)

    @node.child_space(2).must_equal 11
  end

  it 'does n-gram frequency' do
    @node.children['world'] = WordNode.new('world', 1)
    @node.children['world'].children['foo'] = WordNode.new('foo', 10)

    @node.frequency(1).must_equal 5
    @node.frequency(2).must_equal 6
    @node.frequency(3).must_equal 16
  end

  it 'does n-gram child counting' do
    @node.children['world'] = WordNode.new('world', 1)
    @node.children['world'].children['foo'] = WordNode.new('foo', 10)

    @node.child_space(1).must_equal 0
    @node.child_space(2).must_equal 1
    @node.child_space(3).must_equal 11
  end

  it 'has a way to increment frequency' do
    @node.frequency.must_equal 5
    @node.increment
    @node.frequency.must_equal 6
  end
end
