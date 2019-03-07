class Move
  def initialize(value)
    @value = value
  end

  def scissors?
    @value == 'scissors'
  end

  def paper?
    @value == 'paper'
  end

  def rock?
    @value == 'rock'
  end

  def lizard?
    @value == 'lizard'
  end

  def spock?
    @value == 'spock'
  end

  def to_s
    @value
  end
end

class Rock < Move
  attr_reader :value
  def initialize
    @value = "rock"
  end

  def >(other_move)
    return true if other_move.scissors? || other_move.lizard?
  end

  def <(other_move)
    return true if other_move.paper? || other_move.spock?
  end
end

class Paper < Move
  attr_reader :value
  def initialize
    @value = "paper"
  end

  def >(other_move)
    true if other_move.rock? || other_move.spock?
  end

  def <(other_move)
    true if other_move.scissors? || other_move.lizard?
  end
end

class Scissors < Move
  attr_reader :value
  def initialize
    @value = "scissors"
  end

  def >(other_move)
    return true if other_move.paper? || other_move.lizard?
  end

  def <(other_move)
    return true if other_move.rock? || other_move.spock?
  end
end

class Lizard < Move
  attr_reader :value
  def initialize
    @value = "lizard"
  end

  def >(other_move)
    true if other_move.spock? || other_move.paper?
  end

  def <(other_move)
    true if other_move.scissors? || other_move.rock?
  end
end

class Spock < Move
  attr_reader :value
  def initialize
    @value = "spock"
  end

  def >(other_move)
    return true if other_move.rock? || other_move.scissors?
  end

  def <(other_move)
    return true if other_move.paper? || other_move.lizard?
  end
end

class Player
  attr_accessor :move, :name

  def initialize
    set_name
  end
end

class Human < Player
  def set_name
    n = ""
    loop do
      puts "Please enter your name"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, invalid name"
    end
    self.name = n
  end

  def choose
    choice_arr = ['rock', 'paper', 'scissors', 'spock', 'lizard']
    choice = nil
    loop do
      puts "Please choose rock, paper, scissors, lizard or spock"
      choice = gets.chomp.downcase
      break if choice_arr.include?(choice)
      puts "Sorry, invalid choice"
    end
    self.move = Paper.new if choice == "paper"
    self.move = Rock.new if choice == "rock"
    self.move = Scissors.new if choice == "scissors"
    self.move = Spock.new if choice == "spock"
    self.move = Lizard.new if choice == "lizard"
  end
end

class Computer < Player
  BEAT_ROCK = [Paper.new, Spock.new]
  BEAT_PAPER = [Scissors.new, Lizard.new]
  BEAT_SCISSORS = [Rock.new, Spock.new]
  BEAT_LIZARD = [Rock.new, Scissors.new]
  BEAT_SPOCK = [Paper.new, Lizard.new]

  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def choose
    moves_arr = [Rock.new, Paper.new, Scissors.new, Lizard.new, Spock.new]
    self.move = moves_arr.sample
  end

  def choose_not_rock
    self.move = BEAT_ROCK.sample
  end

  def choose_not_paper
    self.move = BEAT_PAPER.sample
  end

  def choose_not_scissors
    self.move = BEAT_SCISSORS.sample
  end

  def choose_not_lizard
    self.move = BEAT_LIZARD.sample
  end

  def choose_not_spock
    self.move = BEAT_SPOCK.sample
  end
end

class RPSGame
  attr_accessor :human, :computer, :h_score, :c_score, :c_history_arr, :h_history_arr

  def initialize
    @human = Human.new
    @computer = Computer.new
    @@h_score = 0
    @@c_score = 0
    @@c_history_arr = []
    @@h_history_arr = []
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors, Spock or Lizard!"
  end

  def display_goodbye_message
    puts "Thank you for playing! Goodbye."
  end

  def display_chosen_moves
    puts "#{human.name} chose #{human.move}"
    puts "#{computer.name} chose #{computer.move}"
  end

  def display_winner
    if human.move > computer.move
      puts "#{human.name} won!"
      @@h_score += 1
      @@h_history_arr << human.move.to_s
      @@c_history_arr << computer.move.to_s
    elsif human.move < computer.move
      puts "#{computer.name} won!"
      @@c_score += 1
      @@c_history_arr << computer.move.to_s
      @@h_history_arr << human.move.to_s
    else
      puts "It's a tie."
      @@h_score += 1
      @@c_score += 1
      @@h_history_arr << human.move.to_s
      @@c_history_arr << computer.move.to_s
    end
  end

  def display_final_score
    p "#{human.name} vs #{computer.name}: #{@@h_score}-#{@@c_score}"
  end

  def play_again?
    input = nil
    loop do
      puts "Play again? (y/N)"
      input = gets.chomp
      break if ['y', 'n'].include?(input.downcase)
      puts "Sorry, must be y or n"
    end
    return true if input == 'y'
    return false if input == 'n'
  end

  def display_history_moves
    p "History moves for you #{@@h_history_arr}"
    p "History moves for computer #{@@c_history_arr}"
  end

  def check_human_moves_computer_choose
    rock_count = scissors_count = paper_count = lizard_count = spock_count = 0

    @@h_history_arr.each do |mv|
      rock_count += 1 if mv == "rock"
      scissors_count += 1 if mv == "scissors"
      paper_count += 1 if mv == "paper"
      lizard_count += 1 if mv == "lizard"
      spock_count += 1 if mv == "spock"
    end
    total_count = (rock_count + scissors_count + paper_count + lizard_count + spock_count).to_f
    rock_mv = rock_count / total_count
    scissors_mv = scissors_count / total_count
    paper_mv = paper_count / total_count
    lizard_mv = lizard_count / total_count
    spock_mv = spock_count / total_count

    if (rock_count == 0) && (scissors_count == 0) && (paper_count == 0) && (lizard_count == 0) && (spock_count == 0)
      computer.choose
    elsif rock_mv >= 0.6
      computer.choose_not_rock
    elsif scissors_mv >= 0.6
      computer.choose_not_scissors
    elsif paper_mv >= 0.6
      computer.choose_not_paper
    elsif lizard_mv >= 0.6
      computer.choose_not_lizard
    elsif spock_mv >= 0.6
      computer.choose_not_spock
    else
      computer.choose
    end
  end

  def play
    display_welcome_message
    loop do
      human.choose
      check_human_moves_computer_choose
      display_chosen_moves
      display_winner
      break unless play_again?
    end
    display_final_score
    display_history_moves
    display_goodbye_message
  end
end

RPSGame.new.play
