require_relative './spec_helper.rb'
require_relative '../lib/pieces/Bishop.rb'
require_relative '../lib/pieces/King.rb'
require_relative '../lib/pieces/Rook.rb'
require_relative '../lib/pieces/Queen.rb'

RSpec.describe Bishop do
    let(:board) { Array.new(8) {Array.new(8) } }
    describe '#moves' do
        before do
            King.new('K','W',0,0,board)
        end
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

    describe '#moves_that_capture_own_pieces' do
        context 'W bishop of e4' do
            subject(:bishop) { described_class.new('B','W',3,4,board)}
            context 'surrounded by white pawns' do
                it 'can capture them' do
                    board[2][3] = double(side:'W')
                    board[4][3] = double(side:'W')
                    board[4][5] = double(side:'W')
                    board[2][5] = double(side:'W')
                    expect(bishop.moves_that_capture_own_pieces).to match_array(['Bxd5','Bxf5','Bxd3','Bxf3'])
                end
            end
            context 'surrounded by black pawns' do
                it 'can\'t capture them' do
                    board[2][3] = double(side:'B')
                    board[4][3] = double(side:'B')
                    board[4][5] = double(side:'B')
                    board[2][5] = double(side:'B')
                    expect(bishop.moves_that_capture_own_pieces).to match_array([])
                end
            end
            context 'surrounded by white pawns on edge of board' do
                it 'can capture them' do 
                    board[0][1] = double(side:'W')
                    board[0][7] = double(side:'W')
                    board[7][0] = double(side:'W')
                    board[6][7] = double(side:'W')
                    expect(bishop.moves_that_capture_own_pieces).to match_array(['Bxa8','Bxb1','Bxh1','Bxh7'])
                end
            end
            context 'surrounded by black pawns on edge of board' do
                it 'can\'t capture them' do 
                    board[0][1] = double(side:'B')
                    board[0][7] = double(side:'B')
                    board[7][0] = double(side:'B')
                    board[6][7] = double(side:'B')
                    expect(bishop.moves_that_capture_own_pieces).to match_array([])
                end
            end

        end
    end

    describe 'pinned to king' do 
        context 'wk on e1, wb on e2, br on e8' do
            before do
                King.new('K','W',0,4,board)
                @wb = Bishop.new('B','W',1,4,board)
                Rook.new('R','B',7,4,board)
            end
            it 'white bishop cannot move' do
                expect(@wb.moves).to match_array([])
            end
            it 'can move if pin is blocked' do 
                Bishop.new('B','B',6,4,board)
                expect(@wb.moves).not_to match_array([])
            end
        end
        context 'wk on e1, wb on f2, bq on h4' do 
            before do
                King.new('K','W',0,4,board)
                @wb = Bishop.new('B','W',1,5,board)
                Queen.new('Q','B',3,7,board)
            end
            it 'bishop can only move along the pinned diagonal' do
                expect(@wb.moves).to match_array(['Bg3','Bxh4']) 
            end
        end
    end

end