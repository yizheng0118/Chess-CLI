require_relative '../lib/pieces/Rook.rb'
require_relative './spec_helper.rb'

RSpec.describe Rook do
    let(:board) { Array.new(8) { Array.new(8) } }
    describe '#move' do
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

end
