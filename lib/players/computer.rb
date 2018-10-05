module Players
  class Computer < Player

    def move(board)
      sleep(0.1)
      mv = smart_move(board)
      # mv = simple_move(board) if "X" != @token
      mv
    end

    def simple_move(board)
      return "5" if !board.taken?("5")
      [1,3,7,9].shuffle.each do |i|
        return "#{i}" if !board.taken?("#{i}")
      end
      Array.new(9) {|i| i+1}.shuffle.each do |i|
        return "#{i}" if !board.taken?("#{i}")
      end
    end

    def smart_move(board)
      (1..9).each do |i|
        pos = "#{i}"
        predict = Board.clone(board)
        if predict.valid_move?(pos)
          predict.update(pos, self)
          return pos if predict.won?
        end
      end
      enemy = create_enemy
      (1..9).each do |i|
        pos = "#{i}"
        predict = Board.clone(board)
        if predict.valid_move?(pos)
          predict.update(pos, enemy)
          return pos if predict.won?
        end
      end
      simple_move(board)
    end

    def create_enemy
      if @token == "X"
        self.class.new("O")
      else
        self.class.new("X")
      end
    end

  end
end
