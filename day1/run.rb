#!/bin/env ruby

hm = {}
i = '0'
File.open(ARGV[0], 'r') do |f|
  f.readlines.each do |l|
    if l =~ /\d+/
      hm[i] = hm[i].to_i + l.to_i
    else
      i.succ!
    end
  end
end

s = hm.sort_by { |k, v| -v }

puts "The elf with the most calories is Elf ##{s[0][0]} with #{s[0][1]} calories."

puts "The three highest caloric elves are ##{s[0][0]}, ##{s[1][0]} and ##{s[2][0]} with a combined total of #{s[0][1] + s[1][1] + s[2][1]} calories"
