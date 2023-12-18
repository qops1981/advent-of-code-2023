#! /usr/bin/env ruby

input = File.read("../#{ARGV[0]}").split("\n")

class Hand
  include Comparable

  attr_reader :bid

  def initialize(hand, bid, wild_card=nil)
    score = [ 2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,  13,  14 ]
    cards = ["2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A"]

    @hand = hand.chars
    @bid  = bid.to_i

    @scores = Hash[cards.zip(score)]
    @scores[wild_card] = 1 unless wild_card.nil?
  end

  def hand() @hand.join() end

  def score() [hand_score, *card_scores] end

  private

  def <=>(other) score <=> other.score end

  def card_counts() @card_counts ||= card_scores.group_by(&:itself).transform_values(&:count) end

  def card_scores() @hand.map {|c| @scores[c] } end

  def hand_score()
    non_wild_cards  = card_counts.except(1)
    wild_card_count = card_counts[1] || 0

    return 5                     if non_wild_cards.values.any?  {|v| v == 5}
    return 4   + wild_card_count if non_wild_cards.values.any?  {|v| v == 4}
    return 3.5                   if non_wild_cards.values.any?  {|v| v == 3} && non_wild_cards.values.any? {|v| v == 2}
    return 3   + wild_card_count if non_wild_cards.values.any?  {|v| v == 3}
    return 2.5 + wild_card_count if non_wild_cards.values.count {|v| v == 2} == 2
    return 2   + wild_card_count if non_wild_cards.values.any?  {|v| v == 2}

    [1 + wild_card_count, 5].min
  end

end

class Day07

  def initialize(values)
    @hands = values.map {|v| v.split(" ")}
  end

  def part_1()
    score(@hands.map {|h| Hand.new(*h) }.sort.map {|h| h.bid })
  end

  def part_2()
    score(@hands.map {|h| Hand.new(*h, "J") }.sort.map {|h| h.bid })
  end

  private

  def score(ordered_hands)
    ordered_hands.each_with_index.inject(0) {|acc, (b, i)| acc += b * (i + 1) }
  end

end

puzzel = Day07.new(input.dup)

printf("%s: Day 07, Part 01, Value (%d)\n", ARGV[0].capitalize, puzzel.part_1)

printf("%s: Day 07, Part 02, Value (%d)\n", ARGV[0].capitalize, puzzel.part_2)

