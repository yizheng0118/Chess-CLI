require_relative './ChessBoard.rb'
require_relative './pieces/Pawn.rb'
require_relative './pieces/King.rb'
require_relative './pieces/Bishop.rb'
require_relative './pieces/Knight.rb'
require_relative './pieces/Rook.rb'
#require 'pry-byebug'

board = Array.new(8) {Array.new(8)}
wk = King.new('K','W',0,4,board)    #WK on e1
wn = Knight.new('P','W',1,5,board)  #WK on f2
bb = Bishop.new('B','B',3,7,board)  #BB on h4

puts "WN: #{wn.moves}"
puts wn.detect_pinned[:squares_between].inspect


