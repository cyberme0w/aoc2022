#!/bin/env ruby

monkeys = []

PART_ONE = true
MAX_ITERATIONS = PART_ONE ? 20 : 10000

File.readlines(ARGV[0]).each_slice(7) do |l|
  next unless l[0] =~ /Monkey (\d+)/
  monkey_id = $1.to_i

  next unless l[1] =~ /items: ((\d+[ ,]*)+)/
  items = $1.split(', ')
  items.each_with_index { |item, i| items[i] = item.to_i }

  next unless l[2] =~ /Operation: new = (.*)/
  op = $1.split(' ')

  next unless l[3] =~ /Test: divisible by (\d+)/
  div = $1.to_i

  next unless l[4] =~ /If true: throw to monkey (\d+)/
  on_true = $1.to_i

  next unless l[5] =~ /If false: throw to monkey (\d+)/
  on_false = $1.to_i

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

MAX_ITERATIONS.times do |i|
  monkeys.each do |m|
    m[:items_inspected] += m[:items].size

    m[:items].each do |worry_lvl|
      # Parse operation
      arg1 = m[:op][0] == 'old' ? worry_lvl : m[:op][0].to_i
      arg2 = m[:op][2] == 'old' ? worry_lvl : m[:op][2].to_i

      case m[:op][1]
      when '*'
        worry_lvl = arg1 * arg2
      when '+'
        worry_lvl = arg1 + arg2
      end

      # Process boredom
      worry_lvl = worry_lvl / 3 if PART_ONE

  
      # Run monkey test
      if (worry_lvl % m[:div]).zero?
        monkeys[m[:on_true]][:items] << worry_lvl
        #monkeys[m[:on_true]][:items] << (PART_ONE ? worry_lvl : worry_lvl / m[:div])
      else
        monkeys[m[:on_false]][:items] << worry_lvl
        #monkeys[m[:on_false]][:items] << (PART_ONE ? worry_lvl : worry_lvl / m[:div])
      end
    end
  
    # Clean the monkey's item list
    m[:items].clear
  end
 
  case i+1
  when 1, 20, 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 1000
    puts "== After round #{i+1} =="
    monkeys.each { |m| puts m[:items_inspected] }
    puts
  end

end

# Print out the monkey business level
most_active_monkeys = monkeys.max_by(2) { |m| m[:items_inspected] }
monkey_business = most_active_monkeys.first[:items_inspected] * most_active_monkeys.last[:items_inspected]
puts "The monkey business is #{monkey_business}"

