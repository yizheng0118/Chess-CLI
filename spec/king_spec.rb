require_relative './spec_helper.rb'
require_relative '../lib/pieces/King.rb'
require_relative '../lib/pieces/Pawn.rb'
require_relative '../lib/pieces/Knight.rb'
require_relative '../lib/pieces/Rook.rb'

RSpec.describe King do
    let(:board) { Array.new(8) { Array.new(8) } }
    describe '#moves' do
        context 'W King on e4' do
            subject(:king) { described_class.new('K','W',3,4,board) }
            it 'can move one square in every direction' do
                moves = ['Ke5','Ke3','Kd4','Kf4','Kd5','Kd3','Kf5','Kf3']
                expect(king.moves).to match_array(moves)
            end
            context 'B pawn on e5 and B King on e6' do
                before do
                    @bk = King.new('K','B',5,4,board)
                    bp = Pawn.new('P','B',4,4,board)
                end
                it 'black king protects e5' do
                    expect(@bk.moves_that_capture_own_pieces).to match_array(['Kxe5'])
                end
                it 'white king cannot take e5 nor move up to the 5th rank' do
                    expect(king.moves).to match_array(['Ke3','Kd3','Kf3'])
                end
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
            context 'fully surrounded by own pieces,but can capture own pieces' do
                it 'cannot move' do
                    board[0][3] = double(side:'W')
                    board[0][5] = double(side:'W')
                    board[1][3] = double(side:'W')
                    board[1][4] = double(side:'W')
                    board[1][5] = double(side:'W')
                    expect(king.moves).to match_array([])
                    expect(king.moves_that_capture_own_pieces).to match_array(['Kxd1','Kxd2','Kxe2','Kxf2','Kxf1'])
                end
            end
            context 'fully surrounded by enemy pieces' do 
                moves = ['Kxd2','Kxe2','Kxf2']
                it 'can only capture the undefended pawns' do
                    board[0][3] = Pawn.new('p','B',0,3,board)
                    board[0][5] = Pawn.new('p','B',0,5,board)
                    board[1][3] = Pawn.new('p','B',1,3,board)
                    board[1][4] = Pawn.new('p','B',1,4,board)
                    board[1][5] = Pawn.new('p','B',1,5,board)
                    expect(king.moves).to match_array(moves)
                end
            end
        end
    end
    describe 'pieces pinned to the king' do
        context 'W king on e1, W knight on e2, B rook on e8' do
            subject!(:king) { described_class.new('K','W',0,4,board) }
            before do
                @wn = Knight.new('N','W',1,4,board)
                @br = Rook.new('R','B',7,4,board)
            end
            it 'black rook can take the knight' do
                expect(@br.moves).to include('Rxe2+')
            end
            it 'white knight detects it is pinned' do
                expect(@wn.detect_pinned).to include(pinned:true)
            end
            it 'white knight cannot move' do
                expect(@wn.moves).to match_array([])
            end
        end
    end
end