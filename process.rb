#!/usr/bin/env ruby

unless ARGV[0].nil?
  puts "#{Time.now} -- splitting files"
  `rm data/*`
  `csplit --elide-empty-files --prefix=data/xx "Ultimate-Grinnell alumni.mbox" "/^From .*/" "{*}"`

  puts "#{Time.now} -- removing bad lines"
  Dir.glob('data/xx*').each do |filename|
    found_body = false

    File.open("#{filename}.body", 'w') do |output|
      File.open(filename, 'r').each do |line|
        found_body |= line.strip.empty?
        next unless found_body

        line.strip!.downcase!

        unless line.start_with?('>') ||
               line.start_with?('<') ||
               line.start_with?('&') ||
               line.start_with?('&') ||
               line.start_with?('quot;') ||
               line.start_with?('--') ||
               line.start_with?('Content-') ||
               line.start_with?('You received this message because you are subscribed to the Google Groups') ||
               line.start_with?('To unsubscribe from this group and stop receiving emails from it') ||
               line.start_with?('For more options, visit') ||
               line.start_with?('com/') ||
               line.start_with?('com=') ||
               line.start_with?('com_')
          output.puts(line)
        end
      end
    end
  end

  puts "#{Time.now} -- single-line-ify-ing"
  Dir.glob('data/xx*.body').each do |filename|
    File.open("#{filename}.final", 'w') do |output|
      acc = ''
      File.open(filename, 'r').each do |line|
        if line.strip.empty? && !acc.strip.empty?
          output.print(acc + "\n")
          acc = ''
          next
        end

        acc += line.strip + ' '
      end
      output.print("#{acc}\n")
    end
  end
end

puts "#{Time.now} -- parsing into dictionary"
require_relative 'app/dictionary'
d = Dictionary.new
Dir.glob('data/xx*.body').each do |filename|
  d.read(filename)
end

puts "#{Time.now} -- massage some prefixes"
d.prefixes[Prefix.new(nil, nil)].reject! { |word, count|
  word.size > 20 ||
    count == 1 ||
    word.start_with?('=') ||
    word.start_with?('<') ||
    word.start_with?('>') ||
    word.start_with?('/') ||
    word.start_with?('.') ||
    word.start_with?('a0') ||
    word.start_with?('com<') ||
    word.start_with?('com>') ||
    word.start_with?('com/') ||
    word.start_with?('com"') ||
    word.start_with?('com&') ||
    word.start_with?('com\'') ||
    word.start_with?('8ex;') ||
    word.start_with?('content-type') ||
    word.start_with?('you received this message because you are subscribed to the google groups') ||
    word.start_with?('legroups') ||
    word.start_with?('s://groups') ||
    word.start_with?('https://groups') ||
    word.start_with?('\">https://') ||
    word.start_with?('i&#39;m') ||
    word.start_with?('co<wbr') ||
    word.include?('@') ||
    word.include?('=') ||
    false
}

d.prefixes[Prefix.new(nil, nil)].delete('3d')
d.prefixes[Prefix.new(nil, nil)].delete('_blank')
d.prefixes[Prefix.new(nil, nil)].delete('com')
d.prefixes[Prefix.new(nil, nil)].delete('ltr')
d.prefixes[Prefix.new(nil, nil)].delete('c2')
d.prefixes[Prefix.new(nil, nil)].delete('gmail_quote')
d.prefixes[Prefix.new(nil, nil)].delete('et')
d.prefixes[Prefix.new(nil, nil)].delete('targ')
d.prefixes[Prefix.new(nil, nil)].delete('s')
d.prefixes[Prefix.new(nil, nil)].delete('e')
d.prefixes[Prefix.new(nil, nil)].delete('margin:0')
d.prefixes[Prefix.new(nil, nil)].delete('x')
d.prefixes[Prefix.new(nil, nil)].delete('t')
d.prefixes[Prefix.new(nil, nil)].delete('gmail_extra')
d.prefixes[Prefix.new(nil, nil)].delete('utf-8')
d.prefixes[Prefix.new(nil, nil)].delete('iso-8859-1')
d.prefixes[Prefix.new(nil, nil)].delete('oglegroups')
d.prefixes[Prefix.new(nil, nil)].delete('nofollow')
d.prefixes[Prefix.new(nil, nil)].delete('d')
d.prefixes[Prefix.new(nil, nil)].delete('n')
d.prefixes[Prefix.new(nil, nil)].delete('iso-8859-1')

goog = Prefix.new(nil, 'google')
d.prefixes[Prefix.new(nil, nil)]['google'] -= d.prefixes[goog]['.']
d.prefixes[goog].delete('.')

puts "#{Time.now} -- output???"
require 'pry'; binding.pry
