require "curses"

class ChessUI
    include Curses
    CELL_WIDTH = 4
    CELL_HEIGHT = 3

    def initialize(game)
        @game = game
        @game.turn = 'B'
        @cursor_row = 7
        @cursor_col = 0

        @selected = nil
        @message = "Arrow keys to move. Enter to select."
    end

    def run
        init_screen
        start_color
        noecho
        cbreak
        stdscr.keypad(true)
        curs_set(0)

        init_colors

        loop do
            draw
            case stdscr.getch
            when Key::LEFT
                @cursor_col -= 1 if @cursor_col > 0

            when Key::RIGHT
                @cursor_col += 1 if @cursor_col < 7

            when Key::UP
                @cursor_row -= 1 if @cursor_row > 0

            when Key::DOWN
                @cursor_row += 1 if @cursor_row < 7

            when 10, Key::ENTER, " "
                handle_enter

            when 'q'
                break
            end
        end

        ensure
            close_screen
    end

    def init_colors
        init_pair(1, COLOR_CYAN, COLOR_WHITE)    # light square
        init_pair(2, COLOR_CYAN, COLOR_BLACK)     # dark square

        init_pair(3, COLOR_BLACK, COLOR_RED)    # selected

        init_pair(4, COLOR_BLACK, COLOR_RED)   # cursor light
        init_pair(5, COLOR_WHITE, COLOR_YELLOW)  # cursor dark
    end

    def draw
        clear
        draw_board
        draw_status
        refresh
    end

    def draw_board
        board = @game.board
        turn = @game.turn
        h_p = board[@cursor_row][@cursor_col] #hovered_piece
        if h_p != nil then h_p_moves = h_p.decode_moves_to_coords end
        if @selected != nil then s_p = board[@selected[0]][@selected[1]] end # selected_piece
        if s_p != nil then s_p_moves = s_p.decode_moves_to_coords end
        board.each_with_index do |row, r|
            row.each_with_index do |piece, c|
                y = r
                x = c * CELL_WIDTH
                setpos(y, x)
                light = (r + c).even?
                color = color_pair(light ? 1 : 2)
                str = " #{piece==nil ? " " : piece}  "
                if s_p 
                    #piece is selected
                    #other pieces that you hover over shouldn't show their moves
                    #s_p moves shown
                    #still show cursor
                    if [r,c] == @selected
                        str = "[#{piece} ]"
                    elsif [r,c] == [@cursor_row,@cursor_col]
                        if s_p_moves.include?([r,c])
                            str = "[🟩]"
                        else
                            str = "[#{piece==nil ? " " : piece} ]"
                        end
                    elsif s_p_moves.include?([r,c])
                        str = " 🟩  "
                    end
                else
                    #no piece is selected
                    #pieces show moves on hover
                    #show cursor
                    if [r,c] == [@cursor_row,@cursor_col]
                        str = "[#{piece==nil ? " " : piece } ]"
                    elsif h_p_moves != nil && h_p_moves.include?([r,c]) && h_p.side == turn
                        str = " 🟩  "
                    end
                end

                attron(color) do
                    addstr(str)
                end

            end
        end
    end

    def draw_status
        setpos(10, 0)
        addstr(@message + "#{@game.turn} to move")
    end

    def handle_enter
        # select piece 
        s_p = @game.board[@cursor_row][@cursor_col]
        if @selected.nil? && s_p != nil && s_p.side == @game.turn
            @selected = [@cursor_row, @cursor_col]
            @message = "Selected #{@selected.inspect}"
        end

        # piece already selected
        if @selected != nil
            s_p = @game.board[@selected[0]][@selected[1]]
            # make a move
            dst = @game.board[@cursor_row][@cursor_col]
            if s_p.decode_moves_to_coords.include?([@cursor_row,@cursor_col])
                s_p.moveTo(@cursor_row,@cursor_col)
                @selected = nil
                if @game.turn == 'W' then @game.turn = 'B'
                else @game.turn = 'W' end
            end
            # reselect a piece
        end
    end

    def piece_char(piece)
        return " " if piece.nil?
        piece.to_s
    end
end