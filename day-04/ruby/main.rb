#! /usr/bin/env ruby

input = File.read("../#{ARGV[0]}").split("\n")

class ScratchCard

  attr_reader :id, :winners, :picks

  def initialize(line)
    card, winners, picks = line.split(/: | \| /)
    @id      = card.split(" ").last.to_i
    @winners = winners.split(" ").map(&:to_i)
    @picks   = picks.split(" ").map(&:to_i)
  end

  def matches() @matches ||= @winners & @picks end

  def score()
    return 0 if matches.length < 1
    1*(2**([matches.length-1, 0].max))
  end

end

class Day04

  def initialize(input)
    @input = input
    @state = Array.new(input.length, 1)
  end

  def part_1() cards.inject(0) {|sum, card| sum += card.score} end

  def part_2()
    tally_scratch_cards
    @state.inject(:+)
  end

  def part_2(pos=0)
    return @state.inject(:+) if pos >= cards.length

    duplicate_cards(cards[pos].matches.length, pos)

    part_2(pos+=1)
  end

  private

  def cards() @cards ||= @input.map {|i| ScratchCard.new(i)} end

  def duplicate_cards(count, pos, i=0)
    return if i >= count

    target_pos = pos + 1 + i
    @state[target_pos] += (1 * @state[pos]) unless target_pos >= @state.length

    duplicate_cards(count, pos, i+=1)
  end

end

puzzel = Day04.new(input)

printf("%s: Day 04, Part 01, Value (%d)\n", ARGV[0].capitalize, puzzel.part_1)

printf("%s: Day 04, Part 02, Value (%d)\n", ARGV[0].capitalize, puzzel.part_2)
