require_relative '../lib/pieces/Pawn.rb'
require_relative './spec_helper.rb'
require_relative '../lib/pieces/King.rb'
require_relative '../lib/pieces/Rook.rb'
require_relative '../lib/pieces/Bishop.rb'
require_relative '../lib/pieces/Queen.rb'

RSpec.describe Pawn do
    let(:board) { Array.new(8) {Array.new(8)}}
    describe 'basic moves' do
        describe 'white pawn on e2 with black pawns on d3 and f3' do
            let(:board) { Array.new(8) { Array.new(8) } }
            subject(:pawn) { described_class.new('pawn','W',1,4,board) }
            let(:black_pawn) { double('P',side:'B') }
            before do
                board[2][3] = black_pawn
                board[2][5] = black_pawn
                wk = King.new('K','W',0,0,board)
            end
            it 'possible moves = e3, e4, exd3, exf3' do
                expect(pawn.moves).to match_array(['e3','e4','exd3','exf3'])
            end
        end
        describe 'black pawn on e7 with white pawns on d6 and f6' do
            let(:board) { Array.new(8) { Array.new(8) } }
            subject(:pawn) { described_class.new('pawn','B',6,4,board) }
            before do
                white_pawn = double('P', side:'W')
                board[5][3] = white_pawn
                board[5][5] = white_pawn
                bk = King.new('K','B',0,0,board)
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
                black_king = double('K', side:'B', name:'K')
                wk = King.new('K','W',0,0,board)
                board[3][3] = black_king
                expect(pawn.moves).to match_array(["e3+",'e4'])
            end
        end
        describe 'white pawn on e2 with black king on d5' do
            subject(:pawn) { described_class.new('P','W',1,4,board)}
            it 'possible moves = e3, e4+' do
                black_king = double('K', side:'B',name:'K')
                wk = King.new('K','W',0,0,board)
                board[4][3] = black_king
                expect(pawn.moves).to match_array(['e3','e4+'])
            end
        end
        describe 'black pawn on e7 with white king on d5' do
            subject(:pawn) { described_class.new('P','B',6,4,board)}
            it 'e6+, e5' do
                board[4][3] = double('K',side:'W',name:'K')
                bk = King.new('K','B',0,0,board)
                expect(pawn.moves).to match_array(['e6+','e5'])
            end
        end
        describe 'black pawn on e7 with white king on d4' do
            subject(:pawn) { described_class.new('P','B',6,4,board)}
            it 'e6, e5+' do
                bk = King.new('K','B',0,0,board)
                board[3][3] = double(side:'W',name:'K')
                expect(pawn.moves).to match_array(["e5+",'e6'])
            end
        end
    end

    describe 'captures with check' do
        let(:board) { Array.new(8) { Array.new(8) } }
        describe 'W pawn on e4, B pawn on f5, B king on e6' do
            subject(:pawn) { described_class.new('P','W',3,4,board) }
            it 'e5, exf5+' do
                board[4][5] = double(side:'B',name:'P')
                wk = King.new('K','W',0,0,board)
                board[5][4] = double(side:'B',name:'K')
                expect(pawn.moves).to match_array(['e5','exf5+'])
            end
        end
        describe 'B pawn on d5, W pawn on e4, W king on d3' do
            subject(:pawn) { described_class.new('P','B',4,3,board) }
            it 'd4, dxe4+' do
                board[3][4] = double(side:'W',name:'P')
                bk = King.new('K','B',0,0,board)
                board[2][3] = double(side:'W',name:'K')
                expect(pawn.moves).to match_array(['d4','dxe4+'])
            end
        end
    end

    describe 'moves_that_capture_own_pieces' do
        let(:board) { Array.new(8) { Array.new(8) } }
        describe 'W pawn on e3, d4, f4' do
            subject(:pawn) { described_class.new('P','W',2,4,board)}
            it 'exd4, exf4' do
                board[3][3] = double(side:'W',name:'P')
                board[3][5] = double(side:'W',name:'P')
                expect(pawn.moves_that_capture_own_pieces).to match_array(['exd4','exf4'])
            end
        end
        describe 'B pawn on e6, d5, f5' do
            subject(:pawn) { described_class.new('P','B',5,4,board)}
            it 'exd5, exf5' do 
                board[4][3] = double(side:'B',name:'P')
                board[4][5] = double(side:'B',name:'P')
                expect(pawn.moves_that_capture_own_pieces).to match_array(['exd5','exf5'])
            end
        end
        describe 'W pawn on a2, b3, g3,h2' do
           # let(:pawn) {described_class.new('P','W',1,0,board)}
            it 'axb3' do 
                pawn = described_class.new('P','W',1,0,board)
                board[2][1] = double(side:'W',name:'P')
                expect(pawn.moves_that_capture_own_pieces).to match_array(['axb3'])
            end
            it 'hxg3' do 
                pawn = described_class.new('P','W',1,7,board)
                board[2][6] = double(side:'W',name:'P')
                expect(pawn.moves_that_capture_own_pieces).to match_array(['hxg3'])
            end
        end
        describe 'B pawn on a7,b6  g6,h7' do
            it 'axb6' do 
                pawn = described_class.new('P','B',6,0,board)
                board[5][1] = double(side:'B',name:'P')
                expect(pawn.moves_that_capture_own_pieces).to match_array(['axb6'])
            end
            it 'hxg6' do
                pawn = described_class.new('P','B',6,7,board)
                board[5][6] = double(side:'B',name:'P')
                expect(pawn.moves_that_capture_own_pieces).to match_array(['hxg6'])
            end
        end
        describe 'W pawn on e4, black pawn on d5' do
            it 'W pawn can capture normally, but not own pieces' do
                pawn = described_class.new('P','W',3,4,board)
                King.new('K','W',0,0,board)
                board[4][3] = double(side:'B',name:'P')
                expect(pawn.moves).to match(['e5','exd5'])
                expect(pawn.moves_that_capture_own_pieces).to match_array([])
            end
            it 'B pawn can capture normally, but not own pieces' do
                pawn = described_class.new('P','B',4,3,board)
                King.new('K','B',0,0,board)
                board[3][4] = double(side:'W',name:'P')
                expect(pawn.moves).to match(['d4','dxe4'])
                expect(pawn.moves_that_capture_own_pieces).to match_array([])
            end
        end
    end 
    describe 'pinned to king' do
        context 'pinned from above' do
            context 'wk on e1, wp on e2, bp on d3, bq on e8' do
                before do 
                    wk = King.new('K','W',0,4,board)
                    @wp = Pawn.new('P','W',1,4,board)
                    bp = Pawn.new('P','B',2,3,board)
                    bq = Queen.new('Q','B',7,4,board)
                end
                it 'pawn cannot capture diagonally but can move forward' do 
                    expect(@wp.moves).to match_array(['e3','e4'])
                end
                context 'add another pawn in front of bq to block pin' do
                    it 'white pawn can move normally' do
                        bp2 = Pawn.new('P','B',6,4,board)
                        expect(@wp.moves).to match_array(['e3','e4','exd3'])
                    end
                end
            end
        end
        context 'pinned from below' do 
            context 'wk on e8, wp on e7, bp on f8, bq on e1' do
                before do
                    wk = King.new('K','W',7,4,board)
                    @wp = Pawn.new('P','W',6,4,board)
                    bp = Pawn.new('P','B',7,5,board)
                    bq = Queen.new('Q','B',0,4,board)
                end
                it 'white pawn no moves' do
                    expect(@wp.moves).to match_array([])
                end
                context 'extra piece to block the pin' do
                    it 'white pawn can move normally' do
                        Pawn.new('P','B',1,4,board)
                        expect(@wp.moves).to match_array(['exf8'])
                    end
                end
            end
        end
        context 'pinned from the right' do
            context 'wk on e4, wp on f4, bp on e5, br on h8' do
                before do 
                    King.new('K','W',3,4,board)
                    @wp = Pawn.new('P','W',3,5,board)
                    Pawn.new('P','B',4,4,board)
                    Rook.new('R','B',3,7,board)
                end
                it 'white pawn cannot move' do
                    expect(@wp.moves).to match_array([])
                end
                it 'pin blocked, white pawn can move normally' do 
                    Pawn.new('P','W',3,6,board)
                    expect(@wp.moves).to match_array(['f5','fxe5'])
                end
            end
        end
        context 'pinned diagonally' do 
            context 'wk on e1, wp on f2, bq on h4' do
                before do
                    King.new('K','W',0,4,board)
                    @wp = Pawn.new('P','W',1,5,board)
                    @bq = Queen.new('Q','B',3,7,board)
                end
                it 'white pawn cannot move' do 
                    expect(@wp.moves).to match_array([])
                end
                it 'can capture if bq moves closer to g3' do
                    @bq.moveTo(2,6)
                    expect(@wp.moves).to match_array(['fxg3'])
                end
            end
        end
    end

end