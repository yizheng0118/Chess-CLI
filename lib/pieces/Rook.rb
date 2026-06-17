require_relative './Piece.rb'

class Rook < Piece
    def initialize(name,side,row,col,board)
        super(name,side,row,col,board)
    end

    def moves
        m = []
        t_c = col
        while t_c > 0 # check left
            if squareEmpty?(row,t_c-1)
                encode_and_add_move(m, row, t_c-1)
                t_c -= 1
            else # !squareEmpty?(row,t_c-1)
                if board[row][t_c-1].side != self.side then encode_and_add_move(m, row, t_c-1, captures:true) end
                break
            end
        end
        t_c = col
        while t_c < 7 # check right
            if squareEmpty?(row,t_c+1)
                encode_and_add_move(m, row, t_c+1)
                t_c += 1
            else
                if board[row][t_c+1].side != self.side then encode_and_add_move(m, row, t_c+1, captures:true) end
                break
            end
        end
        t_r = row
        while t_r > 0 # check down
            if squareEmpty?(t_r-1,col)
                encode_and_add_move(m, t_r-1, col)
                t_r -= 1
            else
                if board[t_r-1][col].side != self.side then encode_and_add_move(m, t_r-1, col, captures:true) end
                break
            end
        end
        t_r = row
        while t_r < 7 # check up
            if squareEmpty?(t_r+1,col)
                encode_and_add_move(m, t_r+1, col)
                t_r += 1
            else
                if board[t_r+1][col].side != self.side then encode_and_add_move(m, t_r+1, col, captures:true) end
                break
            end
        end
        return m
    end

    def detect_check(r,c)
        t_c = c
        while t_c > 0 # check left
            if !squareEmpty?(r,t_c-1) 
                if board[r][t_c-1].side != self.side && board[r][t_c-1].name == 'K' then return true 
                else break end
            else t_c -= 1 end
        end
        t_c = c
        while t_c < 7 # check right
            if !squareEmpty?(r,t_c+1)
                if board[r][t_c+1].side != self.side && board[r][t_c+1].name == 'K' then return true
                else break end
            else t_c += 1 end
        end
        t_r = r 
        while t_r > 0 # check down
            if !squareEmpty?(t_r-1,c)
                if board[t_r-1][c].side != self.side && board[t_r-1][c].name == 'K' then return true
                else break end
            else t_r -= 1 end
        end
        t_r = r 
        while t_r < 7 # check up
            if !squareEmpty?(t_r+1,c)
                if board[t_r+1][c].side != self.side && board[t_r+1][c].name == 'K' then return true
                else break end
            else t_r += 1 end
        end
        return false
    end

    def encode_and_add_move(list, r, c, captures:false)
        check = detect_check(r,c)
        string = 'R' + (captures ? 'x' : '') + 'abcdefgh'[c] + (r+1).to_s + (check ? '+' : '')
        list.append(string)
    end
end