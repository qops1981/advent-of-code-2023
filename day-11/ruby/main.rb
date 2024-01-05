#! /usr/bin/env ruby

input = File.read("../#{ARGV[0]}").split("\n")

class UniverseExpansion

  def initialize(locs, expn)
    @locs = locs
    @expn = expn - 1
  end

  def locations()
    @locs
  end

  def expansion(pos)
    return 0 unless @locs.any? {|l| pos > l}

    @expn * (@locs.each_with_index.select {|v, i| pos > v }.last.last + 1)
  end

end

class UniverseVoids

  def initialize(universe, expansion)
    @universe  = universe
    @expansion = expansion
  end

  def vertical ()
    @vertical   ||= UniverseExpansion.new(find_voids(@universe.transpose), @expansion)
  end

  def horizontal()
    @horizontal ||= UniverseExpansion.new(find_voids(@universe), @expansion)
  end

  private

  def find_voids(universe)
    universe.each_with_index.select { |row, index| row.uniq.size == 1 }.map(&:last)
  end

end

class Universe

  def initialize(universe, expansion)
    @universe  = universe
    @expansion = expansion
  end

  def shortest_distances()
    galaxy_combinations.map {|coos| manhatten_distance(coos)}
  end

  private

  def galaxy_combinations()
    galaxies.combination(2).to_a
  end

  def manhatten_distance(coordiantes)
    coordiantes.transpose.map {|v| (v.first - v.last).abs }.inject(:+)
  end

  def galaxies(coordiantes=[], y=0)
    return coordiantes if y >= @universe.length

    @universe[y].each_with_index do |c, x|
      next unless c == "#"

      coordiantes << expand(x, y)
    end

    galaxies(coordiantes, y+=1)
  end

  def expand(x,y)
    [x + voids.vertical.expansion(x), y + voids.horizontal.expansion(y)]
  end

  def voids()
    @voids ||= UniverseVoids.new(@universe, @expansion)
  end

end

class Day11

  def initialize(values)
    @image = values.map(&:chars)
  end

  def part_1()
    Universe.new(@image, 2).shortest_distances.inject(:+)
  end

  def part_2()
    Universe.new(@image, 1_000_000).shortest_distances.inject(:+)
  end

end

puzzel = Day11.new(input.dup)

printf("%s: Day 11, Part 01, Value (%d)\n", ARGV[0].capitalize, puzzel.part_1)

printf("%s: Day 11, Part 02, Value (%d)\n", ARGV[0].capitalize, puzzel.part_2)