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
                    if squareEmpty?(row+dr,col+dc) 
                        if !square_attacked?(row+dr,col+dc) then encode_and_add_move(m,row+dr,col+dc) end
                    elsif board[row+dr][col+dc].side != self.side && !square_defended?(row+dr,col+dc) 
                        encode_and_add_move(m,row+dr,col+dc,captures:true)
                    end
                end
            end
        end
        return m
    end
    

    #for when two king are both looking at the same square 
    #don't check defended to avoid infinite recursion
    #returns the empty squares around a king that the other king shouldn't move into
    def moves_dont_check_defended
        m = []
        [-1,0,1].each do |dr|
            [-1,0,1].each do |dc|
                if row+dr >= 0 && row+dr <=7 && col+dc >= 0 && col+dc <= 7 && !(dr == 0 && dc == 0)
                    if squareEmpty?(row+dr,col+dc) then encode_and_add_move(m,row+dr,col+dc) end
                end
            end
        end
        return m        
    end

    def moves_that_capture_own_pieces
        m = []
        [-1,0,1].each do |dr|
            [-1,0,1].each do |dc|
                if row+dr>=0 && row+dr<=7 && col+dc>=0 && col+dc<=7 && !(dr==0 && dc==0)
                    if !squareEmpty?(row+dr,col+dc) && board[row+dr][col+dc].side == self.side
                        encode_and_add_move(m,row+dr,col+dc,captures:true)
                    end
                end
            end
        end
        m
    end

    #called on squares with a piece on it
    #for making sure the king only captures an enemy piece that isn't defended
    def square_defended?(r,c) 
        board.each do |row|
            row.each do |p|
                if p!= nil && p.side != self.side
                    p.moves_that_capture_own_pieces.each do | enemy_move |
                    h = p.decode_move(enemy_move)
                    if h[:r] == r && h[:c] == c then return true end
                    end
                end
            end
        end
        return false
    end
    
    def square_attacked?(r,c)
        board.each do |row|
            row.each do |p|
                if p != nil && p.side != self.side
                    if p.instance_of?(King) 
                        p.moves_dont_check_defended.each do |enemy_move|
                            h = p.decode_move(enemy_move)
                            if h[:r] == r && h[:c] == c then return true end
                        end
                    else
                        p.attacked_squares.each do |enemy_move| 
                            h = p.decode_move(enemy_move)
                            if h[:r] == r && h[:c] == c then return true end
                        end
                    end
                end
            end
        end
        return false
    end

    def encode_and_add_move(list, r, c, captures:false)
        string = 'K' + (captures ? 'x' : '') + 'abcdefgh'[c] + (r+1).to_s 
        list.append(string)
    end
end