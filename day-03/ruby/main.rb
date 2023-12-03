#! /usr/bin/env ruby

input = File.read("../#{ARGV[0]}").split("\n")

class String

  def number?() self.to_i.to_s == self end

end

class SchematicNumber

  attr_reader :number, :starting_index, :ending_index

  def initialize(number, starting_index, ending_index)
    @number = number
    @starting_index = starting_index
    @ending_index   = ending_index
  end

  def left_border_index() @starting_index - 1 end

  def right_border_index() @ending_index + 1 end

end

class SchematicRow

  attr_reader :row

  def initialize(row)
    @row = '.' + row + '.'
  end

  def symbols(range) @row[range].scan(/[^0-9\.]/) end

  def gear_indexes(indexes=[], pos=0)
    return indexes if pos > @row.length - 1

    indexes << pos if @row[pos] == '*'

    gear_indexes(indexes, pos+=1)
  end

  def numbers(characters=@row.chars, acc=[], nums=[], pos=0, sps=0)
    return nums if characters.empty?

    character = characters.shift

    if character.number?
      sps = pos if acc.empty?
      acc << character
    end

    if characters.empty?

      nums << SchematicNumber.new(acc.join.to_i, sps, pos) unless acc.empty?

    else

      if ! characters.first.number? && ! acc.empty?
        nums << SchematicNumber.new(acc.join.to_i, sps, pos)
        acc = []
      end

    end

    numbers(characters, acc, nums, pos+=1, sps)
  end

end

SCHEMATIC_ROWS = input.map {|i| SchematicRow.new(i)}

def sum_part_numbers(rows, acc=0, pos=0)
  return acc if pos > rows.length - 1

  previous_row  = pos == 0 ? SchematicRow.new("." * rows[pos].row.length) : rows[pos-1]
  current_row   = rows[pos]
  following_row = pos == rows.length - 1 ? SchematicRow.new("." * rows[pos].row.length) : rows[pos+1]

  current_row.numbers.each do |n|
    range   = (n.left_border_index..n.right_border_index)

    symbols = previous_row.symbols(range) + current_row.symbols(range) + following_row.symbols(range)

    acc += n.number unless symbols.empty?
  end

  sum_part_numbers(rows, acc, pos+=1)
end

printf("%s: Day 03, Part 01, Value (%d)\n", ARGV[0].capitalize, sum_part_numbers(SCHEMATIC_ROWS.dup))

def sum_gear_ratios(rows, acc=0, pos=0)
  return acc if pos > rows.length - 1

  previous_row  = pos == 0 ? SchematicRow.new("." * rows[pos].row.length) : rows[pos-1]
  current_row   = rows[pos]
  following_row = pos == rows.length - 1 ? SchematicRow.new("." * rows[pos].row.length) : rows[pos+1]


  current_row.gear_indexes.each do |g|
    parts = previous_row.numbers.select  {|n| g.between?(n.left_border_index, n.right_border_index)} +
            current_row.numbers.select   {|n| g.between?(n.left_border_index, n.right_border_index)} +
            following_row.numbers.select {|n| g.between?(n.left_border_index, n.right_border_index)}
    acc += parts.map {|pts| pts.number}.inject(:*) unless parts.length < 2
  end

  sum_gear_ratios(rows, acc, pos+=1)
end

printf("%s: Day 03, Part 02, Value (%d)\n", ARGV[0].capitalize, sum_gear_ratios(SCHEMATIC_ROWS.dup))
