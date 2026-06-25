require_relative './ChessBoard.rb'
require_relative './pieces/Pawn.rb'
require_relative './pieces/King.rb'
require_relative './pieces/Bishop.rb'
require_relative './pieces/Knight.rb'
require_relative './pieces/Rook.rb'
#require 'pry-byebug'

board = Array.new(8) {Array.new(8)}
wk = King.new('K','W',0,4,board)    #WK on e1
bk = King.new('K','B',7,7,board)    #BK on h8 
#bn = Knight.new('N','B',1,2,board)
br = Rook.new('R','B',7,4,board)
wr = Rook.new('R','W',2,7,board)

puts "#{wk.moves.inspect}"
puts "#{wr.moves.inspect}"
puts "#{br.moves.inspect}"


