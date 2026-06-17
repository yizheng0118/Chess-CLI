require_relative './spec_helper.rb'
require_relative '../lib/pieces/Knight.rb'

RSpec.describe Knight do

    describe '#moves' do
        let(:board) { Array.new(8) { Array.new(8) } }
        subject(:knight) { described_class.new('N','W',3,4,board) }
        context 'W Knight on e4' do
            it 'Nc5, Nd6, Nf6, Ng5, Ng3, Nf2, Nd2, Nc3' do
                expect(knight.moves).to match_array(['Nc5','Nd6','Nf6','Ng5','Ng3','Nf2','Nd2','Nc3'])
            end
            context 'B King on e8' do
                before do
                    board[7][4] = described_class.new('K','B',7,4,board)
                end
                it 'can check on d6 and f6' do
                    expect(knight.moves).to include('Nd6+','Nf6+')
                end
                context 'B pawn on d6 and f6' do
                    before do
                        board[5][3] = described_class.new('P','B',5,3,board)
                        board[5][5] = described_class.new('P','B',5,5,board)
                    end
                    it 'can take on d6 and f6 with check' do
                        expect(knight.moves).to include('Nxd6+','Nxf6+')
                    end
                end
            end
        end

    end

end