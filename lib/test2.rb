require_relative './ChessBoard.rb'

chess_game = ChessBoard.new
FEN = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR'
#chess_game.import_game(FEN)
chess_game.new_game
puts chess_game
