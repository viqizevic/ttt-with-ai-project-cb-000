module Players
  class Computer < Player

    def move(board)
      9.times do |i|
        return "#{i+1}" if !board.taken?("#{i+1}")
      end
    end

  end
end
