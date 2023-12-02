#! /usr/bin/env ruby

input = File.read("../#{ARGV[0]}").split("\n")

class Game

  def initialize(results)
    @game = { "Game" => 0, "red" => 0, "green" => 0, "blue" => 0 }
    parse_game(results)
  end

  def id() @game["Game"] end

  def max_drawn_colors() @game.values[1..] end

  def possible?(max_colors)
    max_colors.zip(max_drawn_colors).map {|v| v[0] >= v[1] }.all?
  end

  private

  def parse_game(r)
    elements    = r.split(/:|,|;/).map {|s| s.strip.split(" ")}
    elements[0] = elements[0].reverse

    elements.each do |e|
      @game[e[1]] = e[0].to_i if @game[e[1]] < e[0].to_i
    end
  end

end

GAMES = input.map {|g| Game.new(g)}

def passing_games(games, acc=0)
  return acc if games.empty?

  game = games.shift

  acc += game.id if game.possible?([12, 13, 14])

  passing_games(games, acc)
end

printf("%s: Day 02, Part 01, Value (%d)\n", ARGV[0].capitalize, passing_games(GAMES.dup))

def sum_power_of_minimums(games, acc=0)
  return acc if games.empty?

  game = games.shift

  acc += game.max_drawn_colors.inject(:*)

  sum_power_of_minimums(games, acc)
end

printf("%s: Day 02, Part 02, Value (%d)\n", ARGV[0].capitalize, sum_power_of_minimums(GAMES.dup))