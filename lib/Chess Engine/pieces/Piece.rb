class Piece
    attr_accessor :name, :side, :row, :col, :board
    def initialize(name, side, row, col, board)
        @name = name
        @side = side
        @row = row
        @col = col
        @board = board
        board[row][col] = self
        @xray = nil
    end

    def moves
        h = detect_pinned
        if h[:pinned]    
            moves = unpinned_moves.filter do |m|
                h2 = decode_move(m)
                h[:squares_between].include?([h2[:r],h2[:c]])
            end
            return moves
        end
        h = detect_king_attacked
        if h[:attacked]
            moves = unpinned_moves.filter do |m|
                h2 = decode_move(m)
                h[:valid_squares].include?([h2[:r],h2[:c]])
            end
            return moves
        end
        return unpinned_moves
    end

    def unpinned_moves
        return []
    end

    # detects if the piece calling this function is pinned to their king
    def detect_pinned
        k = find_king
        kr = k.row
        kc = k.col
        #up down left right
        [[1,0],[-1,0],[0,-1],[0,1]].each do |dr,dc|
            r = kr+dr
            c = kc+dc
            squares_between = []
            attacker = nil
            while r>=0 && r<=7 && c>=0 && c<=7
                p = self.board[r][c]
                if p == nil
                    squares_between.append([r,c])
                else
                    if p.side != self.side && (p.instance_of?(Rook)||p.instance_of?(Queen))
                        attacker = p
                        break
                    else
                        squares_between.append([r,c])
                    end
                end
                r += dr
                c += dc
            end
            if attacker != nil && squares_between.include?([self.row,self.col]) #the piece is in the path of the enemy rook/queen and its king
                pieces_between = squares_between.count{ |r,c| board[r][c] != nil }
                if pieces_between == 1
                    # also add attacker's coords to the squares_bewteen array (incase the piece can capture the pinning attaker)
                    squares_between.append([attacker.row,attacker.col])
                    return {pinned:true,attacker:attacker, squares_between:squares_between}
                end
            end
        end
        #up-right, up-left, down-right, down-left
        [[1,1],[1,-1],[-1,1],[-1,-1]].each do |dr, dc|
            r = kr+dr
            c = kc+dc
            squares_between = []
            attacker = nil
            while r>=0 && r<=7 && c>=0 && c<=7
                p = self.board[r][c]
                if p == nil
                    squares_between.append([r,c])
                else
                    if p.side != self.side && (p.instance_of?(Bishop)||p.instance_of?(Queen))
                        attacker = p
                        break
                    else
                        squares_between.append([r,c])
                    end
                end
                r += dr
                c += dc
            end
            if attacker != nil && squares_between.include?([self.row,self.col]) #the piece is in the path of the enemy rook/queen and its king
                pieces_between = squares_between.count{ |r,c| board[r][c] != nil }
                if pieces_between == 1
                    squares_between.append([attacker.row,attacker.col])
                    return {pinned:true, attacker:attacker, squares_between:squares_between}
                end
            end
        end
        return {pinned:false}
    end

    # checks if king is attacked and returns the squares that block the attack or capture the attacker
    def detect_king_attacked
        #check for knight checks first
        k = find_king
        [-2,-1,1,2].each do |dr|
            dc1 = 3 - dr.abs
            dc2 = -dc1
            r = k.row+dr
            c1 = k.col+dc1
            c2 = k.col+dc2
            if r>=0&&r<=7 && c1>=0&&c1<=7 
                p = self.board[r][c1]
                if p != nil && p.side != self.side && p.instance_of?(Knight)
                    return {attacked:true, valid_squares:[[r,c1]]}
                end
            end
            if r>=0&&r<=7 && c2>=0&&c2<=7
                p = self.board[r][c2]
                if p != nil && p.side != self.side && p.instance_of?(Knight)
                    return {attacked:true, valid_squares:[[r,c2]]}
                end
            end
        end
        #check for rook/queen horizontal and vertical checks
        [[1,0],[-1,0],[0,-1],[0,1]].each do |dr,dc|
            r = k.row+dr
            c = k.col+dc
            valid_squares = []
            while r>=0 && r<=7 && c>=0 && c<=7
                p = self.board[r][c]
                if p == nil
                    valid_squares.append([r,c])
                else
                    if p.side != self.side && (p.instance_of?(Rook)||p.instance_of?(Queen))
                        valid_squares.append([r,c])
                        return {attacked:true, valid_squares:valid_squares}
                    end
                    break
                end
                r += dr
                c += dc
            end
        end
        #check diagonal
        [[1,1],[-1,1],[1,-1],[-1,-1]].each do |dr,dc|
            r = k.row+dr
            c = k.col+dc
            valid_squares = []
            while r>=0 && r<=7 && c>=0 && c<=7
                p = self.board[r][c]
                if p == nil
                    valid_squares.append([r,c])
                else
                    if p.side != self.side && (p.instance_of?(Rook)||p.instance_of?(Queen))
                        valid_squares.append([r,c])
                        return {attacked:true, valid_squares:valid_squares}
                    end
                    break
                end
                r += dr
                c += dc
            end
        end
        return {attacked:false}
    end

    def find_king 
        self.board.each do |r|
            r.each do |p|
                if p != nil && p.side == self.side && p.instance_of?(King)
                    return p
                end
            end
        end
        raise "King not found Error"
        exit(1)
    end

    def moveTo(r,c)
        self.board[row][col] = nil
        self.row = r
        self.col = c
        self.board[row][col] = self
    end

    def squareEmpty?(r,c)
        #checks if the square is empty
        return self.board[r][c] == nil
    end
    
    def decode_move(str)
        m = str.match(/^([KQRBNabcdefgh])?x?([a-h][1-8])([+#])?$/)
        if m == nil then return nil end
        hash = 
        {
            piece: m[1] || 'P',
            r: m[2][1].to_i - 1,
            c: "abcdefgh".index(m[2][0]),
        }
        return hash
    end

    def decode_moves_to_coords
        list = moves.map do |m|
            h = decode_move(m)
            [h[:r],h[:c]]
        end
        return list
    end

    def attacked_squares
        return self.unpinned_moves
    end

    def to_s
        self.name
    end
    
end