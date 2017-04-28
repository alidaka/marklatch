#!/usr/bin/env ruby

require_relative 'app/dictionary'
require 'pry'

o = File.read('serial_dictionary')
d = Marshal.load(o)

puts
puts 'It seemed to work!'
puts 'Give it a try with "d.speak", or start with a specific word with "d.speak(\'stickies\')'
puts
puts 'Note: lowercase only, and it only attempts to output one sentence at a time...'
puts '...And yes, there are some data issues; emails are hard to parse :P'

binding.pry
