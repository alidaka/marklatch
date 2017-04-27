class Dictionary
  attr_reader :n, :chain
  def initialize(n=nil)
    @n = n.nil? ? 2 : n
    @chain = Hash.new {|hash, key| hash[key] = WordNode.new(key)}
  end

  def read(filename)
  end

  def add_text(text)
    #text.split('.').each do |sentence|
    #end
    w_1 = w_2 = nil
    text.split.push('.').each do |w|
      if w_1.nil?
        chain[w]
      elsif w_2.nil?
        chain[w_1].children[w]
      else
        chain[w_2].children[w_1].children[w]
      end.increment

      w_2 = w_1
      w_1 = w
    end
  end

  def speak
    'hello world'
  end
end
