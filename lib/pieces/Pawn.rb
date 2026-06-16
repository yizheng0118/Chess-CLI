require_relative './Piece.rb'
class Pawn < Piece

    def initialize(name,side,row,col,board)
        super(name,side,row,col,board)
    end

    def moves
        m = []
        if self.side == 'W'            
            if squareEmpty?(row+1, col) # move forward one
                encodeAndAddMove(m, row+1, col, false, false) 
            end
            if row == 1 && squareEmpty?(row+2, col) && squareEmpty?(row+1, col) # move forward two if on starting rank
                encodeAndAddMove(m, row+2, col, false, false)
            end
            if row+1 <= 7 && col-1 >= 0 && !squareEmpty?(row+1,col-1) && board[row+1][col-1].side == 'B' # capture left
                encodeAndAddMove(m, row+1, col-1, true, false)
            end
            if row+1 <= 7 && col+1 <=7 && !squareEmpty?(row+1,col+1) && board[row+1][col+1].side == 'B' # capture right
                encodeAndAddMove(m, row+1, col+1, true, false)
            end
        elsif self.side == 'B'
            if squareEmpty?(row-1,col) # move forward one
                encodeAndAddMove(m, row-1, col, false, false)
            end
            if row == 6 && squareEmpty?(row-2,col) && squareEmpty?(row-1,col) # move forward two if on starting rank
                encodeAndAddMove(m, row-2, col, false, false)
            end
            if row-1 >= 0 && col-1 >= 0 && !squareEmpty?(row-1,col-1) && board[row-1][col-1].side == 'W' #capture left
                encodeAndAddMove(m, row-1, col-1, true, false)
            end
            if row-1 >= 0 && col+1 <= 7 && !squareEmpty?(row-1,col+1) && board[row-1][col-1].side == 'W' #capture right
                encodeAndAddMove(m, row-1, col+1, true, false)
            end
        end
        
        return m
    end

    def encodeAndAddMove(list, r, c, captures, check)
        string = (captures ? 'abcdefgh'[col] + 'x' : '') + 'abcdefgh'[c] + (r+1).to_s + (check ? '+' : '' )
        list.append(string)
    end

end