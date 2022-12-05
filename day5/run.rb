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

stacks = [
  %w[S Z P D L B F C],
  %w[N V G P H W B],
  %w[F W B J G],
  %w[G J N F L W C S],
  %w[W J L T P M S H],
  %w[B C W G F S],
  %w[H T P M Q B W],
  %w[F S W T],
  %w[N C R]
]

# For part 2, set to false
part1 = false

# Read in and process each line
File.foreach(ARGV[0]) do |line|
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
