require_relative './pieces/Pawn.rb'
require_relative './pieces/Rook.rb'
require_relative './pieces/Knight.rb'
require_relative './pieces/Bishop.rb'
require_relative './pieces/Queen.rb'
require_relative './pieces/King.rb'
require 'pry-byebug'

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
            black_pawn = Pawn.new('p','B',6,n,board)
            black_pieces.append(black_pawn)
        end
        r1 = Rook.new('R','W',0,0,board)
        k1 = Knight.new('N','W',0,1,board)
        b1 = Bishop.new('B','W',0,2,board)
        q = Queen.new('Q','W',0,3,board)
        k = King.new('K','W',0,4,board)
        b2 = Bishop.new('B','W',0,5,board)
        k2 = Knight.new('N','W',0,6,board)
        r2 = Rook.new('R','W',0,7,board)
        self.white_pieces += [r1,r2,k1,k2,b1,b2,q,k]
        r1 = Rook.new('r','B',7,0,board)
        k1 = Knight.new('n','B',7,1,board)
        b1 = Bishop.new('b','B',7,2,board)
        q = Queen.new('q','B',7,3,board)
        k = King.new('K','B',7,4,board)
        b2 = Bishop.new('b','B',7,5,board)
        k2 = Knight.new('n','B',7,6,board)
        r2 = Rook.new('r','B',7,7,board)
        self.black_pieces += [r1,r2,k1,k2,b1,b2,q,k]
    end

    # rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR
    def import_game(fen)
        self.board = Array.new(8) { Array.new(8) }
        self.white_pieces = []
        self.black_pieces = []
        self.turn = 'W'
        row = 7
        col = 0
        fen.each_char do |char|
            case char
                when 'r'
                    p = Rook.new('r','B',row,col,board)
                    self.black_pieces.append(p)
                    col += 1
                when 'n'
                    p = Knight.new('n','B',row,col,board)
                    self.black_pieces.append(p)
                    col += 1
                when 'b'
                    p = Bishop.new('b','B',row,col,board)
                    self.black_pieces.append(p)
                    col += 1
                when 'q'
                    p = Queen.new('q','B',row,col,board)
                    self.black_pieces.append(p)
                    col += 1
                when 'k' 
                    p = King.new('K','B',row,col,board)
                    self.black_pieces.append(p)
                    col += 1
                when 'p'
                    p = Pawn.new('p','B',row,col,board)
                    self.black_pieces.append(p)
                    col += 1
                when 'R'
                    p = Rook.new('R','W',row,col,board)
                    self.white_pieces.append(p)
                    col += 1
                when 'N'
                    p = Knight.new('N','W',row,col,board)
                    self.white_pieces.append(p)
                    col += 1
                when 'B'
                    p = Bishop.new('B','W',row,col,board)
                    self.white_pieces.append(p)
                    col += 1
                when 'Q'
                    p = Queen.new('Q','W',row,col,board)
                    self.white_pieces.append(p)
                    col += 1
                when 'K'
                    p = King.new('K','W',row,col,board)
                    self.white_pieces.append(p)
                    col += 1
                when 'P'
                    p = Pawn.new('P','W',row,col,board)
                    self.white_pieces.append(p)
                    col += 1
                when '/'
                    row -= 1
                    col = 0
                when /[1-8]/
                    col += char.to_i
            end
        end
    end

    def player_make_move(move)
        if self.turn == 'W' then p = find_piece_to_move(move,white_pieces)
        else p = find_piece_to_move(move,black_pieces) end
        if p == nil
            puts 'invalid move'
            return
        end
        move_status = move_piece_on_board(move,p)
        if move_status == nil
            puts 'invalid king move'
            return
        end
        if self.turn == 'W' then self.turn = 'B'
        else self.turn = 'W' end
    end

    def player_make_move_user_input_wrapper
        input = gets.chomp
        player_make_move(input)
    end

    def find_piece_to_move(move,pieces)
        pieces.each do |p|
            p.moves.each do |m|
                h1 = p.decode_move(m)
                h2 = p.decode_move(move)
                if h2 == nil then return nil end
                if h1[:piece] == h2[:piece] && h1[:r] == h2[:r] && h1[:c] == h2[:c]
                    return p
                end 
            end
        end
        return nil
    end

    def move_piece_on_board(move,piece)
        return 1
    end

    def white_king_in_checkmate?(checking_piece)
        

    end

    def black_king_in_checkmate?(checking_piece)

    end

    def white_king_in_check?
        white_king = self.white_pieces.find { |k| k.instance_of?(King) }
        if white_king == nil then raise "Error 404: white king not found" end
        self.black_pieces.each do | black_piece |
            black_piece_moves = black_piece.moves
            black_piece_moves.each do | m |
                h = black_piece.decode_move(m)
                if h[:r] == white_king.row && h[:c] == white_king.col then return true end
            end
        end
        false
    end
    def black_king_in_check?
        black_king = self.black_pieces.find { |k| k.instance_of?(King) }
        if black_king == nil then raise "Error 404: black king not found" end
        self.white_pieces.each do | white_piece |
            white_piece_moves = white_piece.moves
            white_piece_moves.each do |m|
                h = white_piece.decode_move(m)
                if h[:r] == black_king.row && h[:c] == black_king.col then return true end
            end
        end
        false
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