require_relative './spec_helper.rb'
require_relative '../lib/pieces/Knight.rb'

RSpec.describe Knight do

    describe '#moves' do
        let(:board) { Array.new(8) { Array.new(8) } }
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

end