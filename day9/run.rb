#!/bin/env ruby


def move_head(head, dir)
  case dir
  when 'L'
    head[0] -= 1
  when 'D'
    head[1] -= 1
  when 'R'
    head[0] += 1
  when 'U'
    head[1] += 1
  end
end

def move_tail(head, tail)
  vx = head[0] - tail[0]
  vy = head[1] - tail[1]

  # Straight lines
  if vx == 0
    tail[1] += vy.positive? ? 1 : -1
  elsif vy == 0
    tail[0] += vx.positive? ? 1 : -1

  # Diagonal lines
  else
    tail[0] += vx.positive? ? 1 : -1
    tail[1] += vy.positive? ? 1 : -1
  end
end

def move(knots, dir)
  move_head(knots.first, dir)

  (1...knots.size).each do |i|
    h = knots[i - 1]
    t = knots[i]
    move_tail(knots[i - 1], knots[i]) if (h[0] - t[0]).abs >= 2 || (h[1] - t[1]).abs >= 2
  end
end

########
# MAIN #
########

# Parse input
input = File.readlines(ARGV[0])
knot_count = ARGV[1].to_i > 2 ? ARGV[1].to_i : 2

# Initialize hashmaps
knots = Array.new(knot_count) { [0, 0] }
tail_positions = { knots.last.to_s => 1 } # Save initial position

# Process each movement
input.each do |l|
  next unless l =~ /^([LDRU]) (\d+)$/

  dir = ::Regexp.last_match(1)
  qty = ::Regexp.last_match(2).to_i
  
  qty.times do
    move(knots, dir)
    tail_positions[knots.last.to_s] = tail_positions[knots.last.to_s].to_i + 1
  end
end

# Echo results
puts "The tail visited #{tail_positions.size} unique positions"
