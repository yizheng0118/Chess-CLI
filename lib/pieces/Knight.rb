require_relative './Piece.rb'
class Knight < Piece
    
    def initialize(name,side,row,col,board)
        super(name,side,row,col,board)
    end

    def unpinned_moves
        m = []
        [-2,-1,1,2].each do |dr|
            dc1 = 3 - dr.abs
            dc2 = -dc1
            r = row+dr
            c1 = col+dc1
            c2 = col+dc2
            if r>=0&&r<=7 && c1>=0&&c1<=7 
                if squareEmpty?(r,c1) then encode_and_add_move(m,r,c1) 
                elsif board[r][c1].side != self.side then encode_and_add_move(m,r,c1,captures:true)
                end
            end
            if r>=0&&r<=7 && c2>=0&&c2<=7
                if squareEmpty?(r,c2) then encode_and_add_move(m,r,c2)
                elsif board[r][c2].side != self.side then encode_and_add_move(m,r,c2,captures:true)
                end
            end
        end
        return m
    end

    def moves_that_capture_own_pieces
        m = []
        [-2,-1,1,2].each do |dr|
            dc1 = 3 - dr.abs
            dc2 = -dc1
            r = row+dr
            c1 = col+dc1
            c2 = col+dc2
            if r>=0&&r<=7 && c1>=0&&c1<=7 && !squareEmpty?(r,c1) && board[r][c1].side == self.side
                encode_and_add_move(m,r,c1,captures:true) 
            end
            if r>=0&&r<=7 && c2>=0&&c2<=7 && !squareEmpty?(r,c2) && board[r][c2].side == self.side
                encode_and_add_move(m,r,c2,captures:true)
            end
        end
        return m
    end


    def detect_check(r,c)
        [-2,-1,1,2].each do |dr|
            dc1 = 3 - dr.abs
            dc2 = -dc1
            if r + dr >= 0 && r + dr <= 7 && c + dc1 >= 0 && c + dc1 <= 7 
                if !squareEmpty?(r+dr,c+dc1) && board[r+dr][c+dc1].side != self.side && board[r+dr][c+dc1].name == 'K' then return true end
            end
            if r + dr >= 0 && r + dr <= 7 && c + dc2 >= 0 && c + dc2 <= 7    
                if !squareEmpty?(r+dr,c+dc2) && board[r+dr][c+dc2].side != self.side && board[r+dr][c+dc2].name == 'K' then return true end
            end        
        end
        return false
    end

    def encode_and_add_move(list, r, c, captures:false)
        check = detect_check(r,c)
        string = 'N' + (captures ? 'x' : '') + 'abcdefgh'[c] + (r+1).to_s + (check ? '+' : '')
        list.append(string)
    end
end