# Poker game 

class Card
  attr_reader :rank, :suit
  
  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def to_s
    "#{rank} of #{suit}"
  end
end

class Deck
  attr_accessor :real_deck
  
  RANKS = ((2..10).to_a + %w(Jack Queen King Ace)).freeze
  SUITS = %w(Hearts Clubs Diamonds Spades).freeze
  
  def initialize
    @real_deck = []
    SUITS.each do |suit|
      RANKS.each do |rank|
        real_deck << Card.new(rank, suit)
      end
    end
  end

  def draw
    card = real_deck.sample
    real_deck.delete(card)
  end
end

class Array
  LEVELS = [2,3,4,5,6,7,8,9,10,'Jacks','Queens','Kings','Ace'] 
   
  def min
    hsh = {}
    self.each do |card|
      hsh[LEVELS.index(card.rank)] = card
    end
  hsh[hsh.keys.sort[0]]
 end


  def max
    hsh = {}
    self.each do |card|
      hsh[LEVELS.index(card.rank)] = card
    end
    hsh[hsh.keys.sort[-1]]
  end
end

# Include Card and Deck classes from the last two exercises.

class PokerHand
  attr_accessor :hand, :hsh_rank

  def initialize(deck)
    @hand = []
    @hsh_rank = {}
    @hsh_suit = {}
    @hand_c = [Card.new(6, 'Hearts'), Card.new(7, 'Hearts'), Card.new(8, 'Hearts'),
               Card.new(9, 'Hearts'),Card.new(10, 'Hearts')]
    5.times {@hand << deck.draw}
  end

  def reveal
    @hand_c.each do |card|
      if @hsh_rank.include?(card.rank)
        @hsh_rank[card.rank] += 1
      else
        @hsh_rank[card.rank] = 1
      end
    end
    @hsh_rank
  end

  def suit_reveal
    @hand_c.each do |card|
      if @hsh_suit.include?(card.suit)
        @hsh_suit[card.suit] += 1
      else
        @hsh_suit[card.suit] = 1
      end
    end
    @hsh_suit
  end

  def print
    @hand[0].rank
  end

  def evaluate
    case
    when royal_flush?     then 'Royal flush'
    when straight_flush?  then 'Straight flush'
    when four_of_a_kind?  then 'Four of a kind'
    when full_house?      then 'Full house'
    when flush?           then 'Flush'
    when straight?        then 'Straight'
    when three_of_a_kind? then 'Three of a kind'
    when two_pair?        then 'Two pair'
    when pair?            then 'Pair'
    else                       'High Card'
    end
  end

  private

  def royal_flush?
    @hsh_suit.values.include?(5) && @hsh_rank.keys.include?(10) && @hsh_rank.keys.include?('Jacks') &&
    @hsh_rank.keys.include?('Queens') && @hsh_rank.keys.include?('Kings') && @hsh_rank.keys.include?('Ace')
  end

  def straight_flush?
    flush? && straight?
  end

  def four_of_a_kind?
    @hsh_rank.values.include?(4)
  end

  def full_house?
    @hsh_rank.values.include?(3) && @hsh.values.include?(2)
  end

  def flush?
    @hsh_suit.values.include?(5)
  end

  def straight?
    i = 0
    j = 4
    while i < Array::LEVELS.size
      while j < Array::LEVELS.size
        if @hsh_rank.keys == Array::LEVELS[i..j]
          return true
        else
          i += 1
          j += 1
        end
      end
      return false
    end
  end

  def three_of_a_kind?
    @hsh_rank.values.include?(3)
  end

  def two_pair?
    @hsh_rank.values.count(2) == 2
  end

  def pair?
    @hsh_rank.values.include?(2)
  end
end

# Test suite
pokerhand = PokerHand.new(Deck.new)
p pokerhand.reveal
p pokerhand.suit_reveal
p pokerhand.evaluate
p Array::LEVELS.size
p pokerhand.hsh_rank.keys
