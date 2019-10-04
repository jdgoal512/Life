#!/usr/bin/env ruby

#Rules
D = 0 #Die
G = 1 #Grow
S = 2 #Stay the same

class Life
    
  def initialize(width=10, height=10, rules=[D, D, S, G, D, D, D, D, D])
    @@generation = 0
    @@width = width
    @@height = height
    @@rules = rules
    @@grid = Array.new(width) { Array.new(height, false) }
  end

  def get(x, y)
    if x < 0 || y < 0 || x >= @@width || y >= @@height
      return false
    else
      return @@grid[x][y]
    end
  end

  def get_neighbors(x, y)
    neighbors = 0
    [-1, 0, 1].each do |x_offset|
      [-1, 0, 1].each do |y_offset|
        # Don't count the offset 0, 0
        if x_offset != 0 || y_offset != 0
          if get(x+x_offset, y+y_offset)
            neighbors += 1
          end
        end
      end
    end
    return neighbors
  end

  def print_grid()
    puts "Generation #{@@generation}"
    print "+", "-"*@@width, "+\n"
    @@height.times do |y|
      print("|")
      @@width.times do |x|
        if @@grid[x][y]
          print("0")
        else
          print(" ")
        end
      end
      puts "|"
    end
    print "+", "-"*@@width, "+\n"
  end

  def next_generation()
    next_grid = Array.new(@@width) { Array.new(@@height, false) }
    (0..(@@width-1)).each do |x|
      (0..(@@height-1)).each do |y|
        neighbors = get_neighbors(x, y)
        next_state = @@rules[neighbors]
        if next_state == G
          next_grid[x][y] = true
        elsif next_state == S
          next_grid[x][y] = @@grid[x][y]
        end
      end
    end
    @@grid = next_grid
    @@generation += 1
  end

  def add_figure(points, x=5, y=5)
    points.each do |point|
      a = point[0]
      b = point[1]
      @@grid[x+a][y+b] = true
    end
  end
end

RPENTOMINO = [[1, 0], [2, 0], [0, 1], [1, 1], [1, 2]]
BLOCK = [[0, 0], [1, 0], [0, 1], [1, 1]]
BLINKER = [[1, 0], [1, 1], [1, 2]]
BEACON = [[0, 0], [0, 1], [1, 0], [2, 3], [3, 2], [3, 3]]
game = Life.new(20, 10)
# game.add_figure(BEACON, x=0, y=0)
# game.add_figure(BLINKER, x=0, y=7)
game.add_figure(RPENTOMINO, x=4, y=4)
while true
    game.print_grid()
    game.next_generation()
    sleep(1)
end
