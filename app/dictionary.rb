class Dictionary
  attr_reader :n
  def initialize(n=nil)
    @n = n.nil? ? 2 : n
    @chain = {}
  end

  def read(filename)

  end

  def add_text(text)
  end

  def speak
    'hello world'
  end
end
