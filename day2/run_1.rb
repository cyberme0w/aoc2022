#!/bin/env ruby

wins_against = { 'A': 'C', 'B': 'A', 'C': 'B' }

pts = 0
a_to_1_offset = 64
x_to_a_offset = 47

File.open(ARGV[0], 'r') do |f|
  f.readlines.each do |l|
    next unless l =~ /(A|B|C) (X|Y|Z)/

    c = Regexp.last_match(1)
    r = [(Regexp.last_match(2).ord - x_to_a_offset).to_s].pack('H*')

    match_pts = if c == r
                  3 + r.ord - a_to_1_offset
                elsif c == wins_against[r.to_sym]
                  6 + r.ord - a_to_1_offset
                else
                  0 + r.ord - a_to_1_offset
                end

    pts += match_pts
  end
end

puts "Player has a total of #{pts} pts"
