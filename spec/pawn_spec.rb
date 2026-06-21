require_relative '../lib/pieces/Pawn.rb'
require_relative './spec_helper.rb'

RSpec.describe Pawn do

    describe 'basic moves' do
        describe 'white pawn on e2 with black pawns on d3 and f3' do
            let(:board) { Array.new(8) { Array.new(8) } }
            subject(:pawn) { described_class.new('pawn','W',1,4,board) }
            let(:black_pawn) { double('P',side:'B') }
            before do
                board[2][3] = black_pawn
                board[2][5] = black_pawn
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
                board[3][3] = black_king
                expect(pawn.moves).to match_array(["e3+",'e4'])
            end
        end
        describe 'white pawn on e2 with black king on d5' do
            subject(:pawn) { described_class.new('P','W',1,4,board)}
            it 'possible moves = e3, e4+' do
                black_king = double('K', side:'B',name:'K')
                board[4][3] = black_king
                expect(pawn.moves).to match_array(['e3','e4+'])
            end
        end
        describe 'black pawn on e7 with white king on d5' do
            subject(:pawn) { described_class.new('P','B',6,4,board)}
            it 'e6+, e5' do
                board[4][3] = double('K',side:'W',name:'K')
                expect(pawn.moves).to match_array(['e6+','e5'])
            end
        end
        describe 'black pawn on e7 with white king on d4' do
            subject(:pawn) { described_class.new('P','B',6,4,board)}
            it 'e6, e5+' do
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
                board[5][4] = double(side:'B',name:'K')
                expect(pawn.moves).to match_array(['e5','exf5+'])
            end
        end
        describe 'B pawn on d5, W pawn on e4, W king on d3' do
            subject(:pawn) { described_class.new('P','B',4,3,board) }
            it 'd4, dxe4+' do
                board[3][4] = double(side:'W',name:'P')
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
                board[4][3] = double(side:'B',name:'P')
                expect(pawn.moves).to match(['e5','exd5'])
                expect(pawn.moves_that_capture_own_pieces).to match_array([])
            end
            it 'B pawn can capture normally, but not own pieces' do
                pawn = described_class.new('P','B',4,3,board)
                board[3][4] = double(side:'W',name:'P')
                expect(pawn.moves).to match(['d4','dxe4'])
                expect(pawn.moves_that_capture_own_pieces).to match_array([])
            end
        end
    end 

end