#! /usr/bin/env ruby

input = File.read("../#{ARGV[0]}").split("\n\n")

class Range

  def overlaps?(other)
    cover?(other.first) || other.cover?(first)
  end

  def intersection(other)
    raise ArgumentError, 'value must be a Range' unless other.kind_of?(Range)
    new_min = self.cover?(other.min) ? other.min : other.cover?(min) ? min : nil
    new_max = self.cover?(other.max) ? other.max : other.cover?(max) ? max : nil
    new_min && new_max ? new_min..new_max : nil
  end

  alias_method :&, :intersection

  def add(other)
    raise ArgumentError, 'value must be a Integer' unless other.kind_of?(Integer)
    (self.begin + other)..(self.end + other)
  end

  alias_method :+, :add

end

class AlmanacCategoryMapping

  def initialize(maps)
    @range_and_offsets = range_spread(maps.map {|m| m.split(" ").map(&:to_i)}.sort_by {|_, src, _| src})
  end

  def range_spread(intial, acc=[], starting=0)
    return acc if intial.empty?

    dst, src, rng = intial.shift

    acc << [(starting..src-1), 0] if src > starting

    ending = src+rng

    acc << [(src..ending-1), dst-src]
    acc << [(ending..Float::INFINITY), 0] if intial.empty?

    range_spread(intial, acc, ending)
  end

  def mapped_intersections(map_range, acc=[], intersected=false, pos=0)
    return acc if pos >= @range_and_offsets.length

    cat_range, offset = @range_and_offsets[pos]

    if cat_range.overlaps?(map_range)
      intersected  = true
      intersection = cat_range & map_range

      acc << intersection + offset unless intersection.nil?
    else
      # With ranges sorted, we can early return after we stop intersecting.
      return acc if intersected
    end

    mapped_intersections(map_range, acc, intersected, pos+=1)
  end

end

class Almanac

  attr_reader :mappings

  def initialize(report)
    @mappings = report.map {|r| AlmanacCategoryMapping.new(r.split("\n")[1..]) }
  end

  def seed_to_location(map_range, min=[], pos=0)
    return map_range if pos >= @mappings.length

    @mappings[pos].mapped_intersections(map_range)
      .map {|range| seed_to_location(range, min, pos+1)}.flatten
  end

end

class Day05

  attr_reader :almanac

  def initialize(almanac)
    @seeds   = almanac.shift.split(": ").last.split(" ").map(&:to_i)
    @almanac = Almanac.new(almanac)
  end

  def part_1()
    @seeds.map {|s| @almanac.seed_to_location(s..s).map(&:begin) }.flatten.min
  end

  def part_2()
    seeds_as_ranges.map {|sr| @almanac.seed_to_location(sr).map(&:begin).min }.min
  end

  private

  def seeds_as_ranges()
    @seeds.each_slice(2).to_a.map{|s| (s[0]..s[0]+s[1]-1)}
  end

end

puzzel = Day05.new(input.dup)

printf("%s: Day 05, Part 01, Value (%d)\n", ARGV[0].capitalize, puzzel.part_1)

printf("%s: Day 05, Part 02, Value (%d)\n", ARGV[0].capitalize, puzzel.part_2)

