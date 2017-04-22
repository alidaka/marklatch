class Dictionary
  attr_reader :n, :chain
  def initialize(n=nil)
    @n = n.nil? ? 2 : n
    @chain = Hash.new {|hash, key| hash[key] = WordNode.new(key)}
  end

  def read(filename)
  end

  def add_text(text)
    w_1 = w_2 = nil
    text.split.each do |w|
      if text == 'a b c' then require 'pry'; binding.pry end
      case w
      when w_1.nil?
        chain[w]
      when w_2.nil?
        chain[w_1].children[w]
      else
        WordNode.new('$')
      end.increment
      if text == 'a b c' then require 'pry'; binding.pry end

      w_2 = w_1
      w_1 = w
    end
  end

  def speak
    'hello world'
  end
end
