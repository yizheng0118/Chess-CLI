require_relative './spec_helper.rb'
require_relative '../lib/ChessBoard.rb'

RSpec.describe ChessBoard do

    describe 'Scholar\'s Mate' do 
        subject(:b) { described_class.new() }
        before do
            b.new_game
        end
        context 'e4 e5 Qh5' do
            it 'black can\'t play f6' do
                b.player_make_move('e4')
                b.player_make_move('e5')
                b.player_make_move('Qh5')
                b.black_pieces.each do |p|
                    p.moves.each { |m| puts m }
                end

                b.player_make_move('f6')
                puts b
                b.black_pieces.each do |p|
                    p.moves.each { |m| puts m }
                end
            end

        end
    end

end