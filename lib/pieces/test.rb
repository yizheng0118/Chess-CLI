require_relative './Rook.rb'

board = Array.new(8) { Array.new(8) }
rook = Rook.new('R','W',0,0,board)
board[0][0] = rook

puts rook.moves.inspect