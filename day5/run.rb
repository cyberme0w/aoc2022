#!/bin/env ruby

# Baking in the provided stacks
# [C]         [S] [H]
# [F] [B]     [C] [S]     [W]
# [B] [W]     [W] [M] [S] [B]
# [L] [H] [G] [L] [P] [F] [Q]
# [D] [P] [J] [F] [T] [G] [M] [T]
# [P] [G] [B] [N] [L] [W] [P] [W] [R]
# [Z] [V] [W] [J] [J] [C] [T] [S] [C]
# [S] [N] [F] [G] [W] [B] [H] [F] [N]
#  1   2   3   4   5   6   7   8   9

# Figure out how many stacks we have
total_stacks = 0
movement_start_line = 0

input = File.readlines(ARGV[0])
input.each_with_index do |l, index|
  next unless l =~ /#(\s+(\d+)){1,}/

  movement_start_line = index + 3
  total_stacks = Regexp.last_match(2).to_i
end

# Initialize the stacks with a nil, which we will remove in the next step
stacks = []
(1..total_stacks).each { stacks << [] }
puts "The crane is handling #{total_stacks} stacks. The first movement command is on line #{movement_start_line}."

stack_input = input[0, movement_start_line - 3].reverse
movement_input = input[movement_start_line - 1, input.size]

# Process the initial stack states
stack_input.each do |l|
  l.chars.each_with_index do |c, index|
    next unless c =~ /[A-Z]/

    stacks[(index - 3) / 4] << c
  end
end

# For part 2, set to false
part1 = true

# Read in and process each line
movement_input.each do |line|
  next unless line =~ /^move (\d+) from (\d+) to (\d+)$/

  qty = Regexp.last_match(1).to_i
  from = Regexp.last_match(2).to_i - 1
  to = Regexp.last_match(3).to_i - 1

  crates = stacks[from].slice!(stacks[from].size - qty, stacks[from].size)
  if part1
    crates.reverse.each { |c| stacks[to].append(c) unless c.nil? }
  else
    crates.each { |c| stacks[to].append(c) unless c.nil? } unless part1
  end
end

stacks.each_with_index do |stack, index|
  puts "Stack ##{index + 1}'s top crate is #{stack[-1]}"
end
