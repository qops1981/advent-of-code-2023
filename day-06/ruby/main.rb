#! /usr/bin/env ruby

input = File.read("../#{ARGV[0]}").split("\n")

class Race

  def initialize(time, record)
    @time   = time
    @record = record
  end

  def speeds_that_beat()
    ((((@time.to_f + 1) / 2) - record_beaten_at) * 2).to_i
  end

  def record_beaten_at()
    (0..@time).find {|t| t * ( @time - t ) > @record}
  end

end

class Day06

  def initialize(values)
    numbers = values.map {|v| v.scan(/\d+/).map(&:to_i)}
    @races  = numbers.first.zip(numbers.last)
    @race   = [numbers.first.join.to_i, numbers.last.join.to_i]
  end

  def part_1()
    @races.map {|r| Race.new(*r).speeds_that_beat }.inject(:*)
  end

  def part_2()
    Race.new(*@race).speeds_that_beat
  end

end

puzzel = Day06.new(input.dup)

printf("%s: Day 06, Part 01, Value (%d)\n", ARGV[0].capitalize, puzzel.part_1)

printf("%s: Day 06, Part 02, Value (%d)\n", ARGV[0].capitalize, puzzel.part_2)

