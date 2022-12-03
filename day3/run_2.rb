#!/bin/env ruby

offset_a_to_1 = 96
offset_A_to_27 = 38
codepoint_uppercase_Z = 90

val = 0

File.open(ARGV[0], 'r') do |f|
  f.readlines.each_slice(3) do |elf_group|
    hm = {}
    prio = 0

    elf_group.each(&:chomp!)

    elf_group.each_with_index do |row, index|
      row.chars.map { |c| hm[c] = index + 1 if hm[c].to_i == index }
    end

    badge_type = hm.find { |_k, v| v == 3 }

    prio = if badge_type[0].ord <= codepoint_uppercase_Z
             badge_type[0].ord - offset_A_to_27
           else
             badge_type[0].ord - offset_a_to_1
           end

    puts "#{badge_type} => #{val}"
    val += prio
  end
end

puts val
