require_relative './Rook.rb'
require_relative './Queen.rb'
require_relative './Piece.rb'

board = Array.new(8) { Array.new(8) }
q = Queen.new('Q','W',0,0,board)

puts q.moves.inspect
