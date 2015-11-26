class Game
  attr_accessor :player_1, :player_2, :game_type

  def initialize
    @board = ["0", "1", "2", "3", "4", "5", "6", "7", "8"]
  end

  def start_game
    puts "Welcome to my Tic Tac Toe game!"
    puts "|_#{@board[0]}_|_#{@board[1]}_|_#{@board[2]}_|\n|_#{@board[3]}_|_#{@board[4]}_|_#{@board[5]}_|\n|_#{@board[6]}_|_#{@board[7]}_|_#{@board[8]}_|\n"

    choose_players
  end

  #method to choose who will play. Human vs human, or human vs. computer.
  def choose_players
    puts "Are you playing against a friend? Or will you try your luck against me?"
    puts "Choose '1' for human vs. human.", "Choose '2' for human vs. computer."
    @game_type = gets.chomp!.to_i
    unless @game_type == 1 || @game_type == 2
      puts "Please make a valid selection. '1' for human vs. human, and '2' to try your luck against me."
      choose_players
    end
    choose_marker
  end

  #method to allow user to choose markers for both players.
  def choose_marker
    puts "Choose a unique marker for Player 1. You can use any symbol on the keyboard, but please limit to a single character. And don't choose a number."

    @player_1 = gets.chomp!
    @player_1 = @player_1[0] if @player_1.length > 1 #if user chose a marker that is more than a single character, this sets the marker to just the first character.

    puts "Choose a unique marker for Player 2. You can use any symbol on the keyboard, but please limit to a single character."
    @player_2 = gets.chomp!
    @player_2 = @player_2[0] if @player_2.length > 1
    validate_markers(@player_1, @player_2)
  end

  def validate_markers(mark_1, mark_2)
    if mark_1.to_i.is_a? Integer || mark_2.to_i.is_a? Integer
      puts "Make sure that the markers are not numbers. Please choose the player markers again."
      choose_marker
    else
      who_goes_first
    end
  end

  def who_goes_first
    puts "So who goes first? Type '1' for Player 1, and '2' for Player 2."
    first_move = gets.chomp!.to_i
    case first_move
    when 1
      first_move = player_1
      puts "Player 1 will go first."
    when 2
      first_move = player_2
      puts "Player 2 will go first."
    else
      who_goes_first
    end
    game_progression(first_move)
  end

  def game_progression(first_move)
    case @game_type
    when 1
      puts "#{first_move.split("_")[0].capitalize} goes first. Make your move."
      until game_is_over(@board) || tie(@board)
        get_player_spot
        puts "|_#{@board[0]}_|_#{@board[1]}_|_#{@board[2]}_|\n|_#{@board[3]}_|_#{@board[4]}_|_#{@board[5]}_|\n|_#{@board[6]}_|_#{@board[7]}_|_#{@board[8]}_|\n"
      end
    when 2
      # puts "code for human v computer game"
    end
    if first_move == "player_1"
      puts "Please select your spot."
      until game_is_over(@board) || tie(@board)
        get_human_spot
        if !game_is_over(@board) && !tie(@board)
          eval_board
        end
        puts "|_#{@board[0]}_|_#{@board[1]}_|_#{@board[2]}_|\n|_#{@board[3]}_|_#{@board[4]}_|_#{@board[5]}_|\n|_#{@board[6]}_|_#{@board[7]}_|_#{@board[8]}_|\n"
      end
      puts "Game over"
    end
  end

  def get_player_spot
    spot = nil
    until spot
      spot = gets.chomp.to_i
      if @board[spot] != "X" && @board[spot] != "O"
        @board[spot] = @player_1
      else
        spot = nil
      end
    end
  end

  def eval_board
    spot = nil
    until spot
      if @board[4] == "4"
        spot = 4
        @board[spot] = @player_2
      else
        spot = get_best_move(@board, @player_2)
        if @board[spot] != "X" && @board[spot] != "O"
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
    board.each do |spot|
      if s != "X" && s != "O"
        available_spaces << spot
      end
    end
    available_spaces.each do |as|
      board[as.to_i] = @com
      if game_is_over(board)
        best_move = as.to_i
        board[as.to_i] = as
        return best_move
      else
        board[as.to_i] = @hum
        if game_is_over(board)
          best_move = as.to_i
          board[as.to_i] = as
          return best_move
        else
          board[as.to_i] = as
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

  def tie(b)
    b.all? { |s| s == "X" || s == "O" }
  end

end

game = Game.new
game.start_game
