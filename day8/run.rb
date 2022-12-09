#!/bin/env ruby

def calc_vis_map(map, vis_map)
  # Count visible trees from left to right
  map.each_with_index do |row, y|
    max_height = -1
    row.chars.each_with_index do |t, x|
      if t.to_i > max_height
        max_height = t.to_i
        vis_map[y][x] += 1
      end
    end
  end
  
  # Count visible trees from right to left
  map.each_with_index do |row, y|
    max_height = -1
    row.chars.to_enum.with_index.reverse_each do |t, x|
      if t.to_i > max_height
        max_height = t.to_i
        vis_map[y][x] += 1
      end
    end
  end
 
  # Count visible trees from top to bottom
  (0...COLS).each do |x|
    max_height = -1
    (0...ROWS).each do |y|
      if map[y][x].to_i > max_height
        max_height = map[y][x].to_i
        vis_map[y][x] += 1
      end
    end
  end
 
  # Count visible trees from bottom to top
  (0...COLS).each do |x|
    max_height = -1
    (0...ROWS).reverse_each do |y|
      if map[y][x].to_i > max_height
        max_height = map[y][x].to_i
        vis_map[y][x] += 1
      end
    end
  end
end

def calc_score(map, y, x)
  self_height = map[y][x].to_i

  # Calculate the tree's up score
  score_up = 0
  max_height = 0
  catch :done do
    (0...y).reverse_each do |y2|
      if map[y2][x].to_i >= self_height
        score_up += 1
        throw :done
      else
        score_up += 1
      end
    end
  end

  # Calculate the tree's left score
  score_left = 0
  max_height = 0
  catch :done do
    (0...x).reverse_each do |x2|
      if map[y][x2].to_i >= self_height
        score_left += 1
        throw :done
      else
        score_left += 1
      end
    end
  end
  
  # Calculate the tree's right score
  score_right = 0
  max_height = 0
  catch :done do
    (x+1...COLS).each do |x2|
      if map[y][x2].to_i >= self_height
        score_right += 1
        throw :done
      else
        score_right += 1
      end
    end
  end
 
  # Calculate the tree's down score
  score_down = 0
  max_height = 0
  catch :done do
    (y+1...ROWS).each do |y2|
      if map[y2][x].to_i >= self_height
        score_down += 1
        throw :done
      else
        score_down += 1
      end
    end
  end

  # Return score
  score_up * score_down * score_left * score_right
end

########
# MAIN #
########

# Process input
map = File.readlines(ARGV[0])
map.each(&:chomp!)

# Generate constants
ROWS = map.size
COLS = map[0].size.to_i

# Initialize maps
vis_map = Array.new(ROWS) { Array.new(COLS, 0) }
score_map = Array.new(ROWS) { Array.new(COLS, 0) }

# Calculate the score map
map.each_with_index do |row, y|
  row.chars.each_with_index do |tree, x|
    score_map[y][x] = calc_score(map, y, x)
  end
end

# Find the tree with the highest score
max = -1, -1, 0 # x, y and value
score_map.each_with_index do |row, y|
  row.each_with_index do |tree, x|
    if tree >= max[2]
      max[2] = tree
      max[1] = y
      max[0] = x
    end
  end
end

# Sum up all the positive tree cells in the vis_map
calc_vis_map(map, vis_map)
vis_trees = 0
vis_map.each { |r| r.each { |t| vis_trees += 1 if t.positive? } }

puts "There are #{vis_trees} visible trees."
puts "The optimal tree position is x: #{max[0]} and y: #{max[1]} with a score of #{max[2]}"
