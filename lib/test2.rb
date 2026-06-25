require_relative './ChessBoard.rb'
require_relative './pieces/Pawn.rb'
require_relative './pieces/King.rb'
require_relative './pieces/Bishop.rb'
require_relative './pieces/Knight.rb'
require_relative './pieces/Rook.rb'
#require 'pry-byebug'

chessboard = ChessBoard.new
fen = "rnb1kb1r/ppppqppp/5n2/4p2Q/2B1P4/8/PPPP1PPP/RNB1K1NR"
chessboard.import_game(fen)

chessboard.new_game
wk = chessboard.white_king
bk = chessboard.black_king

chessboard.player_move_loop



