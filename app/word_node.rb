class WordNode
  attr_reader :word
  attr_accessor :children

  def initialize(word, frequency=0)
    @word = word
    @children = Hash.new {|hash, key| hash[key] = WordNode.new(key)}
    @frequency = frequency
  end

  def increment
    @frequency += 1
  end

  def child_space(n=1)
    return 0 if n==1
    children.map{|word, child| child.frequency(n-1)}.reduce(:+)
  end

  def frequency(n=1)
    @frequency + child_space(n)
  end

  def leaf?
    children.empty?
  end
end
