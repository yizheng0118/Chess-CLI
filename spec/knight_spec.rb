require_relative './spec_helper.rb'
require_relative '../lib/pieces/Knight.rb'
require_relative '../lib/pieces/King.rb'
require_relative '../lib/pieces/Rook.rb'
require_relative '../lib/pieces/Queen.rb'

RSpec.describe Knight do
    let(:board) { Array.new(8) { Array.new(8) } }
    describe '#moves' do
        context 'W Knight on e4' do
            subject(:knight) { described_class.new('N','W',3,4,board) }
            before do
                @wk = King.new('K','W',0,0,board)
            end
            it 'Nc5, Nd6, Nf6, Ng5, Ng3, Nf2, Nd2, Nc3' do
                expect(knight.moves).to match_array(['Nc5','Nd6','Nf6','Ng5','Ng3','Nf2','Nd2','Nc3'])
            end
            context 'B King on e8' do
                before do
                    board[7][4] = double(side:'B',name:'K')
                end
                it 'can check on d6 and f6' do
                    expect(knight.moves).to include('Nd6+','Nf6+')
                end
                context 'B pawn on d6 and f6' do
                    before do
                        board[5][3] = double(side:'B',name:'P')
                        board[5][5] = double(side:'B',name:'P')
                    end
                    it 'can take on d6 and f6 with check' do
                        expect(knight.moves).to include('Nxd6+','Nxf6+')
                    end
                end
            end
        end
        context 'W Knight on b1' do 
            subject(:knight) { described_class.new('N','W',0,1,board) }
            it 'can only move to a3 c3 d2' do
                wk = King.new('K','W',0,7,board)
                expect(knight.moves).to match_array(['Na3','Nc3','Nd2'])
            end
        end
    end

    describe '#moves_that_capture_own_pieces' do 
        context 'W Knight on e4 with 8 own pawns to capture' do
            subject(:knight) { described_class.new('N','W',3,4,board)}
            it 'can capture them' do
                [-2,-1,1,2].each do |dr|
                    dc1 = 3 - dr.abs
                    dc2 = -dc1
                    r = 3+dr
                    c1 = 4+dc1
                    c2 = 4+dc2
                    board[r][c1] = double(side:'W')
                    board[r][c2] = double(side:'W')
                end
                expect(knight.moves_that_capture_own_pieces).to match_array(['Nxd6','Nxf6','Nxc5','Nxg5','Nxc3','Nxg3','Nxd2','Nxf2'])
            end
        end
    end

    describe '#pinned to king' do
        context 'pinned from above - WK on e1, WN e2, BR on e8' do
            before do
                @wk = King.new('K','W',0,4,board)
                @wn = Knight.new('N','W',1,4,board)
            end
            it 'can move without the rook there' do
                expect(@wn.moves).to match_array(['Nc1','Ng1','Nc3','Ng3','Nd4','Nf4'])
            end
            it 'wn no moves with the rook' do
                @br = Rook.new('R','B',7,4,board)
                expect(@wn.moves).to match_array([])
            end
        end
        context 'pinned from below - WK on e8, WN e2, BQ on e1' do
            before do
                @wk = King.new('K','W',7,4,board)
                @wn = Knight.new('N','W',1,4,board)
                @br = Queen.new('R','B',0,4,board)
            end
            it 'wn no moves' do
                expect(@wn.moves).to match_array([])
            end
        end
        context 'pinned from the left - WK on h8, WN f8, BQ d8' do
            before do
                @wk = King.new('K','W',7,7,board)
                @wn = Knight.new('N','W',7,5,board)
                @bq = Queen.new('Q','B',7,4,board)
            end
            it 'wn no moves' do 
                expect(@wn.moves).to match_array([])
            end
        end
        context 'pinned from the right - WK on e4, WN f4, BQ g4' do
            before do
                @wk = King.new('K','W',3,4,board)
                @wn = Knight.new('N','W',3,5,board)
                @bq = Queen.new('Q','B',3,6,board)
            end
            it 'wn no moves' do 
                expect(@wn.moves).to match_array([])
            end
        end

        context 'pinned from top-right - WK on e4, WN f5, BQ h7' do
            before do
                @wk = King.new('K','W',3,4,board)
                @wn = Knight.new('N','W',4,5,board)
            end
            it 'can move before BQ is placed' do 
                expect(@wn.moves).to match_array(["Ng3", "Ne3", "Nh4", "Nd4", "Nh6", "Nd6", "Ng7", "Ne7"])
            end
            it 'no moves after BQ h7' do
                bq = Queen.new('Q','B',6,7,board)
                expect(@wn.moves).to match_array([])
            end
        end
        context 'pinned from top-left - WK on e4, WN d5, BQ a1' do
            before do
                @wk = King.new('K','W',3,4,board)
                @wn = Knight.new('N','W',4,3,board)
            end
            it 'can move before BQ is placed' do 
                expect(@wn.moves).to match_array(["Ne3", "Nc3", "Nf4", "Nb4", "Nf6", "Nb6", "Ne7", "Nc7"])
            end
            it 'no moves after BQ h7' do
                bq = Queen.new('Q','B',7,0,board)
                expect(@wn.moves).to match_array([])
            end
        end
        context 'pinned from bottom-right - WK on e4, WN f3, BQ h1' do
            before do
                @wk = King.new('K','W',3,4,board)
                @wn = Knight.new('N','W',2,5,board)
            end
            it 'can move before BQ is placed' do 
                expect(@wn.moves).to match_array(["Ng1", "Ne1", "Nh2", "Nd2", "Nh4", "Nd4", "Ng5", "Ne5"])
            end
            it 'no moves after BQ h7' do
                bq = Queen.new('Q','B',0,7,board)
                expect(@wn.moves).to match_array([])
            end
        end
        context 'pinned from bottom-left - WK on e4, WN d3, BQ b1' do
            before do
                @wk = King.new('K','W',3,4,board)
                @wn = Knight.new('N','W',2,3,board)
            end
            it 'can move before BQ is placed' do 
                expect(@wn.moves).to match_array(["Ne1", "Nc1", "Nf2", "Nb2", "Nf4", "Nb4", "Ne5", "Nc5"])
            end
            it 'no moves after BQ h7' do
                bq = Queen.new('Q','B',0,1,board)
                expect(@wn.moves).to match_array([])
            end
        end
    end
end