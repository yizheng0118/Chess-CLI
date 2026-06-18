require_relative './Piece.rb'

class King < Piece
    def initialize(name,side,row,col,board)
        super(name,side,row,col,board)
    end

    def moves
        m = []
        [-1,0,1].each do |dr|
            [-1,0,1].each do |dc|
                if row+dr >= 0 && row+dr <=7 && col+dc >= 0 && col+dc <= 7 && !(dr == 0 && dc == 0)
                    if squareEmpty?(row+dr,col+dc) then encode_and_add_move(m,row+dr,col+dc) 
                    elsif board[row+dr][col+dc].side != self.side then encode_and_add_move(m,row+dr,col+dc,captures:true)
                    end
                end
            end
        end
        return m
    end

    def encode_and_add_move(list, r, c, captures:false)
        string = 'K' + (captures ? 'x' : '') + 'abcdefgh'[c] + (r+1).to_s 
        list.append(string)
    end
end