class Piece
    attr_reader :name, :side, :row, :col, :board
    def initialize(name, side, row, col, board)
        @name = name
        @side = side
        @row = row
        @col = col
        @board = board
    end

    def moves
        return []
    end

    def squareEmpty?(r,c)
        #checks if the square is empty
        return self.board[r][c] == nil
    end
    
end