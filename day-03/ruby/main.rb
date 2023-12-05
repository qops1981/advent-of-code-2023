#! /usr/bin/env ruby

input = File.read("../#{ARGV[0]}").split("\n")

class String

  def number?() self.to_i.to_s == self end

end

class SchematicNumber

  attr_reader :number, :s_index, :e_index

  def initialize(number, starting_index, ending_index)
    @number  = number
    @s_index = starting_index
    @e_index = ending_index
  end

  def loi() @s_index - 1 end # Left Outer Index

  def roi() @e_index + 1 end # Right Outer Index

end

class SchematicRow

  attr_reader :row

  def initialize(row)
    @row = '.' + row + '.'
  end

  def symbols(range) @row[range].scan(/[^0-9\.]/) end

  def symbol_indexes(symbol, indexes=[], pos=0)
    return indexes if pos >= @row.length

    indexes << pos if @row[pos] =~ symbol

    symbol_indexes(symbol, indexes, pos+=1)
  end

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

class Day03

  def initialize(list)
    extra_row = [SchematicRow.new("." * list[0].length)]

    @rows = extra_row + list.map {|i| SchematicRow.new(i)} + extra_row
  end

  def part_1(acc=0, pos=1)
    return acc if pos >= @rows.length - 1 # Ending one Row early.

    valid = valid_numbers(close_numbers(pos), @rows[pos].symbol_indexes(/[^0-9\.]/))
    acc  += valid.flatten.inject(:+) unless valid.empty?

    part_1(acc, pos+=1)
  end

  def part_2(acc=0, pos=1)
    return acc if pos >= @rows.length - 1 # Ending one Row early.

    valid = valid_numbers(close_numbers(pos), @rows[pos].symbol_indexes(/[\*]/)).select {|v| v.length > 1}
    acc  += valid.map {|pair| pair.inject(:*)}.flatten.inject(:+) unless valid.empty?

    part_2(acc, pos+=1)
  end

  private

  def valid_numbers(numbers, indexes)
    indexes.map {|i| numbers.select {|n| i.between?(n.loi, n.roi)}.map(&:number)}
  end

  def close_numbers(pos)
    @rows[pos-1].numbers +
    @rows[pos  ].numbers +
    @rows[pos+1].numbers
  end

end

puzzel = Day03.new(input)

printf("%s: Day 03, Part 01, Value (%d)\n", ARGV[0].capitalize, puzzel.part_1)

printf("%s: Day 03, Part 02, Value (%d)\n", ARGV[0].capitalize, puzzel.part_2)