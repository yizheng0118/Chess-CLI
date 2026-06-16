require_relative './Piece.rb'
class Pawn < Piece

    def initialize(name,side,row,col,board)
        super(name,side,row,col,board)
    end

    def moves
        m = []
        if self.side == 'W' 
            # move forward one
            if squareEmpty?(row+1, col)
                encodeAndAddMove(m, row+1, col, false, false) 
            end
            # move forward two if on starting rank
            if row == 1 && squareEmpty?(row+2, col) 
                encodeAndAddMove(m, row+2, col, false, false)
            end
            # capture left
            if row-1 >= 0 && !squareEmpty?(row+1,col-1) && board[row+1][col-1].side == 'B'
                encodeAndAddMove(m, row+1, col-1, true, false)
            end
            # capture right
            if row+1 <= 7 && !squareEmpty?(row+1,col+1) && board[row+1][col+1].side == 'B'
                encodeAndAddMove(m, row+1, col+1, true, false)
            end
        elsif self.side == 'B'

        end
        
        return m
    end

    def encodeAndAddMove(list, r, c, captures, check)
        string = (captures ? 'abcdefgh'[col] + 'x' : '') + 'abcdefgh'[c] + (r+1).to_s + (check ? '+' : '' )
        list.append(string)
    end

end