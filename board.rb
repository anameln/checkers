require_relative 'piece.rb'

class Board

  attr_reader :grid

  WHITE_ROWS = [5, 6, 7]
  BLACK_ROWS = [0, 1, 2]

  BOARD_EDGES = (0..7).to_a

  def initialize(set_up = true)
    @grid = Array.new(8) { Array.new(8) }
    set_up_board if set_up
    nil
  end

  def set_up_board
    setup_pieces(:white)
    setup_pieces(:black)
    nil
  end

  def setup_pieces(color)
    rows = (color == :white) ? WHITE_ROWS : BLACK_ROWS
    rows.each do |row|
      @grid[row].each_with_index do |sq, col_idx|
        next if (row.odd? && col_idx.odd?) || (row.even? && col_idx.even?)

        @grid[row][col_idx] = Piece.new(color, self, [row, col_idx])
      end
    end
  end

  def display
    horizontal = "+-------------------------------+"
    puts horizontal

    @grid.each do |row|
      print "|"
      row.each do |square|
        square.nil? ? print("   |") : print(" #{square.display} |")
      end
      puts "\n"
      puts horizontal
    end

    nil
  end

  def add_piece(piece, pos)
    self[pos] = piece
  end

  def [](pos)
    #raise "invalid positon" unless valid_pos?(pos)

    r, c = pos
    @grid[r][c]
  end

  def []=(pos, piece)
    #raise "invalid positon" unless valid_pos?(pos)

    r, c = pos
    @grid[r][c] = piece
  end

  def valid_pos?(pos)
    pos.all? { |coor| BOARD_EDGES.include?(coor) }
  end

  def empty_pos?(pos)
    self[pos].nil?
  end

  def pieces
    @grid.flatten.compact
  end

  def dup
    #debugger
    dup_board = Board.new(false)

    pieces.each do |piece|
      Piece.new(piece.color, dup_board, piece.pos)
    end

    dup_board
  end

  def all_pieces_of_color(color)
    pieces.select { |piece| piece.color == color }
  end

  def winner
    if all_pieces_of_color(:white).count == 0
      :black
    elsif all_pieces_of_color(:black).count == 0
      :white
    else
      false
    end
  end

end
