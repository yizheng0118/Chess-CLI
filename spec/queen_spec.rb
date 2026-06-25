require_relative '../lib/pieces/Queen.rb'
require_relative './spec_helper.rb'
require_relative '../lib/pieces/King.rb'


RSpec.describe Queen do
    let(:board) { Array.new(8) { Array.new(8) } }
    describe '#move' do
        before do
            King.new('K','W',0,0,board)
        end
        context 'queen on e4' do
            subject(:queen) { described_class.new('Q','W',3,4,board)}
            it 'can move vertically along the e file' do
                moves = []
                [1,2,3,5,6,7,8].each { |n| moves.append("Qe#{n.to_s}")}
                expect(queen.moves).to include(*moves)
            end
            it 'can move horizontally along the 4th rank' do
                moves = []
                "abcdfgh".each_char { |c| moves.append("Q#{c}4")}
                expect(queen.moves).to include(*moves)
            end
            it 'can move diagonally /' do
                moves = ['Qb1','Qc2','Qd3','Qf5','Qg6','Qh7']
                expect(queen.moves).to include(*moves)
            end
            it 'can move diagonally \\' do
                moves = ['Qa8','Qb7','Qc6','Qd5','Qf3','Qg2','Qh1']
                expect(queen.moves).to include(*moves)
            end
            it 'makes no extra other moves' do
                moves = []
                [1,2,3,5,6,7,8].each { |n| moves.append("Qe#{n.to_s}")}
                "abcdfgh".each_char { |c| moves.append("Q#{c}4")}
                moves += ['Qb1','Qc2','Qd3','Qf5','Qg6','Qh7']
                moves += ['Qa8','Qb7','Qc6','Qd5','Qf3','Qg2','Qh1']
                expect(queen.moves).to match_array(moves)
            end
        end
    end

    describe 'checks' do
        before do 
            King.new('K','W',0,0,board)
        end
        context 'W queen on e4 and B king on g8' do
            subject(:queen) { described_class.new('Q','W',3,4,board) }
            before do
                board[7][6] = double(side:'B',name:'K')
            end
            it 'queen can check' do
                checks = ['Qa8+', 'Qe8+', 'Qe6+','Qd5+','Qc4+','Qh7+','Qg6+','Qg4+','Qg2+']
                expect(queen.moves.select { |m| m.end_with?('+')}).to match_array(checks)
            end
        end

        context 'W queen on e4 and black king castled on g8' do
            subject(:queen) { described_class.new('Q','W',3,4,board) }
            it 'only check = Qxh7+' do
                board[7][6] = double(side:'B',name:'K')
                board[7][5] = double(side:'B',name:'R')
                board[6][5] = double(side:'B',name:'P')
                board[6][6] = double(side:'B',name:'P')
                board[6][7] = double(side:'B',name:'P')
                expect(queen.moves.select{|m|m.end_with?('+')}).to contain_exactly('Qxh7+')
            end
        end
    end

    describe '#moves_that_capture_own_pieces' do
        context 'white Queen on a1 with white pawns on a2, b1, b2,c3' do
            subject(:queen) { described_class.new('Q','W',0,0,board)} 
            it 'Qxa2, Qxb1, Qxb2' do
                board[0][1] = double(side:'W')
                board[1][0] = double(side:'W')
                board[1][1] = double(side:'W')
                board[2][2] = double(side:'W')
                board[0][2] = double(side:'W')
                board[2][0] = double(side:'W')
                expect(queen.moves_that_capture_own_pieces).to match_array(['Qxa2','Qxb1','Qxb2'])
            end
        end
    end

    describe 'pinned to king' do 
        context 'w K on e1, w Q on e2, b Q on e8' do 
            before do
                King.new('K','W',0,4,board)
                @wq = Queen.new('Q','W',1,4,board)
                Queen.new('Q','B',7,4,board)
            end
            it 'can only move along the e file' do 
                moves = '34567'.each_char.map { |x| "Qe#{x}" }
                moves.append('Qxe8')
                expect(@wq.moves).to match_array(moves)
            end
        end
        context 'w K on a1, w Q on b2, bQ on h8' do 
            before do
                King.new('K','W',0,0,board)
                @wq = Queen.new('Q','W',1,1,board)
                Queen.new('Q','B',7,7,board)
            end
            it 'can only move along the diagonal' do 
                moves = ['Qc3','Qd4','Qe5','Qf6','Qg7','Qxh8']
                expect(@wq.moves).to match_array(moves)
            end
        end
    end

end