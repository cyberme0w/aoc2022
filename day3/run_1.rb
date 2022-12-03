#!/bin/env ruby

offset_a_to_1 = 96
offset_A_to_27 = 38
codepoint_uppercase_Z = 90

val = 0

File.open(ARGV[0], 'r') do |f|
  f.readlines.each_with_index do |line, i|
    l = line.slice(0, line.size / 2)
    r = line.slice(line.size / 2, line.size)

    hm = {}
    prio = 0

    l.chars.map { |c| hm[c] = hm[c].to_i + 1 }

    catch :found do
      r.chars.each do |c|
        next if hm[c].nil?

        prio = if c.ord <= codepoint_uppercase_Z
                 c.ord - offset_A_to_27
               else
                 c.ord - offset_a_to_1
               end
        puts "L: #{i}\t C: #{c} P: #{prio}"
        val += prio
        throw :found
      end
    end
  end
end

puts val
