#!/bin/env ruby

monkeys = []

PART_ONE = false
MAX_ITERATIONS = PART_ONE ? 20 : 10_000

File.readlines(ARGV[0]).each_slice(7) do |l|
  next unless l[0] =~ /Monkey (\d+)/

  monkey_id = ::Regexp.last_match(1).to_i

  next unless l[1] =~ /items: ((\d+[ ,]*)+)/

  items = ::Regexp.last_match(1).split(', ')
  items.each_with_index { |item, i| items[i] = item.to_i }

  next unless l[2] =~ /Operation: new = (.*)/

  op = ::Regexp.last_match(1).split(' ')

  next unless l[3] =~ /Test: divisible by (\d+)/

  div = ::Regexp.last_match(1).to_i

  next unless l[4] =~ /If true: throw to monkey (\d+)/

  on_true = ::Regexp.last_match(1).to_i

  next unless l[5] =~ /If false: throw to monkey (\d+)/

  on_false = ::Regexp.last_match(1).to_i

  monkeys << {
    id: monkey_id,
    items: items,
    op: op,
    div: div,
    on_true: on_true,
    on_false: on_false,
    items_inspected: 0
  }
end

# Calculate the least common multiple of all the divisors
divisors = []
monkeys.each { |m| divisors << m[:div] }
lcm = divisors.reduce(1, :lcm)

MAX_ITERATIONS.times do |i|
  monkeys.each do |m|
    until m[:items].empty?
      # Get next item
      worry_lvl = m[:items].shift

      # Parse operation
      arg1 = m[:op][0] == 'old' ? worry_lvl : m[:op][0].to_i
      arg2 = m[:op][2] == 'old' ? worry_lvl : m[:op][2].to_i

      case m[:op][1]
      when '*'
        worry_lvl = (arg1 * arg2) % lcm
      when '+'
        worry_lvl = (arg1 + arg2) % lcm
      end

      # Run monkey test
      if (worry_lvl % m[:div]).zero?
        monkeys[m[:on_true]][:items] << worry_lvl
      else
        monkeys[m[:on_false]][:items] << worry_lvl
      end

      # Count the item inspection
      m[:items_inspected] += 1
    end
  end

  case i + 1
  when 1, 20, 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10_000
    puts "== After round #{i + 1} =="
    monkeys.each { |m| puts m[:items_inspected] }
    puts
  end
end

# Print out the monkey business level
most_active_monkeys = monkeys.max_by(2) { |m| m[:items_inspected] }
monkey_business = most_active_monkeys.first[:items_inspected] * most_active_monkeys.last[:items_inspected]
puts "The monkey business is #{monkey_business}"
