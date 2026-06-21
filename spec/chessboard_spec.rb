require_relative './spec_helper.rb'
require_relative '../lib/ChessBoard.rb'

RSpec.describe ChessBoard do
    subject(:b) { described_class.new() }
    before do
        b.new_game
    end
    describe 'Scholar\'s Mate' do 
        context 'e4 e5 Qh5' do
            before do   
                b.player_make_move('e4')
                b.player_make_move('e5')
                b.player_make_move('Qh5')
            end
            it 'black can\'t play f6' do
                expect { b.player_make_move('f6') }.to output("invalid king move\n").to_stdout
            end
            it 'board state stays the same after trying to play f6' do
                expect { b.player_make_move('f6') }.not_to change{ b.board }
            end
        end
    end

    describe 'Restoring captured pieces after illegal move attempt' do
        context 'e4 d5 exd5 e6 Qe2' do
            before do
                b.player_make_move('e4')
                b.player_make_move('d5')
                b.player_make_move('exd5')
                b.player_make_move('e6')
                b.player_make_move('Qe2')
            end
            it 'black can\'t play exd5' do
                #puts b
                expect{ b.player_make_move('exd5')}.to output("invalid king move\n").to_stdout
                #puts b
            end
            it 'board state doesn\'t change from attempt' do
                expect { b.player_make_move('exd5')}.not_to change(b,:board)
            end
        end
    end

end