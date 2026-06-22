require_relative './ChessBoard.rb'
require_relative './pieces/Pawn.rb'
require_relative './pieces/King.rb'
require_relative './pieces/Bishop.rb'

board = Array.new(8) {Array.new(8)}
wk = King.new('K','W',3,4,board) #WK on e4
bp = Pawn.new('P','B',4,4,board) #BP on e5
bk = King.new('K','B',5,4,board) #BK on e6

puts "white king moves = #{wk.moves.inspect}"
puts "bp moves = #{bp.moves.inspect}"


