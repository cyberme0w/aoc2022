#!/bin/env ruby

values_after_cycle = [1]
lines = File.readlines(ARGV[0])

lines.each do |l|
  next unless l =~ /(\w+)( -?\d+)?/
  
  op = ::Regexp.last_match(1)
  arg = ::Regexp.last_match(2).to_i

  case op
  when 'noop'
    values_after_cycle << values_after_cycle.last
  when 'addx'
    values_after_cycle << values_after_cycle.last
    values_after_cycle << values_after_cycle.last + arg
  end
end


# Print every relevant cycle
total_sig_strength = 0
values_after_cycle.each_with_index do |v, i|
  next unless ((i - 19) % 40).zero?

  puts "After cycle #{i} || Value #{v} || Signal-Strength #{v * (i + 1)}"
  total_sig_strength += v * (i + 1)
end

puts
puts "The summed signal strength during cycle 20, 60... is #{total_sig_strength}"
puts

# [v - 1, v + 1] represents the interval in which the sprite is visible
# if i happens to be within that interval, the current pixel gets drawn as #
# otherwise, as a single dot
values_after_cycle.each_slice(40) do |values|
  next unless values.size == 40 # Make sure we have a complete row

  row = ''
  values.each_with_index do |v, i|
    row += v >= i - 1 && v <= i + 1 ? '#' : '.'
  end

  puts row
end
