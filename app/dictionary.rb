class Dictionary
  attr_reader :n, :prefixes
  def initialize(n=nil)
    @n = n.nil? ? 2 : n
    @prefixes = Hash.new {|hash, key| hash[key] = Hash.new(0)}
  end

  def read(filename)
    File.open(filename, 'r').each do |line|
      add_text(line) unless line.strip.empty?
    end
  end

  def add_text(text)
    text.split(/[.!?]+/).map(&:strip).each do |sentence|
      add_sentence(sentence)
    end
  end

  def add_sentence(text)
    w_1 = w_2 = nil
    text.split.unshift(nil).unshift(nil).push('.').each_cons(3) do |first, second, third|
      p = Prefix.new(first, second)
      prefixes[p][third] += 1
    end
  end

  def speak
    'hello world'
  end
end
