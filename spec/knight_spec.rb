require_relative './spec_helper.rb'
require_relative '../lib/pieces/Knight.rb'

RSpec.describe Knight do
    let(:board) { Array.new(8) { Array.new(8) } }
    describe '#moves' do
        context 'W Knight on e4' do
            subject(:knight) { described_class.new('N','W',3,4,board) }
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
                expect(knight.moves).to match_array(['Na3','Nc3','Nd2'])
            end
        end
    end

    describe '#moves_that_capture_own_pieces' do 
        context 'W Knight on e4 with 8 own pawns to capture' do
            subject(:knight) { described_class.new('N','W',3,4,board)}
            it 'can capture them' do
                p knight.moves
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
end