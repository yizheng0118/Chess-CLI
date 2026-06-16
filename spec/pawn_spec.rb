require_relative '../lib/pieces/Pawn.rb'
require_relative './spec_helper.rb'

RSpec.describe Pawn do

    describe 'basic moves' do
        describe 'white pawn on e2 with black pawns on d3 and f3' do
            let(:board) { Array.new(8) { Array.new(8) } }
            subject(:pawn) { described_class.new('pawn','W',1,4,board) }
            before do
                board[2][3] = described_class.new('pawn','B',2,3,board)
                board[2][5] = described_class.new('pawn','B',2,5,board)
            end
            it 'possible moves = e3, e4, exd3, exf3' do
                expect(pawn.moves).to match_array(['e3','e4','exd3','exf3'])
            end
        end
        describe 'black pawn on e7 with white pawns on d6 and f6' do
            let(:board) { Array.new(8) { Array.new(8) } }
            subject(:pawn) { described_class.new('pawn','B',6,4,board) }
            before do
                board[5][3] = described_class.new('pawn','W',5,3,board)
                board[5][5] = described_class.new('pawn','W',5,5,board)
            end
            it 'possible moves = e6, e5, exd6, exf6' do
                expect(pawn.moves).to match_array(['e6','e5','exd6','exf6'])
            end
        end
    end
    
    describe 'basic checks' do
        let(:board) { Array.new(8) { Array.new(8) } }
        describe 'white pawn on e2 with black king on d4' do
            subject(:pawn) { described_class.new('P','W',1,4,board)}
            it 'possible moves = e3+, e4' do
                board[3][3] = described_class.new('K','B',3,3,board)
                expect(pawn.moves).to match_array(["e3+",'e4'])
            end
        end
        describe 'white pawn on e2 with black king on d5' do
            subject(:pawn) { described_class.new('P','W',1,4,board)}
            it 'possible moves = e3, e4+' do
                board[4][3] = described_class.new('K','B',4,3,board)
                expect(pawn.moves).to match_array(['e3','e4+'])
            end
        end
        describe 'black pawn on e7 with white king on d5' do
            subject(:pawn) { described_class.new('P','B',6,4,board)}
            it 'e6+, e5' do
                board[4][3] = described_class.new('K','W',4,3,board)
                expect(pawn.moves).to match_array(['e6+','e5'])
            end
        end
        describe 'black pawn on e7 with white king on d4' do
            subject(:pawn) { described_class.new('P','B',6,4,board)}
            it 'e6, e5+' do
                board[3][3] = described_class.new('K','W',3,3,board)
                expect(pawn.moves).to match_array(["e5+",'e6'])
            end
        end
    end

    describe 'captures with check' do
        let(:board) { Array.new(8) { Array.new(8) } }
        describe 'W pawn on e4, B pawn on f5, B king on e6' do
            subject(:pawn) { described_class.new('P','W',3,4,board) }
            it 'e5, exf5+' do
                board[4][5] = described_class.new('P','B',4,5,board)
                board[5][4] = described_class.new('K','B',5,4,board)
                expect(pawn.moves).to match_array(['e5','exf5+'])
            end
        end
        describe 'B pawn on d5, W pawn on e4, W king on d3' do
            subject(:pawn) { described_class.new('P','B',4,3,board) }
            it 'd4, dxe4+' do
                board[3][4] = described_class.new('P','W',3,4,board)
                board[2][3] = described_class.new('K','W',2,3,board)
                expect(pawn.moves).to match_array(['d4','dxe4+'])
            end
        end
    end


end