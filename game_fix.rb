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
    unless @game_type == 1 || @game_type == 2
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

  def validate_markers(mark_1, mark_2)
    p mark_1, mark_2
    if mark_1.is_i? || mark_2.is_i?
      directions(3)
      choose_marker
    elsif mark_1 == mark_2
      directions(4)
      choose_marker
    else
      who_goes_first
    end
  end

  def who_goes_first
    puts "So who goes first? Type '1' for Player 1, and '2' for Player 2."
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
    game_progression(first_move)
  end

  def game_progression(first_move)
    case @game_type
    when 1
      directions(5, first_move: first_move)

      draw_board

      first_move == "Player 1" ? first = @player_1 : first = @player_2
      first == @player_1 ? second = @player_2 : second = @player_1

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
    when 2
      # puts "code for human v computer game"
    end


    # if first_move == "player_1"
    #   puts "Please select your spot."
    #   until game_is_over(@board) || tie(@board)
    #     get_human_spot
    #     if !game_is_over(@board) && !tie(@board)
    #       eval_board
    #     end
    #     puts "|_#{@board[0]}_|_#{@board[1]}_|_#{@board[2]}_|\n|_#{@board[3]}_|_#{@board[4]}_|_#{@board[5]}_|\n|_#{@board[6]}_|_#{@board[7]}_|_#{@board[8]}_|\n"
    #   end
    #   puts "Game over"
    # end
  end

  def get_player_spot(player)
    spot = nil

    spot = gets.chomp!.to_i
    p spot
    if spot == 0 || spot > 9
      directions(6)
      spot = nil
      get_player_spot(player)
    else
      asssign_spot(spot, player)
    end

  end

  def asssign_spot(spot, player)
    if @board[spot - 1] != @player_1 && @board[spot -1] != @player_2
      @board[spot - 1] = player
    else
      puts "That spot is already taken. Please choose a valid spot."
      get_player_spot(player)
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

    [b[1], b[2], b[3]].uniq.length == 1 ||
    [b[4], b[5], b[6]].uniq.length == 1 ||
    [b[7], b[8], b[9]].uniq.length == 1 ||
    [b[1], b[4], b[7]].uniq.length == 1 ||
    [b[2], b[5], b[8]].uniq.length == 1 ||
    [b[3], b[6], b[9]].uniq.length == 1 ||
    [b[1], b[5], b[9]].uniq.length == 1 ||
    [b[3], b[5], b[7]].uniq.length == 1
  end

  def tie(b)
    b.all? { |s| s == @player_1 || s == @player_2 }
  end

end

game = Game.new
game.start_game
