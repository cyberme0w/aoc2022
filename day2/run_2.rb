#!/bin/env ruby

wins_against = { 'A': 'C', 'B': 'A', 'C': 'B' }

pts = 0
a_to_1_offset = 64

File.open(ARGV[0], 'r') do |f|
  f.readlines.each do |l|
    next unless l =~ /(A|B|C) (X|Y|Z)/

    c = Regexp.last_match(1)
    r = Regexp.last_match(2)

    case r
    when 'X' # Lose
      pick = wins_against[c.to_sym]
      match_pts = 0 + pick.ord - a_to_1_offset
    when 'Y' # Draw
      match_pts = 3 + c.ord - a_to_1_offset
    when 'Z' # Win
      pick = wins_against.find { |_k, v| v == c }
      match_pts = 6 + pick[0].to_s.ord - a_to_1_offset
    end
    pts += match_pts
  end
end

puts "Player has a total of #{pts} pts"
