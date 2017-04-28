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

        unless line.start_with?('>') || line.start_with?('&gt;') || line.start_with?('quot;') || line.start_with?('--') || line.start_with?('Content-') || line.start_with?('<') || line.start_with?('You received this message because you are subscribed to the Google Groups') || line.start_with?('To unsubscribe from this group and stop receiving emails from it') || line.start_with?('For more options, visit')
          output.print(line)
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

puts "#{Time.now} -- output???"
require 'pry'; binding.pry
