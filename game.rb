require_relative 'board'

class Game
  attr_accessor :board

  def initialize(filename)
    @board = Board.from_file(filename)
  end

  def valid_input?(input)
    if !input.match(/\A\d\d\,\d\Z/)
      puts "Invalid Syntax"
      return false
    else
      values = parse(input)
      if !(1..9).include?(values[0]) || values[1..2].any? { |el| !(0...9).include?(el) }
        puts "Each number must be in the range 1 to 9"
        return false
      elsif self.board.is_taken?(values[1..2])
        puts "Position (#{values[1]}, #{values[2]}) is taken."
        return false
      elsif self.board.is_invalid?(values[1..2], values[0])
        puts "This number is already in the same row/column/box."
        return false
      end
    end

    true
  end

  def get_move
    input = nil

    until input && valid_input?(input)
      prompt_num
      num_input = gets.chomp
      prompt_pos
      pos_input = gets.chomp
      input = num_input + pos_input
    end
    parse(input)
  end

  def prompt_num
    puts "Which number?"
    print "> "
  end

  def prompt_pos
    puts 'Which position?("<row>,<col>")'
    print "> "
  end

  def parse(string)
    string.gsub(/,/,"").split("").map { |char| char.to_i }
  end

  def play
    play_turn until board.solved?
    puts "Congratulations, you win!"
  end

  def play_turn
    board.render
    move = get_move
    self.board.update(move[1..2], move[0])
  end
end

if __FILE__ == $PROGRAM_NAME
  Game.new("puzzles/sudoku1.txt").play
end
