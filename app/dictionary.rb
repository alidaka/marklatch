require_relative 'prefix'

class Dictionary
  attr_reader :prefixes
  def initialize(rand=nil)
    @rand = rand.nil? ? Random.new : rand
    @prefixes = Hash.new {|hash, key| hash[key] = Hash.new(0)}
  end

  def read(filename)
    File.open(filename, 'r').each do |line|
      add_text(line) unless line.strip.empty?
    end
  end

  def add_text(text)
    text.split(/[.!?="']+/).map(&:strip).each do |sentence|
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

  def next_word(prefix)
    max = prefixes[prefix].map(&:last).inject(:+)
    r = @rand.rand(max)
    prefixes[prefix].each do |word, odds|
      return word if r < odds
      r -= odds
    end
  end

  def speak(first=nil)
    p = Prefix.new(nil, first)
    w = nil
    s = Array.new

    until w == '.' do
      w = next_word(p)
      s << w
      p = Prefix.new(p.second, w)
    end

    s.join(' ')[0...-2]
  end
end
