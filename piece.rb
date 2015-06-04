# http://copypastecharacter.com/emojis
# encoding: utf-8

require 'byebug'

class InvalidMoveError < StandardError
end

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

  def find_direction(to_pos)
    i = (pos[0] > to_pos[0]) ? -1 : 1
    j = (pos[1] > to_pos[1]) ? -1 : 1
    dir = [i, j]

    move_dirs.include?([i, j]) ? [i, j] : false
  end

  def perform_slide(to_pos)
    return false unless board.valid_pos?(to_pos) && board.empty_pos?(to_pos)

    dir = find_direction(to_pos)
    return false unless dir
    i, j = dir

    move = [pos[0] + i, pos[1] + j]

    if king == false
      if move == to_pos
        finish_slide(to_pos)
        return true
      else
        return false
      end
    end

    if king == true
      while board.valid_pos?(move) && board.empty_pos?(move)
        if move == to_pos
          finish_slide(to_pos)
          return true
        end
        move = [move[0] + i, move[1] + j]
      end
    end
  end

  def finish_slide(to_pos)
    board[pos] = nil
    self.pos = to_pos
    board[to_pos] = self

    maybe_promote
  end


  def perform_jump(to_pos)
    return false unless board.valid_pos?(to_pos) && board.empty_pos?(to_pos)

    dir = find_direction(to_pos)
    return false unless dir
    i, j = dir

    to_jump_pos = jump_over_pos(dir, to_pos)
    return false if !to_jump_pos

    move = [pos[0] + i + i, pos[1] + j + j ]

    if king == false
      if move == to_pos
        finish_jump(to_pos, to_jump_pos)
        return true
      else
        return false
      end
    end

    if king == true
      while board.valid_pos?(move)

        if move == to_pos
          finish_jump(to_pos, to_jump_pos)
          return true
        end
        move = [move[0] + i, move[1] + j]
      end
      return false
    end

  end

  def jump_over_pos(dir, to_pos)
    i, j = dir
    pos = [to_pos[0] - i, to_pos[1] - j]
    piece = board[pos]
    if !board.empty_pos?(pos) && piece.color == opposite_color
      pos
    else
      false
    end
  end

  def finish_jump(to_pos, to_jump_pos)
    board[pos] = nil
    board[to_jump_pos] = nil
    self.pos = to_pos
    board[to_pos] = self

    maybe_promote
  end

  def opposite_color
    color == :white ? :black : :white
  end

  def move_dirs
    if king
      WHITE_DIR + BLACK_DIR
    else
      color == :white ? WHITE_DIR : BLACK_DIR
    end
  end

  def maybe_promote
    if (color == :white && pos[0] == 0) || (color == :black && pos[0] == 7)
      self.king = true
    end
  end

  def perform_moves!(move_sequence)
    if move_sequence.count == 1
      try = perform_slide(move_sequence.first) || perform_jump(move_sequence.first)
      raise InvalidMoveError if !try
    else
      move_sequence.each do |move|
        current = perform_jump(move)
        raise InvalidMoveError if !current
      end
    end
  end

  def valid_move_sequence?(move_sequence)
    new_board = board.dup
    begin
      new_board[self.pos].perform_moves!(move_sequence)
    rescue InvalidMoveError
      return false
    else
      true
    end
  end

  def perform_moves(move_sequence)
    if valid_move_sequence?(move_sequence)
      perform_moves!(move_sequence)
    else
      raise InvalidMoveError
    end
  end

end
