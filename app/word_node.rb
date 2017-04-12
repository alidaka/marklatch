class WordNode
  attr_reader :children
  attr_accessor :child_space

  def initialize(word, frequency)
    @children = Array.new
    @child_space = 0
    @frequency = frequency
  end

  def frequency(n=1)
    return @frequency if n==1 || children.empty?

    @frequency + children.map{|child| child.frequency(n-1)}.reduce(:+)
  end

  def leaf?
    children.empty?
  end

  def add(node)
    self.child_space = child_space + node.frequency
    children.push(node)
  end
end
