require_relative './Rook.rb'
require_relative './Queen.rb'
require_relative './Piece.rb'
require_relative '../ChessBoard.rb'

b = ChessBoard.new
b.new_game
puts b
puts b.turn
if b.turn == 'W' 
    b.white_pieces.each do |p|
        puts p.moves.inspect
    end
elsif b.turn == 'B' 
    b.black_pieces.each do |p|
        puts p.moves.inspect
    end
end

while true
    b.player_make_move_user_input_wrapper
    puts b
    if b.turn == 'W' 
        b.white_pieces.each do |p|
            puts p.moves.inspect
        end
    elsif b.turn == 'B' 
        b.black_pieces.each do |p|
            puts p.moves.inspect
        end
    end
        puts b.turn
end

