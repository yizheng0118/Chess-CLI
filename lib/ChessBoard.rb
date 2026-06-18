require_relative './pieces/Pawn.rb'
require_relative './pieces/Rook.rb'
require_relative './pieces/Knight.rb'
require_relative './pieces/Bishop.rb'
require_relative './pieces/Queen.rb'
require_relative './pieces/King.rb'

class ChessBoard
    attr_accessor :board, :white_pieces, :black_pieces, :turn
    def initialize
        @board = nil   
        @white_pieces = nil
        @black_pieces = nil
    end

    def new_game
        self.board = Array.new(8) { Array.new(8) }
        self.white_pieces = []
        self.black_pieces = []
        self.turn = 'W'
        (0..7).each do |n|
            white_pawn = Pawn.new('P','W',1,n,board)
            white_pieces.append(white_pawn)
            self.board[1][n] = white_pawn
            black_pawn = Pawn.new('p','B',6,n,board)
            black_pieces.append(black_pawn)
            self.board[6][n] = black_pawn
        end
        r1 = Rook.new('R','W',0,0,board)
        self.board[0][0] = r1
        k1 = Knight.new('N','W',0,1,board)
        self.board[0][1] = k1
        b1 = Bishop.new('B','W',0,2,board)
        self.board[0][2] = b1
        q = Queen.new('Q','W',0,3,board)
        self.board[0][3] = q
        k = King.new('K','W',0,4,board)
        self.board[0][4] = k
        b2 = Bishop.new('B','W',0,5,board)
        self.board[0][5] = b2
        k2 = Knight.new('N','W',0,6,board)
        self.board[0][6] = k2
        r2 = Rook.new('R','W',0,7,board)
        self.board[0][7] = r2
        self.white_pieces += [r1,r2,k1,k2,b1,b2,q,k]
        r1 = Rook.new('r','B',7,0,board)
        self.board[7][0] = r1
        k1 = Knight.new('n','B',7,1,board)
        self.board[7][1] = k1
        b1 = Bishop.new('b','B',7,2,board)
        self.board[7][2] = b1
        q = Queen.new('q','B',7,3,board)
        self.board[7][3] = q
        k = King.new('K','B',7,4,board)
        self.board[7][4] = k
        b2 = Bishop.new('b','W',7,5,board)
        self.board[7][5] = b2
        k2 = Knight.new('n','W',7,6,board)
        self.board[7][6] = k2
        r2 = Rook.new('r','W',7,7,board)
        self.board[7][7] = r2
        self.black_pieces += [r1,r2,k1,k2,b1,b2,q,k]
    end

    def player_make_move
        input = take_user_input.chomp
        if self.turn == 'W' then p = find_piece_to_move(input,white_pieces)
        else p = find_piece_to_move(input,black_pieces) end
        if p == nil
            puts 'invalid move'
            return
        end
        move_piece_on_board(input,p)

        if self.turn == 'W' then self.turn = 'B'
        else self.turn = 'W' end
    end

    def take_user_input
        return gets
    end

    def find_piece_to_move(move,pieces)
        pieces.each do |p|
            if p.moves.include?(move)
                return p
            end
        end
        return nil
    end

    def move_piece_on_board(move,piece)
        h = piece.decode_move(move) 
        if !piece.squareEmpty?(h[:r],h[:c])
            if self.turn == 'W'
                self.black_pieces.delete(self.board[h[:r]][h[:c]])
            else
                self.white_pieces.delete(self.board[h[:r]][h[:c]])
            end
        end
        piece.moveTo(h[:r],h[:c])
    end


    def to_s
        s = ""
        board.reverse.map do |row|
            row.each do |p|
                if p == nil
                    s += '.'
                else
                    s += p.name
                end
            end
            s += "\n"
        end
        s
    end

end