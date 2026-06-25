require_relative './Piece.rb'
class Pawn < Piece
    def initialize(name,side,row,col,board)
        super(name,side,row,col,board)
    end

    def unpinned_moves
        m = []
        if self.side == 'W'            
            if squareEmpty?(row+1, col) # move forward one
                encode_and_add_move(m, row+1, col, check: detect_check(row+1,col) )
            end
            if row == 1 && squareEmpty?(row+2, col) && squareEmpty?(row+1, col) # move forward two if on starting rank
                encode_and_add_move(m, row+2, col, check: detect_check(row+2,col))
            end
            if row+1 <= 7 && col-1 >= 0 && !squareEmpty?(row+1,col-1) && board[row+1][col-1].side == 'B' # capture left
                encode_and_add_move(m, row+1, col-1, captures:true, check: detect_check(row+1,col-1))
            end
            if row+1 <= 7 && col+1 <=7 && !squareEmpty?(row+1,col+1) && board[row+1][col+1].side == 'B' # capture right
                encode_and_add_move(m, row+1, col+1, captures:true, check: detect_check(row+1,col+1))
            end
        elsif self.side == 'B'
            if squareEmpty?(row-1,col) # move forward one
                encode_and_add_move(m, row-1, col, check: detect_check(row-1,col))
            end
            if row == 6 && squareEmpty?(row-2,col) && squareEmpty?(row-1,col) # move forward two if on starting rank
                encode_and_add_move(m, row-2, col, check: detect_check(row-2,col))
            end
            if row-1 >= 0 && col-1 >= 0 && !squareEmpty?(row-1,col-1) && board[row-1][col-1].side == 'W' #capture left
                encode_and_add_move(m, row-1, col-1, captures:true, check: detect_check(row-1,col-1))
            end
            if row-1 >= 0 && col+1 <= 7 && !squareEmpty?(row-1,col+1) && board[row-1][col+1].side == 'W' #capture right
                encode_and_add_move(m, row-1, col+1, captures:true, check: detect_check(row-1,col+1))
            end
        end
        
        return m
    end

    def detect_check(r, c)
        if side == 'W'
            if r+1 <= 7 && c-1 >= 0 && !squareEmpty?(r+1,c-1) && board[r+1][c-1].side == 'B' && board[r+1][c-1].name == 'K'
                return true
            end
            if r+1 <= 7 && c+1 <= 7 && !squareEmpty?(r+1,c+1) && board[r+1][c+1].side == 'B' && board[r+1][c+1].name == 'K'
                return true
            end
        elsif side == 'B'
            if r-1 >= 0 && c-1 >= 0 && !squareEmpty?(r-1,c-1) && board[r-1][c-1].side == 'W' && board[r-1][c-1].name == 'K'
                return true
            end
            if r-1 >= 0 && c+1 <= 7 && !squareEmpty?(r-1,c+1) && board[r-1][c+1].side == 'W' && board[r-1][c+1].name == 'K'
                return true
            end
        end
        return false
    end

    def moves_that_capture_own_pieces
        m = []
        if self.side == 'W'
            if row+1 <= 7 && col-1 >= 0 && !squareEmpty?(row+1,col-1) && board[row+1][col-1].side == self.side
                encode_and_add_move(m,row+1,col-1,captures:true)
            end
            if row+1 <= 7 && col+1 <= 7 && !squareEmpty?(row+1,col+1) && board[row+1][col+1].side == self.side
                encode_and_add_move(m,row+1,col+1,captures:true)
            end
        else
            if row-1 >= 0 && col-1 >=0 && !squareEmpty?(row-1,col-1) && board[row-1][col-1].side == self.side
                encode_and_add_move(m,row-1,col-1,captures:true)
            end
            if row-1 >= 0 && col+1 <= 7 && !squareEmpty?(row-1,col+1) && board[row-1][col+1].side == self.side
                encode_and_add_move(m,row-1,col+1,captures:true)
            end
        end
        m
    end

    def attacked_squares
        m = []
        if self.side == 'W'
            if row+1 <= 7 && col-1 >= 0 then encode_and_add_move(m,row+1,col-1,captures:true) end
            if row+1 <= 7 && col+1 <= 7 then encode_and_add_move(m,row+1,col+1,captures:true) end
        else
            if row-1 >= 0 && col-1 >= 0 then encode_and_add_move(m,row-1,col-1,captures:true) end
            if row-1 >= 0 && col+1 <= 7 then encode_and_add_move(m,row-1,col+1,captures:true) end
        end
        return m
    end 

    def encode_and_add_move(list, r, c, captures:false, check:false, promote:false, promo_result:'')
        string = (captures ? 'abcdefgh'[col] + 'x' : '') + 'abcdefgh'[c] + (r+1).to_s + (promote ? "=#{promo_result}" : '') + (check ? '+' : '')
        list.append(string)
    end

end