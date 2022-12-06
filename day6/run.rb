#!/bin/env ruby

def find_marker(marker_size, chars)
  (0...chars.size - marker_size).each do |i|
    hm = {}
    chars[i, marker_size].each { |c| hm[c] = 0 }
    return i + 1, marker_size + i if hm.size == marker_size
  end
end

File.open(ARGV[0], 'r') do |f|
  chars = f.readlines[0].chars
  sop_index, sop_processed_chars = find_marker(4, chars)
  som_index, som_processed_chars = find_marker(14, chars)

  puts "Start-of-packet received at index ##{sop_index}"
  puts "Processed a total of #{sop_processed_chars} characters until SOP"

  puts "Start-of-packet received at index ##{som_index}"
  puts "Processed a total of #{som_processed_chars} characters until SOP"
end

