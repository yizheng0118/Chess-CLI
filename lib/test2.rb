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


wq = Queen.new('Q','W',6,6,board)   #WQ on g7
wp = Pawn.new('P','W',5,5,board)    #WP on f6

br = Rook.new('R','B',6,0,board)    #BR on a7

puts "#{bk.moves.inspect}"
puts "#{bk.deteck_checkmate}"
puts "#{br.moves.inspect}"


