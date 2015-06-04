# http://copypastecharacter.com/emojis
# encoding: utf-8

class Piece
  WHITE_DIR = [[-1, -1], [-1, 1]]
  BLACK_DIR = [[ 1, -1],  [ 1, 1]]

  attr_accessor :board, :pos, :color, :king


  def initialize(color, board, pos)

    @color = color
    @pos = pos
    @board = board
    @board.add_piece(self, pos)
    @king = false
  end

  def display
    color == :white ? "☺" : "☻"
  end

  def perform_slide(to_pos)
    return false unless board.valid_pos?(to_pos) && board.empty_pos?(to_pos)

    possible_moves = []
    move_dirs.each do |dir|
      i, j = dir
      move = [pos[0] + i, pos[1] + j]
      possible_moves << move if board.valid_pos?(move)
    end
    if possible_moves.include?(to_pos)
      board[pos] = nil
      self.pos = to_pos
      board[to_pos] = self
    else
      return false
    end
    maybe_promote
    true
  end

  def perform_jump(to_pos)
    return false unless board.valid_pos?(to_pos) && board.empty_pos?(to_pos)

    middle = nil
    move_dirs.each do |dir|
      i, j = dir
      move = [pos[0] + i + i, pos[1] + j + j]
      if move == to_pos
        middle = [pos[0] + i, pos[1] + j]
      end
    end

    return false if middle.nil?

    if board[middle].color = changed_color
      board[pos] = nil
      board[middle] = nil
      self.pos = to_pos
      board[to_pos] = self
    end
    maybe_promote
    true
  end

  def changed_color
    color = (color == :white) ? :black : :white
  end

  def move_dirs
    color == :white ? WHITE_DIR : BLACK_DIR
  end

  def maybe_promote
    if (color == :white && pos[0] == 0) || (color == :black && pos[0] == 7)
      self.king = true
    end
  end

  def perform_moves!(move_sequence)
  end

end
