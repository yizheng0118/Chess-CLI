require_relative './spec_helper.rb'
require_relative '../lib/pieces/Bishop.rb'

RSpec.describe Bishop do

    describe '#moves' do
        let(:board) { Array.new(8) {Array.new(8) } }
        context 'W bishop on e4' do
            subject(:bishop) { described_class.new('B','W',3,4,board)}
            it 'can move up to the left' do
                expect(bishop.moves).to include("Ba8","Bb7","Bc6","Bd5")
            end
            it 'can move up to the right ' do
                expect(bishop.moves).to include('Bf5','Bg6','Bh7')
            end
            it 'can move down to the left' do
                expect(bishop.moves).to include('Bd3','Bc2','Bb1')
            end
            it 'can move down to the right' do
                expect(bishop.moves).to include('Bf3','Bg2','Bh1')
            end
            context 'B king on e8' do 
                before do 
                    board[7][4] = described_class.new('K','B',7,4,board)
                end
                it 'can check king on c6 and g6' do
                    expect(bishop.moves).to include('Bc6+','Bg6+')
                end
                context 'B pawn on g6' do
                    before do
                        board[5][6] = described_class.new('P','B',5,6,board)
                    end
                    it 'can take on g6 with check' do
                        expect(bishop.moves).to include('Bxg6+')
                    end
                end
            end
        end
    end

end