#!/bin/env ruby
res1 = 0
res2 = 0

def contained_within(ar1, ar2)
  ar1[0] <= ar2[0] && ar1[-1] >= ar2[-1] ||
    ar2[0] <= ar1[0] && ar2[-1] >= ar1[-1]
end

def overlaps(ar1, ar2)
  ar1[0] <= ar2[0] && ar1[-1] >= ar2[0] ||
    ar2[0] <= ar1[0] && ar2[-1] >= ar1[0]
end

File.readlines(ARGV[0]).each do |line|
  next unless line =~ /^(\d+)-(\d+),(\d+)-(\d+)$/

  l = (Regexp.last_match(1).to_i..Regexp.last_match(2).to_i)
  r = (Regexp.last_match(3).to_i..Regexp.last_match(4).to_i)

  res1 += 1 if contained_within(l.to_a, r.to_a)
  res2 += 1 if overlaps(l.to_a, r.to_a)
end

puts "Contained within: #{res1}"
puts "Overlaps: #{res2}"
