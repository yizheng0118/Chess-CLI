require_relative './Piece.rb'

class Bishop < Piece
    def initialize(name,side,row,col,board)
        super(name,side,row,col,board)
    end

    def moves
        m = []

        # top left
        tr = row
        tc = col
        while tr < 7 && tc > 0
            if squareEmpty?(tr+1,tc-1)
                encode_and_add_move(m, tr+1, tc-1, check:detect_check(tr+1,tc-1))
                tr += 1
                tc -= 1 
            else
                if board[tr+1][tc-1].side != self.side then encode_and_add_move(m,tr+1,tc-1,captures:true,check:detect_check(tr+1,tc-1)) end
                break
            end
        end

        # top right
        tr = row
        tc = col
        while tr < 7 && tc < 7
            if squareEmpty?(tr+1,tc+1)
                encode_and_add_move(m,tr+1,tc+1,check:detect_check(tr+1,tc+1))
                tr += 1
                tc += 1
            else
                if board[tr+1][tc+1].side != self.side then encode_and_add_move(m,tr+1,tc+1,captures:true,check:detect_check(tr+1,tc+1)) end
                break
            end
        end

        # bottom left
        tr = row
        tc = col
        while tr > 0 && tc > 0
            if squareEmpty?(tr-1,tc-1)
                encode_and_add_move(m,tr-1,tc-1,check:detect_check(tr-1,tc-1))
                tr -= 1
                tc -= 1
            else
                if board[tr-1][tc-1].side != self.side then encode_and_add_move(m,tr-1,t-1,captures:true,check:detect_check(tr-1,tc-1)) end
                break
            end
        end

        # bottom right
        tr = row
        tc = col
        while tr > 0 && tc < 7
            if squareEmpty?(tr-1,tc+1)
                encode_and_add_move(m,tr-1,tc+1,check:detect_check(tr-1,tc+1))
                tr -= 1
                tc += 1
            else
                if board[tr-1][tc+1].side != self.side then encode_and_add_move(m,tr-1,tc+1,captures:true,check:detect_check(tr-1,tc+1)) end
                break
            end
        end

        return m
    end

    def detect_check(r,c)
        # top left
        tr = r
        tc = c
        while tr < 7 && tc > 0
            if !squareEmpty?(tr+1, tc-1)
                if board[tr+1][tc-1].side != self.side && board[tr+1][tc-1].name == 'K' then return true 
                else break end
            else 
                tr += 1
                tc -= 1
            end
        end

        # top right
        tr = r
        tc = c
        while tr < 7 && tc < 7
            if !squareEmpty?(tr+1,tc+1)
                if board[tr+1][tc+1].side != self.side && board[tr+1][tc+1].name == 'K' then return true
                else break end
            else
                tr += 1
                tc += 1
            end
        end

        # bottom left
        tr = r
        tc = c
        while tr > 0 && tc > 0
            if !squareEmpty?(tr-1,tc-1)
                if board[tr-1][tc-1].side != self.side && board[tr-1][tc-1].name == 'K' then return true
                else break end
            else
                tr -= 1  
                tc -= 1
            end
        end

        # bottom right
        tr = r
        tc = c
        while tr > 0 && tc < 7
            if !squareEmpty?(tr-1,tc+1)
                if board[tr-1][tc+1].side != self.side && board[tr-1][tc+1].name == 'K' then return true
                else break end
            else
                tr -= 1
                tc += 1
            end
        end

        return false
    end

    def encode_and_add_move(list, r, c, captures:false, check:false)
        string = 'B' + (captures ? 'x' : '') + 'abcdefgh'[c] + (r+1).to_s + (check ? '+' : '')
        list.append(string)
    end

end
