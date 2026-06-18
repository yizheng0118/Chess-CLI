require_relative './Piece.rb'
class Knight < Piece
    
    def initialize(name,side,row,col,board)
        super(name,side,row,col,board)
    end

    def moves
        m = []
        [-2,-1,1,2].each do |dr|
            dc1 = 3 - dr.abs
            dc2 = -dc1
            r = row+dr
            c1 = col+dc1
            c2 = col+dc2
            if squareEmpty?(r,c1) then encode_and_add_move(m,r,c1) 
            elsif board[r][c1].side != self.side then encode_and_add_move(m,r,c1,captures:true)
            end
            if squareEmpty?(r,c2) then encode_and_add_move(m,r,c2)
            elsif board[r][c2].side != self.side then encode_and_add_move(m,r,c2,captures:true)
            end
        end
        return m
    end

    def detect_check(r,c)
        [-2,-1,1,2].each do |dr|
            dc1 = 3 - dr.abs
            dc2 = -dc1
            if !squareEmpty?(r+dr,c+dc1) && board[r+dr][c+dc1].side != self.side && board[r+dr][c+dc1].name == 'K' then return true end
            if !squareEmpty?(r+dr,c+dc2) && board[r+dr][c+dc2].side != self.side && board[r+dr][c+dc2].name == 'K' then return true end
        end
        return false
    end

    def encode_and_add_move(list, r, c, captures:false)
        check = detect_check(r,c)
        string = 'N' + (captures ? 'x' : '') + 'abcdefgh'[c] + (r+1).to_s + (check ? '+' : '')
        list.append(string)
    end
end