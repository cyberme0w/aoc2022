#!/bin/env ruby

INDENT = 2
TOTAL_DISK_SPACE = 70_000_000
REQUIRED_DISK_SPACE = 30_000_000

class Folder
  def initialize(name, up_dir, level)
    @name = name
    @dirs = []
    @files = []
    @up = up_dir
    @level = level
  end

  def add_folder(name)
    @dirs.append(Folder.new(name, self, @level + 1)) unless @dirs.find { |d| d.name == name }
  end

  def add_file(file)
    @files.append(file) unless @files.find { |f| f.name == file.name }
  end

  def size
    size = 0
    @files.each { |f| size += f.size }
    @dirs.each { |d| size += d.size }
    size
  end

  def absolute_path
    path = @name
    up = @up
    until up.nil?
      path = up.name == '/' ? "/#{path}" : "#{up.name}/#{path}"
      up = up.up
    end
    path
  end

  def to_s
    s = ' ' * @level * INDENT
    s += "dir #{@name} (#{size})\n"
    @files.each { |f| s += "#{' ' * (@level + 1) * INDENT}#{f}\n" }
    @dirs.each { |d| s += d.to_s }
    s
  end

  attr_accessor :name, :dirs, :files, :up
end

class File
  def initialize(name, size)
    @name = name
    @size = size
  end

  def to_s
    "#{@size} #{@name}"
  end

  attr_accessor :name, :size
end

base = nil
cwd  = base

File.foreach(ARGV[0]) do |l|
  case l

  # Command
  when /^\$ (.*)$/
    cmd = Regexp.last_match(1)

    if cmd =~ /cd (.*)/
      dir_name = Regexp.last_match(1)
      if dir_name == '/'
        base = Folder.new(dir_name, nil, 0) if base.nil?
        cwd = base
        next

      elsif dir_name == '..'
        cwd = cwd.up
        next

      else
        cwd.add_folder(dir_name)
        cwd = cwd.dirs.find { |d| d.name == dir_name }
      end
    end

    next if cmd =~ /ls/

  # Directory
  when /^dir (.*)$/
    dir_name = Regexp.last_match(1)
    cwd.add_folder(dir_name)

  # File
  when /^(\d+) (.*)$/
    name = Regexp.last_match(2)
    size = Regexp.last_match(1).to_i
    cwd.add_file(File.new(name, size))

  end
end

def find_dirs_with_max_size(base_dir, max_size)
  arr = []
  arr << base_dir if base_dir.size <= max_size
  base_dir.dirs.each do |d|
    find_dirs_with_max_size(d, max_size).each { |dir| arr << dir }
  end
  arr
end

def find_dirs_with_min_size(base_dir, min_size)
  arr = []
  arr << base_dir if base_dir.size >= min_size
  base_dir.dirs.each do |d|
    find_dirs_with_min_size(d, min_size).each { |dir| arr << dir }
  end
  arr
end

# Part 1
dirs_under_100k = find_dirs_with_max_size(base, 100_000)
total_size = 0
dirs_under_100k.each { |d| total_size += d.size }
puts "Size of all folders under 100k: #{total_size}"

# Part 2
# Calculate required space
req_space = REQUIRED_DISK_SPACE - (TOTAL_DISK_SPACE - base.size)
puts "Required space to free: #{req_space}"

# Find all files that could be deleted
dir_to_delete = base
possible_dirs_to_delete = find_dirs_with_min_size(base, req_space)
possible_dirs_to_delete.each do |d|
  dir_to_delete = d if d.size < dir_to_delete.size
end

puts "Directory to be deleted is '#{dir_to_delete.absolute_path}' which will free #{dir_to_delete.size} space"
