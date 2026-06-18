require_relative './spec_helper.rb'
require_relative '../lib/pieces/King.rb'

RSpec.describe King do
    let(:board) { Array.new(8) { Array.new(8) } }
    describe '#moves' do
        context 'King on e4' do
            subject(:king) { described_class.new('K','W',3,4,board) }
            it 'can move one square in every direction' do
                moves = ['Ke5','Ke3','Kd4','Kf4','Kd5','Kd3','Kf5','Kf3']
                expect(king.moves).to match_array(moves)
            end
        end
        context 'King on a1' do
            subject(:king) { described_class.new('K','W',0,0,board) }
            it 'can only move to a2, b1, b2' do
                moves = ['Ka2','Kb1','Kb2']
                expect(king.moves).to match_array(moves)
            end
        end
        context 'King on e1' do
            subject(:king) { described_class.new('K','W',0,4,board)}
            it 'can move to d1, d2, e2, f2, f1' do
                moves = ['Kd1','Kd2','Ke2','Kf2','Kf1']
                expect(king.moves).to match_array(moves)
            end
            context 'fully surrounded by own pieces' do
                it 'cannot move' do
                    board[0][3] = double(side:'W')
                    board[0][5] = double(side:'W')
                    board[1][3] = double(side:'W')
                    board[1][4] = double(side:'W')
                    board[1][5] = double(side:'W')
                    expect(king.moves).to match_array([])
                end
            end
            context 'fully surrounded by enemy pieces' do 
                moves = ['Kxd1','Kxd2','Kxe2','Kxf2','Kxf1']
                it 'can capture all of them' do
                    board[0][3] = double(side:'B')
                    board[0][5] = double(side:'B')
                    board[1][3] = double(side:'B')
                    board[1][4] = double(side:'B')
                    board[1][5] = double(side:'B')
                    expect(king.moves).to match_array(moves)
                end

            end
        end
    end
end