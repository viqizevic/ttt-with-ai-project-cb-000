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
    board.won?
  end

  def draw?
    !won? && board.full?
  end

  def over?
    draw? || won?
  end

  def winner
    winner_player.token if won?
  end

  def winner_player
    w = won?
    if w
      token = board.position(w[0]+1)
      return player_1 if token == player_1.token
      return player_2 if token == player_2.token
    end
  end

  def turn
    pos = current_player.move(board)
    if !board.valid_move?(pos)
      turn
    else
      board.update(pos, current_player)
      board.display
    end
  end

  def play
    while !over?
      turn
      puts ""
    end

    if won?
      puts "Congratulations #{winner}!"
      if human_against_cpu?
        puts "You #{winner_is_human? ? "won" : "lose"}!"
      end
    end
    puts "Cat's Game!" if draw?
  end

  def self.start
    puts "Welcome to Tic Tac Toe!"
    game = self.create_game
    if game.both_are_cpu?
      game.cpu_plays
    else
      game.play
    end
  end

  def self.create_game
    puts "Enter number of players (0, 1 or 2):"
    input = gets.strip
    if input.match(/^[0-2]$/)
      case input
      when "2"
        return Game.new
      when "1"
        if 0 == Random.new.rand(2)
          return Game.new(Players::Computer.new("X"))
        else
          return Game.new(Players::Human.new("X"), Players::Computer.new("O"))
        end
      when "0"
        return Game.new(Players::Computer.new("X"), Players::Computer.new("O"))
      end
    else
      self.create_game
    end
  end

  def cpu_plays
    results = Hash.new(0)
    20.times do
      play
      results[:draw] += 1 if draw?
      if won?
        results[winner] += 1
      end
      board.reset!
      switch_players
    end
    puts results
  end

  def switch_players
    temp = @player_1
    @player_1 = @player_2
    @player_2 = temp
  end

  def winner_is_human?
    winner_player.class == Players::Human
  end

  def human_against_cpu?
    player_1.class != player_2.class
  end

  def both_are_cpu?
    player_1.class == player_2.class && player_2.class == Players::Computer
  end

end
