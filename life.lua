#!/usr/bin/env lua

-- D: Die, S: Stay the same, G: Grow a new cell
D, S, G = 1, 2, 3
local default_rules = {D, D, S, G, D, D, D, D, D}

Life = {}

function Life:new(o, width, height, rules)
  o = {}
  setmetatable(o, self)
  self.__index = self
  self.width = width or 10
  self.height = height or 10
  self.rules = rules or default_rules
  self.generation = 0
  self.grid = {}
  self.next_grid = {}
  for x = 1, self.width do
    self.grid[x] = {}
    self.next_grid[x] = {}
    for y = 1, self.height do
      self.grid[x][y] = false
      self.next_grid[x][y] = false
    end
  end
  return o
end

function Life:get(x, y)
  if x > 0 and x <= self.width and y > 0 and y <= self.height then
    return self.grid[x][y]
  end
  return false
end

function Life:get_neighbors(x, y)
  local neighbors = 0
  for x_offset=-1,1 do
    for y_offset=-1,1 do
      -- Don't count the offset 0, 0
      if x_offset ~= 0 or y_offset ~= 0 then
        if self:get(x+x_offset, y+y_offset) then
          neighbors = neighbors + 1
        end
      end
    end
  end
  return neighbors
end

function Life:print_grid()
  print("Generation " .. self.generation)
  print("+" .. string.rep("-", self.width) .. "+")
  for y = 1, self.height do
    local row = ""
    for x = 1, self.width do
      if (self.grid[x][y]) then
        row = row .. "0"
      else
        row = row .. " "
      end
    end
    print("|" .. row .. "|")
  end
  print("+" .. string.rep("-", self.width) .. "+")
end

function Life:next_generation()
  for x = 1, self.width do
    for y = 1, self.height do
      neighbors = self:get_neighbors(x, y)
      next_state = self.rules[neighbors+1]
      if (next_state == G) then
        self.next_grid[x][y] = true
      elseif (next_state == D) then
        self.next_grid[x][y] = false
      end
    end
  end
  self.generation = self.generation + 1
  for x = 1, self.width do
    for y = 1, self.height do
      self.grid[x][y] = self.next_grid[x][y]
    end
  end
end

function Life:addFigure(x, y, points)
  for k, point in pairs(points) do
    self.grid[point[1]+x][point[2]+y] = true
    self.next_grid[point[1]+x][point[2]+y] = true
  end
end

RPENTOMINO = {{1, 0}, {2, 0}, {0, 1}, {1, 1}, {1, 2}}
BLOCK = {{0, 0}, {1, 0}, {0, 1}, {1, 1}}
BLINKER = {{1, 0}, {1, 1}, {1, 2}}
BEACON = {{0, 0}, {0, 1}, {1, 0}, {2, 3}, {3, 2}, {3, 3}}

game = Life:new(10, 10)
-- game:addFigure(1, 1, BEACON)
game:addFigure(4, 4, RPENTOMINO)
while true do
  game:print_grid()
  game:next_generation()
  -- There is no builtin sleep function in lua so we will prompt
  -- the user to press enter
  print("Press enter to continue")
  io.stdin:read"*l"
end
