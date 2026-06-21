class Piece
    attr_accessor :name, :side, :row, :col, :board
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

    def moveTo(r,c)
        self.board[row][col] = nil
        self.row = r
        self.col = c
        self.board[row][col] = self
    end

    def squareEmpty?(r,c)
        #checks if the square is empty
        return self.board[r][c] == nil
    end
    
    def decode_move(str)
        m = str.match(/^([KQRBNabcdefgh])?x?([a-h][1-8])([+#])?$/)
        hash = 
        {
            piece: m[1] || 'P',
            r: m[2][1].to_i - 1,
            c: "abcdefgh".index(m[2][0]),
        }
        return hash
    end

    def to_s
        return side =='W' ? self.name : self.name.downcase
    end
    
end