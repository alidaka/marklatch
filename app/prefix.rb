class Prefix
  attr_reader :first, :second
  attr_accessor :count

  def initialize(first, second)
    @first = first
    @second = second
    @count = 0
  end

  def ==(other)
    (@first == other.first) && (@second == other.second)
  end

  def hash
    "#@first|#@second".hash
  end

  alias_method :eql?, :==
  alias_method :===, :==
end
