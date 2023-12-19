#! /usr/bin/env ruby

input = File.read("../#{ARGV[0]}").split("\n")

class DesertMap

  def initialize(directions, mappings)
    @directions = directions.chars
    @mappings   = mappings.map {|v| v.scan(/[0-9A-Z]+/)}.inject(Hash.new()) {|acc, m| acc[m.shift] = m; acc }
  end

  def steps(pos="AAA", ends=/ZZZ/, cnt=0)
    loop do

      raise("Error: Running in a Circle!") if @mappings[pos].all? {|v| v == pos}

      pos  = target_position(@mappings[pos], looped_index(cnt))
      cnt += 1

      return cnt if pos =~ ends

    end
  end

  def landmarks() @mappings.keys end

  private

  def looped_index(i) (i + @directions.length) % @directions.length end

  def target_position(poss, idx) Hash[["L", "R"].zip(poss)][@directions[idx]] end

end

class Day08

  def initialize(values)
    @direction_string = values.shift
    @mapping_strings  = values[1..]
    @desert_map       = DesertMap.new(@direction_string, @mapping_strings)
  end

  def part_1()
    @desert_map.steps
  end

  def part_2()
    beginnings = @desert_map.landmarks.select {|l| l =~ /A$/ }
    steps      = beginnings.map {|b| @desert_map.steps(b, /Z$/) }
    steps.inject(&:lcm) # Lowest Common Multiple
  end

end

puzzel = Day08.new(input.dup)

printf("%s: Day 08, Part 01, Value (%d)\n", ARGV[0].capitalize, puzzel.part_1)

printf("%s: Day 08, Part 02, Value (%d)\n", ARGV[0].capitalize, puzzel.part_2)