require_relative '../lib/pieces/Pawn.rb'
require_relative './spec_helper.rb'

RSpec.describe Pawn do

    describe '#moves' do
        context 'white pawn e2 with empty board' do
            let(:board) { Array.new(8) { Array.new(8) } }
            subject(:pawn) { described_class.new('pawn','W',1,4, board) }

            it 'can move to e3' do
                expect(pawn.moves).to include("e3")
            end

            it 'can move to e4' do
                expect(pawn.moves).to include("e4")
            end
        end
    end

    describe 'white pawn on e4 with black pawns on d5 and d6' do
        let(:board) { Array.new(8) { Array.new(8) } }
        subject(:pawn) { described_class.new('pawn','W',3,4,board) }
        before do
            board[4][3] = described_class.new('pawn','B',4,3,board)
            board[4][5] = described_class.new('pawn','B',4,5,board)
        end
        it 'can move to e5' do
            puts pawn.moves.inspect
            expect(pawn.moves).to include("e5")
        end
        it 'can capture on d5' do
            expect(pawn.moves).to include("exd5")
        end

        it 'can capture on f5' do
            expect(pawn.moves).to include("exf5")
        end
        
    end

end