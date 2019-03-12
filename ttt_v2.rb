class Board
  INITIAL_MARKER = " "

  def initialize
    @squares = {}
    reset
  end

  def get_squares_at(num)
    @squares[num]
  end

  def set_squares_at(num, marker)
    @squares[num] = marker
  end

  def reset
    (1..9).each {|key| @squares[key] = Square.new(INITIAL_MARKER)}
  end
end

class Square
  attr_accessor :marker

  def initialize(marker)
    @marker = marker
  end

  def to_s
    String(marker)
  end
end

class Player
  attr_accessor :name

  def initialize(name="Player X")
    @name = name
  end
end

class TTTGame
  attr_accessor :board, :human, :computer, :choices, :h_moves_arr, :c_moves_arr, :h_score, :c_score

  WINNING_TILES = [[1,2,3],[4,5,6],[7,8,9],[1,4,7],[2,5,8],[3,6,9],[1,5,9],[3,5,7]]
  HUMAN_MARKER = "X"
  COMPUTER_MARKER = "O"
  

  def initialize
    @board = Board.new
    @human = Player.new
    @computer = Player.new
    @h_moves_arr = []
    @c_moves_arr = []
    @h_score = 0
    @c_score = 0
    @@choices = [1,2,3,4,5,6,7,8,9]
  end

  def human_moves
    answer = nil
    print "Please enter a number from 1-9. Remaining moves #{@@choices}: "
    loop do
      answer = gets.chomp.to_i
      break if (1..9).include?(answer) && @@choices.include?(answer)
      print "Sorry, invalid input. Please re-enter: "
    end
    board.set_squares_at(answer, HUMAN_MARKER)
    @@choices.delete(answer)
    h_moves_arr << answer
  end

  def computer_moves
    computer_move = @@choices.sample
    board.set_squares_at(computer_move, COMPUTER_MARKER)
    @@choices.delete(computer_move)
    c_moves_arr << computer_move
  end

  def reset_choices
    @@choices = [1,2,3,4,5,6,7,8,9]
  end

  def board_full?
    @@choices.empty?
  end

  def someone_won
    WINNING_TILES.each do |arr|
      if h_moves_arr.include?(arr[0]) && h_moves_arr.include?(arr[1]) && h_moves_arr.include?(arr[2])
        @h_score += 1
        return true
      elsif c_moves_arr.include?(arr[0]) && c_moves_arr.include?(arr[1]) && c_moves_arr.include?(arr[2])
        @c_score +=1
        return true
      end
    end
    false
  end

  def display_board
    puts ""
    puts "     |     |"
    puts "  #{board.get_squares_at(1)}  |  #{board.get_squares_at(2)}  |  #{board.get_squares_at(3)}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{board.get_squares_at(4)}  |  #{board.get_squares_at(5)}  |  #{board.get_squares_at(6)}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{board.get_squares_at(7)}  |  #{board.get_squares_at(8)}  |  #{board.get_squares_at(9)}"
    puts "     |     |"
    puts ""
  end

  def display_welcome_message
    puts "Welcome to Tic-Tac-Toe!"
  end

  def display_goodbye_message
    puts "Thank you for playing! Goodbye."
  end

  def set_player_name
    puts "Please enter your name: "
    answer = gets.chomp
    human.name = answer
  end

  def display_result
    puts "Final Score of #{human.name.capitalize} vs #{computer.name}: #{h_score}-#{c_score}"
  end

  def play_again?
    print "Would you wish to play again ? (y/n)"
    answer = nil
    loop do
      answer = gets.chomp.downcase
      break if ['y','n'].include?(answer)
      print "Sorry, please re-enter (y/n): "
    end
    answer == 'y'
  end

  def play
    display_welcome_message
    set_player_name
    loop do
      
      loop do
        display_board
        human_moves
        break if board_full? || someone_won

        computer_moves
        break if board_full? || someone_won
      end
      display_board
      break unless play_again?
      reset_choices
      board.reset
    end
    display_result
    display_goodbye_message
  end
end

game = TTTGame.new
game.play



