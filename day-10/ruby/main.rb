#! /usr/bin/env ruby

input = File.read("../#{ARGV[0]}").split("\n")

class PipeDiagram

  attr_reader :mapping, :empty_map, :farthest_position

  CONNECTION_SHIFTS = {
    "|" => [[ 0, 1],[ 0,-1]],
    "-" => [[ 1, 0],[-1, 0]],
    "L" => [[ 0,-1],[ 1, 0]],
    "J" => [[ 0,-1],[-1, 0]],
    "7" => [[ 0, 1],[-1, 0]],
    "F" => [[ 1, 0],[ 0, 1]]
  }

  def initialize(diagram)
    @pipes_map = diagram
    @empty_map = Array.new(@pipes_map.size) { Array.new(@pipes_map.first.size, nil) }

    @pipes_map[starting[1]][starting[0]] = starting_pipe
    @empty_map[starting[1]][starting[0]] = starting_pipe

    @farthest_position = calculate_loop_length / 2
  end

  def enclosed() @empty_map.inject(0) {|sum, er| sum += count_enclosed(er)} end

  private

  def starting()
    @starting ||= @pipes_map.each_with_index.flat_map { |a, i| a.index("S") ? [[a.index("S"), i]] : [] }[0]
  end

  def starting_pipe()
    @starting_pipe ||= begin
      starting_connection_shifts = [[0,1],[1,0],[0,-1],[-1,0]].select do |sft|
        connecting_coordinates(coordinate_shift(starting, sft)).include?(starting)
      end

      CONNECTION_SHIFTS.select {|pipe, shifts| starting_connection_shifts - shifts == [] }.keys.first
    end
  end

  def calculate_loop_length(location=connecting_coordinates(starting).insert(1, starting), count=1)
    loop do
      count += 1
      clone_to_field(location.last)

      location.shift
      location.push((connecting_coordinates(location.last) - [location.first])[0])

      return count if location.last == @starting
    end
  end

  def connecting_coordinates(coo)
    CONNECTION_SHIFTS[pipe(coo)].map {|sft| coordinate_shift(coo, sft) }
  rescue
    []
  end

  def pipe(coo) @pipes_map[coo[1]][coo[0]] end

  def coordinate_shift(coo, sft) coo.zip(sft).map {|c| c.inject(:+) } end

  def clone_to_field(coo) @empty_map[coo[1]][coo[0]] = pipe(coo) end

  def count_enclosed(row, placment=[0,0], count=0)
    # Ray Casting, Had to look this one up.
    # Credit to CJ Avilla on youtube.

    row.each do |r|
      unless r.nil?
        shifts_y = CONNECTION_SHIFTS[r].map {|c| c.last}
        placment = placment.zip([
          shifts_y.count(&:negative?),
          shifts_y.count(&:positive?)
        ]).map {|pl| pl.inject(:+) }
      else
        count += 1 if placment.min.odd?
      end
    end

    count
  end

end

class Day10

  def initialize(values)
    @pipes = PipeDiagram.new(values.map(&:chars))
  end

  def part_1()
    @pipes.farthest_position
  end

  def part_2()
    @pipes.enclosed
  end

end

puzzel = Day10.new(input.dup)

printf("%s: Day 10, Part 01, Value (%d)\n", ARGV[0].capitalize, puzzel.part_1)

printf("%s: Day 10, Part 02, Value (%d)\n", ARGV[0].capitalize, puzzel.part_2)
