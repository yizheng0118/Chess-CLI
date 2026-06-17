require_relative './Piece.rb'
class Knight < Piece
    
    def initialize(name,side,row,col,board)
        super(name,side,row,col,board)
    end

    def moves
        m = []

        return m
    end

    def detect_check(r,c)

    end

    def encode_and_add_move(list, r, c, captures:false, check:false)
        string = 'N' + (captures ? 'x' : '') + 'abcdefgh'[c] + (r+1).to_s + (check ? '+' : '')
        list.append(string)
    end
end