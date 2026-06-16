require_relative '../lib/pieces/Pawn.rb'
require_relative './spec_helper.rb'

RSpec.describe Pawn do

    describe '#moves' do
        
        describe 'white pawn on e2 with black pawns on d3 and f3' do
            let(:board) { Array.new(8) { Array.new(8) } }
            subject(:pawn) { described_class.new('pawn','W',1,4,board) }
            before do
                board[2][3] = described_class.new('pawn','B',2,3,board)
                board[2][5] = described_class.new('pawn','B',2,5,board)
            end
            it 'can move to e3' do
                expect(pawn.moves).to include("e3")
            end
            it 'can move to e4' do 
                expect(pawn.moves).to include("e4")
            end
            it 'can capture on d3' do
                expect(pawn.moves).to include("exd3")
            end
            it 'can capture on f3' do
                expect(pawn.moves).to include("exf3")
            end
        end
        describe 'black pawn on e7 with white pawns on d6 and f6' do
            let(:board) { Array.new(8) { Array.new(8) } }
            subject(:pawn) { described_class.new('pawn','B',6,4,board) }
            before do
                board[5][3] = described_class.new('pawn','W',5,3,board)
                board[5][5] = described_class.new('pawn','W',5,5,board)
            end
            it 'can move to e5' do
                expect(pawn.moves).to include("e5")
            end
            it 'can move to e6' do 
                expect(pawn.moves).to include("e6")
            end
            it 'can capture on d6' do 
                expect(pawn.moves).to include("exd6")
            end
            it 'can capture on f6' do
                expect(pawn.moves).to include("exf6")
            end
        end


    end
end