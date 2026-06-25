require_relative '../lib/pieces/Rook.rb'
require_relative './spec_helper.rb'
require_relative '../lib/pieces/King.rb'
require_relative '../lib/pieces/Queen.rb'

RSpec.describe Rook do
    let(:board) { Array.new(8) { Array.new(8) } }
    describe '#moves' do
        before do 
            white_king = King.new('K','W',1,6,board)
        end
        context 'rook on a1' do 
            subject(:rook) { described_class.new('R','W',0,0,board) }
            it 'can move up and right' do
                moves = []
                (2..8).each { |n| moves.append("Ra#{n.to_s}") }
                "bcdefgh".chars.each { |x| moves.append("R#{x}1")} 
                expect(rook.moves).to match_array(moves)
            end
        end
        context 'rook on e4' do
            subject(:rook) { described_class.new('R','W',3,4,board) }
            it 'can move in all directions' do
                moves = []
                (1..8).each { |n| moves.append("Re#{n.to_s}") }
                "abcdefgh".each_char { |x| moves.append("R#{x}4")}
                moves.delete("Re4")
                expect(rook.moves).to match_array(moves)
            end
        end
        context 'W rook on e4 surrounded by 4 B rooks' do
            subject(:rook) { described_class.new('R','W',3,4,board)}
            it 'Rxe5, Rxe3, Rxd4, Rxf4' do
                board[3][3] = described_class.new('R','B',3,3,board)
                board[3][5] = described_class.new('R','B',3,5,board)
                board[2][4] = described_class.new('R','B',2,4,board)
                board[4][4] = described_class.new('R','B',4,4,board)
                expect(rook.moves).to match_array(['Rxe5','Rxe3','Rxd4','Rxf4'])
            end
        end
        context 'W rook on e4 surrounded by 4 B rooks and B king on f5' do
            subject(:rook) { described_class.new('R','W',3,4,board)}
            it 'Rxe5+, Rxe3, Rxd4, Rxf4+' do
                board[3][3] = described_class.new('R','B',3,3,board)
                board[3][5] = described_class.new('R','B',3,5,board)
                board[2][4] = described_class.new('R','B',2,4,board)
                board[4][4] = described_class.new('R','B',4,4,board)
                board[4][5] = described_class.new('K','B',4,5,board)
                expect(rook.moves).to match_array(['Rxe5+','Rxe3','Rxd4','Rxf4+'])
            end
        end
    end
    describe '#moves_that_capture_own_pieces' do
        context 'W rook on e4 surrounded by 4 W pawns' do
            subject(:rook) { described_class.new('R','W',3,4,board)}
            it 'Rxe5, Rxe3, Rxd4, Rxf4' do
                board[3][3] = described_class.new('P','W',3,3,board)
                board[3][5] = described_class.new('P','W',3,5,board)
                board[2][4] = described_class.new('P','W',2,4,board)
                board[4][4] = described_class.new('P','W',4,4,board)
                expect(rook.moves_that_capture_own_pieces).to match_array(['Rxe5','Rxe3','Rxd4','Rxf4'])
            end
        end
        context 'W rook on e4 surrounded by 4 W pawns on edge of board' do
            subject(:rook) { described_class.new('R','W',3,4,board)}
            it 'Rxe8, Rxe1, Rxa4, Rxh4' do
                board[3][0] = described_class.new('P','W',3,0,board)
                board[3][7] = described_class.new('P','W',3,7,board)
                board[0][4] = described_class.new('P','W',0,4,board)
                board[7][4] = described_class.new('P','W',7,4,board)
                expect(rook.moves_that_capture_own_pieces).to match_array(['Rxe8','Rxe1','Rxa4','Rxh4'])
            end
        end
        context 'B rook on e4 surrounded by 4 B pawns' do
            subject(:rook) { described_class.new('R','B',3,4,board)}
            it 'Rxe5, Rxe3, Rxd4, Rxf4' do
                board[3][3] = described_class.new('P','B',3,3,board)
                board[3][5] = described_class.new('P','B',3,5,board)
                board[2][4] = described_class.new('P','B',2,4,board)
                board[4][4] = described_class.new('P','B',4,4,board)
                expect(rook.moves_that_capture_own_pieces).to match_array(['Rxe5','Rxe3','Rxd4','Rxf4'])
            end
        end
        context 'B rook on e4 surrounded by 4 B pawns on edge of board' do
            subject(:rook) { described_class.new('R','B',3,4,board)}
            it 'Rxe8, Rxe1, Rxa4, Rxh4' do
                board[3][0] = described_class.new('P','B',3,0,board)
                board[3][7] = described_class.new('P','B',3,7,board)
                board[0][4] = described_class.new('P','B',0,4,board)
                board[7][4] = described_class.new('P','B',7,4,board)
                expect(rook.moves_that_capture_own_pieces).to match_array(['Rxe8','Rxe1','Rxa4','Rxh4'])
            end
        end
    end
    describe 'pinned to King' do
        describe 'W K on e1, W R on e2, B R on e8' do
            it 'W R can\'t move horizontally, only vertically' do
                wk = King.new('K','W',0,4,board)
                wr = Rook.new('R','W',1,4,board)
                br = Rook.new('R','B',7,4,board)
                expect(wr.moves).to match_array(['Re3','Re4','Re5','Re6','Re7','Rxe8'])
            end
        end
        describe 'W K on e1, W R on d2, B Q on a5' do
            before do
                wk = King.new('K','W',0,4,board)
                @wr = Rook.new('R','W',1,3,board)
                bq = Queen.new('Q','B',4,0,board)
            end
            it 'W R can\'t move' do
                expect(@wr.moves).to match_array([])
            end
            context 'another rook in between on b4' do
                it 'e2 Rook an move normally' do
                    wr2 = Rook.new('R','W',2,2,board)
                    #p @wr.moves
                    expect(@wr.moves).not_to match_array([])
                end
            end

        end
    end
end
