require_relative 'board.rb'
require 'byebug'

class Game
  attr_reader :board

  def initialize
    # @white_player = white_player
    # @black_player = black_player
    @board = Board.new
    @current_player = :white
    nil
  end

  def play
    until board.winner
      begin
        board.display
        moves = user_input
        player_piece = board[moves.first]
        raise InvalidMoveError if player_piece.color != @current_player

        player_piece.perform_moves(moves[1..-1])
      rescue InvalidMoveError
        puts "Invalid move!"
        retry
      end
      change_player
    end

    winner == :white ? puts("White won!") : puts("Black won!")
  end

  def user_input
    puts "What's your move/moves? (ex: 0.1,2.3,4.5)"
    move = gets.chomp.split(",")
    move = move.map { |el| el.split(".") }
    move.map do |arr|
      arr.map { |el| el.to_i }
    end
  end

  def change_player
    @current_player = (@current_player == :white) ? :black : :white
  end

end
