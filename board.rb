require 'set'
require_relative 'tile'

class Board
  attr_accessor :grid, :solved, :row_to_set, :col_to_set, :box_to_set

  def initialize(grid = nil)
    @grid = grid
    @solved = false
    @row_to_set = {}
    @col_to_set = {}
    @box_to_set = {}
    populate
  end

  def populate
    rows.each_with_index do |row, i|
      row_to_set[i] = Set.new(row.compact.map(&:value).compact)
    end

    cols.each_with_index do |col, i|
      col_to_set[i] = Set.new(col.compact.map(&:value).compact)
    end

    boxes.each_with_index do |box, i|
      box_to_set[[i / 3, i % 3]] = Set.new(box.compact.map(&:value).compact)
    end
  end

  def is_invalid?(pos, num)
    row = pos[0]
    col = pos[1]
    box = [row / 3, col / 3]
    p box_to_set
    row_to_set[row].include?(num) || col_to_set[col].include?(num) || box_to_set[box].include?(num)
  end

  def self.from_file(file)
    grid = []
    File.foreach(file) do |line|
      grid << line.chomp.split("").map do |el|
        num = el.to_i
        Tile.new(num > 0 ? num : nil, num > 0)
      end
    end

    #validate(grid)
    Board.new(grid)
  end

  def validate(grid)
    #grid.size == 9 && grid.all? { |row| row.size == 9 && row.all? {  }

  end

  def is_taken?(pos)
    self[*pos].value
  end

  def []=(row, col, tile)
    self.grid[row][col] = tile
  end

  def [](row, col)
    self.grid[row][col]
  end

  def update(pos, num)
    row = pos[0]
    col = pos[1]
    box = [row / 3, col / 3]
    row_to_set[row].add(num)
    col_to_set[col].add(num)
    box_to_set[box].add(num)
    self[*pos] = Tile.new(num, false)
    solved = check_if_solved
  end

  def render
    system("clear")
    grid.each do |row|
      puts row.map { |el| el.value ? el.value.to_s : "." }.join(" ")
    end
  end

  def rows
    grid
  end

  def check_if_solved
    (rows + cols + boxes).all? { |set| set.compact.size == 9 }
  end

  def solved?
    solved
  end

  def cols
    render
    cols = Array.new(9) { [] }
    grid.each do |row|
      row.each_with_index do |tile, col_idx|
        p col_idx
        cols[col_idx] << tile
      end
    end

    cols
  end

  def boxes
    boxes = []
    (0..6).step(3).each do |i|
      (0..6).step(3).each do |j|
        boxes << grid[i...(i + 3)].map do |row|
          row[j...(j + 3)]
        end.flatten
      end
    end
    boxes
  end

end
