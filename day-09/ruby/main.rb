#! /usr/bin/env ruby

input = File.read("../#{ARGV[0]}").split("\n")

class OasisReport

  def initialize(values)
    @history = values.map(&:to_i)
  end

  def prediction()
    reduction.map(&:last).reverse.inject(:+)
  end

  def retrodiction()
    reduction.map(&:first).reverse.inject(0) {|acc, r| acc = r - acc}
  end

  private

  def reduction(h=@history, acc=[])
    return acc if h.all?(&:zero?)

    acc << h

    reduction(h.each_cons(2).map { |a, b| b - a }, acc)
  end

end

class Day09

  def initialize(values)
    @readings = values.map {|v| v.split(" ")}
  end

  def part_1()
    @readings.map {|r| OasisReport.new(r).prediction }.inject(:+)
  end

  def part_2()
    @readings.map {|r| OasisReport.new(r).retrodiction }.inject(:+)
  end

end

puzzel = Day09.new(input.dup)

printf("%s: Day 09, Part 01, Value (%d)\n", ARGV[0].capitalize, puzzel.part_1)

printf("%s: Day 09, Part 02, Value (%d)\n", ARGV[0].capitalize, puzzel.part_2)