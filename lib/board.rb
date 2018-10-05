class Board

  attr_accessor :cells

  def initialize
    reset!
  end

  def reset!
    @cells = Array.new(9, " ")
  end

  def display
    puts " #{@cells[0]} | #{@cells[1]} | #{@cells[2]} "
    puts "-----------"
    puts " #{@cells[3]} | #{@cells[4]} | #{@cells[5]} "
    puts "-----------"
    puts " #{@cells[6]} | #{@cells[7]} | #{@cells[8]} "
    puts ""
  end

  def position(input)
    @cells[input.to_i - 1]
  end

  def full?
    @cells.all? { |c| " " != c }
  end

  def turn_count
    @cells.select { |c| " " != c }.size
  end

  def taken?(pos)
    position(pos) != " "
  end

  def valid_move?(pos)
    pos.match(/^[1-9]$/) && !taken?(pos)
  end

  def update(pos, player)
    if valid_move?(pos)
      @cells[pos.to_i - 1] = player.token
    end
  end

  def won?
    Game::WIN_COMBINATIONS.detect do |combo|
      position("#{combo[0]+1}") == position("#{combo[1]+1}") &&
      position("#{combo[0]+1}") == position("#{combo[2]+1}") &&
      taken?("#{combo[0]+1}")
    end
  end

  def self.clone(instance)
    self.new.tap do |cloned|
      cloned.cells = instance.cells.map { |c| c }
    end
  end

end
