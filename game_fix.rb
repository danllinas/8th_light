#monkeypatch to check if a string is a number.
class String
  def is_i?
    !!(self =~ /\A[-+]?[0-9]+\z/)
  end
end

class Game
  attr_accessor :player_1, :player_2, :game_type

  def initialize
    @board = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
  end

  def draw_board
    puts " _#{@board[0]}_|_#{@board[1]}_|_#{@board[2]}_ \n _#{@board[3]}_|_#{@board[4]}_|_#{@board[5]}_ \n _#{@board[6]}_|_#{@board[7]}_|_#{@board[8]}_ \n"
  end

  #refactored most common directions to clean up the rest of the code.
  def directions(flag, player: nil, first_move: nil)
    case flag
    when 1
      puts "Choose a unique marker for #{player}. You can use any symbol on the keyboard, but please limit to a single character. And don't choose a number."
    when 2
      puts "Choose '1' for human vs. human. Choose '2' for human vs. computer."
    when 3
      puts "Make sure that the markers are not numbers. Please choose the player markers again."
    when 4
      puts "You can't have the same markers. Please choose unique markers."
    when 5
      puts "All right, humans. Go ahead and play each other. #{first_move} goes first. Make your move. Choose a space to place your marker by selecting a number from 1 - 9."
    when 6
      puts "Please make a valid selection."
    when 7
      puts "You want to challenge me. How cute. The game is simple. Choose a space to place your marker by selecting a number from 1 - 9. #{first_move} goes first."
    when 8
      puts "Go ahead, human. Your marker is: #{player}."
    end
  end

  def start_game
    puts "Welcome to my Tic Tac Toe game!"
    draw_board
    choose_players
  end

  #Human vs human, or human vs. computer.
  def choose_players
    puts "Are you playing against a friend? Or will you try your luck against me?"
    directions(2)
    @game_type = gets.chomp!.to_i

    unless @game_type == 1 || @game_type == 2 #loop to ensure an appropriate selection.
      directions(6)
      directions(2)
      choose_players
    end

    choose_marker
  end

  #choose unique, non-integer markers for both players.
  def choose_marker
    directions(1, player: "Player 1")
    @player_1 = gets.chomp!
    @player_1 = @player_1[0] if @player_1.length > 1 #if user chose a marker that is more than a single character, this sets the marker to just the first character.

    directions(1, player: "Player 2")
    @player_2 = gets.chomp!
    @player_2 = @player_2[0] if @player_2.length > 1
    validate_markers(@player_1, @player_2)
  end

  #makes sure that the user didn't choose an integer as a marker.
  def validate_markers(mark_1, mark_2)
    if mark_1.is_i? || mark_2.is_i?
      directions(3)
      choose_marker
    elsif mark_1 == mark_2 #markers must be unique
      directions(4)
      choose_marker
    else
      who_goes_first
    end
  end

  #determines which plaer will go first and passes that choice in a variable to the game initialize method.
  def who_goes_first
    puts "So who goes first? Type '1' for Player 1, and '2' for Player 2. If you're playing against me, consider me Player 2."
    first_move = gets.chomp.to_i
    case first_move
    when 1
      puts "Player 1 will go first."
      first_move = "Player 1"
    when 2
      puts "Player 2 will go first."
      first_move = "Player 2"
    else
      who_goes_first
    end
    game_initialization(first_move)
  end

  #kicks off either human v human or human v computer based on the user's previous choice.
  def game_initialization(first_move)
    case @game_type
    when 1
      directions(5, first_move: first_move)
      draw_board

      #assigning markers to first or second player
      first_move == "Player 1" ? first = @player_1 : first = @player_2
      first == @player_1 ? second = @player_2 : second = @player_1

      human_vs_human(first, second)#kicks off the game.
    when 2
      directions(7, first_move: first_move)
      draw_board

      first_move == "Player 1" ? first = @player_1 : first = @player_2
      first == @player_1 ? second = @player_2 : second = @player_1

      computer_vs_human(first, second)#kicks off the game.
    end
  end

  #runs the game progression.
  def computer_vs_human(first, second)
    if first == @player_1 #if human has first move...
      directions(8, player: first)

      #game loop that checks game_is_over & tie booleans. Will run until one of those is true.
      until game_is_over(@board) || tie(@board)
        puts "It's your turn, marker #{first}."
        get_player_spot(first)
        if !game_is_over(@board) && !tie(@board)
          eval_board
        end
        draw_board
      end

      puts "Game Over!"
    else #inverted the loop in case the user lets the computer go first.
      puts "Great! I get to go first."

      until game_is_over(@board) || tie(@board)
        if !game_is_over(@board) || !tie(@board)
          puts "It's my turn with marker: #{first}."
          eval_board
        end
        if !game_is_over(@board) || !tie(@board)
          draw_board
          puts "It's your turn, marker #{second}."
          get_player_spot(second)
          draw_board
        end
      end

      puts "Game Over!"
    end
  end

  #Runs the game for two people playing each other.
  def human_vs_human(first, second)
    until game_is_over(@board) || tie(@board)
      puts "It's your turn, marker #{first}."
      get_player_spot(first)
      if !game_is_over(@board) && !tie(@board)
        draw_board
        puts "It's your turn, marker #{second}."
        get_player_spot(second)
      end
      draw_board
    end

    puts "Game over!"
  end

  def get_player_spot(player)
    spot = nil

    spot = gets.chomp!.to_i
    p spot

    #forces the user to choose a number between 1 - 9.
    if spot == 0 || spot > 9
      directions(6)
      spot = nil
      get_player_spot(player)
    else
      asssign_spot(spot, player)
    end

  end

  def asssign_spot(spot, player)
    #changed board to start at one, so have to check for spot - 1. Condition checks to see of the spot is available.
    if @board[spot - 1] != @player_1 && @board[spot -1] != @player_2
      @board[spot - 1] = player
    else
      puts "That spot is already taken. Please choose a valid spot."
      get_player_spot(player)
    end
  end

  #method for cpu to choose a good move.
  def eval_board
    spot = nil

    #loop runs until cpu has assinged a value to spot. If center spot is avaialbe, it takes that, and if not, it runs method for choosing best move.
    until spot
      if @board[4] == "5"
        spot = 5
        @board[spot - 1] = @player_2
        puts "I'll take space #{spot}."
      else
        spot = get_best_move(@board, @player_2)

        #Don't [spot-1] here. Handled that in the get_best_move method.
        if @board[spot] != @player_1 && @board[spot] != @player_2
          puts "I'm placing my marker on #{@board[spot]}"
          @board[spot] = @player_2
        else
          spot = nil
        end
      end
    end
  end

  def get_best_move(board, next_player, depth = 0, best_score = {})
    available_spaces = []
    best_move = nil

    #loop finds all possible moves and shovels them into available_spaces
    board.each do |spot|
      if spot != @player_1 && spot != @player_2
        available_spaces << spot
      end
    end

    #loop that determines best move.
    available_spaces.each do |as|
      #assign player 2 marker to an available space on each iteration.
      board[as.to_i - 1] = @player_2

      #if it ends the game, return that as the best move.
      if game_is_over(board)
        best_move = as.to_i - 1
        board[as.to_i - 1] = as #clears the board of hypothetical move.
        return best_move
      else
        #check if a human move on the available spaces will end the game, and if so, put the computer marker there.
        board[as.to_i - 1] = @player_1

        if game_is_over(board)
          best_move = as.to_i - 1
          board[as.to_i - 1] = as #clears the board of hypothetical move.
          return best_move
        else
          board[as.to_i - 1] = as #clears the board if no best move is found.
        end
      end
    end

    if best_move
      return best_move
    else

      n = rand(0..available_spaces.count)
      return available_spaces[n].to_i
    end
  end

  #returns true if one player has won.
  def game_is_over(b)
    [b[0], b[1], b[2]].uniq.length == 1 ||
    [b[3], b[4], b[5]].uniq.length == 1 ||
    [b[6], b[7], b[8]].uniq.length == 1 ||
    [b[0], b[3], b[6]].uniq.length == 1 ||
    [b[1], b[4], b[7]].uniq.length == 1 ||
    [b[2], b[5], b[8]].uniq.length == 1 ||
    [b[0], b[4], b[8]].uniq.length == 1 ||
    [b[2], b[4], b[6]].uniq.length == 1
  end

  #returns true if game is a tie.
  def tie(b)
    b.all? { |s| s == @player_1 || s == @player_2 }
  end

end

game = Game.new
game.start_game
