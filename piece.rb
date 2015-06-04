# http://copypastecharacter.com/emojis
# encoding: utf-8

class Piece
  WHITE_DIR = [[-1, -1], [-1, 1]]
  BLACK_DIR = [[ 1, -1],  [ 1, 1]]

  attr_accessor :board, :pos
  attr_reader :color

  def initialize(color, board, pos)

    @color = color
    @pos = pos
    @board = board
    @board.add_piece(self, pos)
  end

  def display
    color == :white ? "☺" : "☻"
  end


  def perform_slide(to_pos)
    raise "Can't move there" unless board.valid_pos?(pos) && board.empty_pos?(pos)

    possible_moves = []
    move_dir.each do |dir|
      i, j = dir
      move = [pos[0] + i, pos[1] + j]
      possible_moves << move if board.valid_pos?(move)
    end
    if possible_moves.include?(to_pos)



  end

  def perform_jump
  end

  def move_dirs
    color == :white ? WHITE_DIR : BLACK-DIR
  end



end
