class Game

  WIN_COMBINATIONS = [
    [0,1,2], # Top row
    [3,4,5], # Middle row
    [6,7,8], # Bottom row
    [0,3,6], # Left column
    [1,4,7], # Middle column
    [2,5,8], # Right column
    [0,4,8], # First diagonal
    [2,4,6]  # Second diagonal
  ]

  attr_accessor :board, :player_1, :player_2

  def initialize(p1=nil, p2=nil, board=nil)
    @player_1 = p1 ? p1 : Players::Human.new("X")
    @player_2 = p2 ? p2 : Players::Human.new("O")
    @board = board ? board : Board.new
  end

  def current_player
    board.turn_count % 2 == 0 ? player_1 : player_2
  end

  def won?
    WIN_COMBINATIONS.detect do |combo|
      board.position(combo[0]+1) == board.position(combo[1]+1) &&
      board.position(combo[0]+1) == board.position(combo[2]+1) &&
      board.taken?(combo[0]+1)
    end
  end

  def draw?
    !won? && board.full?
  end

  def over?
    draw? || won?
  end

  def winner
    w = won?
    board.position(w[0]+1) if w
  end

  def turn
    pos = current_player.move(board)
    if !board.valid_move?(pos)
      turn
    else
      board.update(pos, current_player)
    end
  end

  def play
    while !over?
      turn
    end

    puts "Congratulations #{winner}!" if won?
    puts "Cat's Game!" if draw?
  end

end
