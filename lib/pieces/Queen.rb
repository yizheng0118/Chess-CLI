require_relative './Piece.rb'
require_relative './Rook.rb'
require_relative './Bishop.rb'

class Queen < Piece
    attr_accessor :bishop, :rook
    def initialize(name,side,row,col,board)
        super(name,side,row,col,board)
        @bishop = Bishop.new('QB',side,row,col,board)
        @rook = Rook.new("QR",side,row,col,board)
    end

    def moves
        m = self.bishop.moves + self.rook.moves
        m.map do |s|
            s = 'Q' + s[1..-1]
            if !s.end_with?('+')
                h = decode_move(s)
                if self.bishop.detect_check(h[:r],h[:c]) || self.rook.detect_check(h[:r],h[:c]) then s += '+' end
            end
            s
        end
    end

end