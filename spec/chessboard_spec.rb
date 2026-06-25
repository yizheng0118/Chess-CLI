require_relative './spec_helper.rb'
require_relative '../lib/ChessBoard.rb'

RSpec.describe ChessBoard do
    subject(:b) { described_class.new() }
    describe 'Scholar\'s Mate' do 
        before do
            fen = "rnb1kb1r/ppppqppp/5n2/4p2Q/2B1P4/8/PPPP1PPP/RNB1K1NR"
            b.import_game(fen)
            allow(b).to receive(:gets).and_return("Qxf7")
        end
        it 'prints the correct board state' do
            s = "rnb.Kb.r\nppppqppp\n.....n..\n....p..Q\n..B.P...\n........\nPPPP.PPP\nRNB.K.NR\n"
            expect{ puts b }.to output(s).to_stdout
        end
        it 'Qxf7 is not checkmate' do
           expect{b.player_move_loop}.not_to output("checkmate\n").to_stdout
           puts b
        end
    end
end