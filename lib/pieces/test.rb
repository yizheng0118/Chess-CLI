require_relative './Rook.rb'
require_relative './Queen.rb'
require_relative './Piece.rb'
require_relative '../ChessBoard.rb'

b = ChessBoard.new
b.new_game
puts b

while true
    b.player_make_move
    puts b
end

