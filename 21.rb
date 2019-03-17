# Twenty-One Game
class Participant
  TOP_CARDS = ['J', 'Q', 'K'].freeze
  ACE_CARD = 'A'.freeze

  attr_accessor :hand, :deck

  def initialize
    @hand = []
    @deck = Deck.new
  end

  def hit
    @hand << deck.pile.sample.to_s
  end

  def stay
    1
  end

  def busted?
    total > 21
  end

  def total_minus_ace
    count = 0
    @hand.each do |card|
      if TOP_CARDS.include?(card)
        count += 10
      elsif ACE_CARD.include?(card)
        next
      else
        count += card.to_i
      end
    end
    count
  end

  def total
    count = total_minus_ace
    @hand.each do |cd|
      return count += 11 if ACE_CARD.include?(cd) && count <= 10
      return count += 1 if ACE_CARD.include?(cd) && count > 10
    end
    count
  end
end

# Player class
class Player < Participant; end

# Dealer that deals cards to itself and player
class Dealer < Participant
  def deal
    deck.pile.sample.to_s
  end
end

# Initialize all Card objects into a deck pile from which to deal
class Deck
  attr_accessor :pile

  def initialize
    @pile = [Card.new('A'), Card.new('J'), Card.new('Q'), Card.new('K')]
    (2..10).each { |num| @pile << Card.new(num) }
  end
end

# Card object
class Card
  attr_accessor :value

  def initialize(value)
    @value = value
  end

  def to_s
    value.to_s
  end
end

# Play the game
class Game
  attr_accessor :player, :dealer

  def initialize
    @player = Player.new
    @dealer = Dealer.new
  end

  def display_welcome_message
    puts 'Welcome to Twenty-One!'
  end

  def display_goodbye_message
    puts 'Thank you for playing! Goodbye.'
  end

  def deal_cards
    player.hand << dealer.deal << dealer.deal
    dealer.hand << dealer.deal << dealer.deal
  end

  def show_hand
    puts "Player: #{player.hand} (#{player.total})."
    puts "Dealer: #{dealer.hand} (#{dealer.total})"
  end

  def player_turn
    print 'Would you wish to hit or stay? (hit/stay): '
    answer = nil
    loop do
      answer = gets.chomp.downcase
      break if ['hit', 'stay'].include?(answer)
      puts 'Sorry, invalid response.'
    end
    return player.stay if answer == 'stay'
    return player.hit if answer == 'hit'
  end

  def dealer_turn
    # if statement is repetitive
    dealer.hit if dealer.total < 17
  end

  def someone_busted?
    player.busted? || dealer.busted?
  end

  def display_winner
    if player.total > 21 && dealer.total > 21
      puts 'Tie!'
    elsif (player.total > dealer.total) && player.total <= 21
      puts 'You win!'
    elsif (player.total < dealer.total) && dealer.total <= 21
      puts 'Dealer wins!'
    elsif dealer.total > 21
      puts 'You win!'
    elsif player.total > 21
      puts 'Dealer wins!'
    else
      puts 'Tie!'
    end
  end

  def final_game_display
    show_hand
    display_winner
    display_goodbye_message
  end

  def start
    display_welcome_message
    deal_cards
    loop do
      show_hand
      ans = player_turn
      dealer_turn
      break if someone_busted? || (dealer.total >= 17 && ans == 1)
    end
    final_game_display
  end
end

Game.new.start
