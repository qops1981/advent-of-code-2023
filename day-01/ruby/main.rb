#! /usr/bin/env ruby

sample1 = File.read('../sample1').split("\n")
sample2 = File.read('../sample2').split("\n")
input   = File.read('../input').split("\n")

class Calibration

  NUMBERS  = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"].freeze
  INTEGERS = ["1", "2", "3", "4", "5", "6", "7", "8", "9"].freeze

  def initialize(line)
    @line = line
  end

  def p1_value
    @line.scan(/\d/).values_at(0,-1).join().to_i
  end

  def p2_value
    @line.scan(/(?=(\d|#{NUMBERS.join('|')}))/).flatten.map {|n| parse_number(n)}.values_at(0,-1).join().to_i
  end

  private

  def parse_number(n)
    NUMBERS.include?(n) ? number_map[n] : n
  end

  def number_map
    @number_map ||= Hash[NUMBERS.zip(INTEGERS)]
  end

end

sample_computation = sample1.inject(0) do |sum, calibration|
  sum + Calibration.new(calibration).p1_value
end

printf("Sample: Day 01, Part 01, Value (%d)\n", sample_computation)

input_computation = input.inject(0) do |sum, calibration|
  sum + Calibration.new(calibration).p1_value
end

printf("Input:  Day 01, Part 01, Value (%d)\n", input_computation)

sample_computation = sample2.inject(0) do |sum, calibration|
  sum + Calibration.new(calibration).p2_value
end

printf("Sample: Day 01, Part 02, Value (%d)\n", sample_computation)

input_computation = input.inject(0) do |sum, calibration|
  sum + Calibration.new(calibration).p2_value
end

printf("Input:  Day 01, Part 02, Value (%d)\n", input_computation)