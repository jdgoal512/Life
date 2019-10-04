import strutils
import os

type
  Rules = enum
    D, S, G  # D: die, S: stay the same, G: grow a new cell
  Life[W, H: static[int]] = ref object of RootObj
    generation: int
    rules: array[9, Rules]
    grid: array[1..H, array[1..W, bool]]

const DefaultRules =  [D, D, S, G, D, D, D, D, D]

proc get(self: Life, x: int, y: int): bool =
  try:
    return self.grid[x][y]
  except:
    return false

proc getNeighbors(self: Life, x: int, y: int): int =
  var neighbors: int  = 0
  for xOffset in [-1, 0, 1]:
    for yOffset in [-1, 0, 1]:
      # Don't count the offset 0, 0
      if not (xOffset == yOffset and yOffset == 0):
        if self.get(x+xOffset, y+yOffset):
          neighbors += 1
  return neighbors

proc printGrid(self: Life): void =
  echo("Generation ", self.generation)
  echo("+" & '-'.repeat(self.grid[0].len) & "+")
  for row in self.grid:
    var rowText = "|"
    for x in row:
      if x:
        rowText &= "0"
      else:
        rowText &= " "
    rowText &= "|"
    echo(rowText)
  echo("+" & '-'.repeat(self.grid[0].len) & "+")

proc nextGeneration(self: var Life): void =
  var nextGrid = self.grid
  for x in self.grid.low..self.grid.high:
    for y in self.grid[x].low..self.grid[x].high:
      let neighbors = self.get_neighbors(x, y)
      let nextState = self.rules[neighbors]
      if nextState == G:
        nextGrid[x][y] = true
      elif nextState == D:
        nextGrid[x][y] = false
  self.grid = nextGrid
  self.generation += 1

proc addFigure(self: var Life, points: openarray[array[2, int]], x: int = 5,
                y: int = 5): void =
  for point in points:
    self.grid[x+point[0]][y+point[1]] = true

let RPentomino = [[1, 0], [2, 0], [0, 1], [1, 1], [1, 2]]
let Block = [[0, 0], [1, 0], [0, 1], [1, 1]]
let Blinker = [[1, 0], [1, 1], [1, 2]]
let Beacon = [[0, 0], [0, 1], [1, 0], [2, 3], [3, 2], [3, 3]]

var game = Life[20, 10](rules: DefaultRules)
game.add_figure(Beacon, x=1, y=1)
game.add_figure(RPentomino, 4, 4)

while true:
  game.printGrid()
  game.nextGeneration()
  sleep(100)
