#!/usr/bin/env python3
import time

# Rules
D = 0  # Die
G = 1  # Grow
S = 2  # Stay the same


class Life:
    def __init__(self, width=10, height=10, rules=[D, D, S, G, D, D, D, D, D]):
        self.generation = 0
        self.width = width
        self.height = height
        self.rules = rules
        self.grid = [[False for i in range(height)] for j in range(width)]

    def get(self, x, y):
        # No wrapping
        if 0 <= x < self.width and 0 <= y < self.height:
            return self.grid[x][y]
        return 0

    def get_neighbors(self, x, y):
        neighbors = 0
        for x_offset in [-1, 0, 1]:
            for y_offset in [-1, 0, 1]:
                # Don't count the offset 0, 0
                if not x_offset == y_offset == 0:
                    if self.get(x+x_offset, y+y_offset):
                        neighbors += 1
        return neighbors

    def print_grid(self):
        print(f'Generation {self.generation}')
        print('+{}+'.format('-'*self.width))
        for row in self.grid:
            row_text = ''.join(['0' if x else ' ' for x in row])
            print(f'|{row_text}|')
        print('+{}+'.format('-'*self.width))

    def next_generation(self):
        next_grid = [y[:] for y in self.grid[:]]
        for x in range(self.width):
            for y in range(self.height):
                neighbors = self.get_neighbors(x, y)
                next_state = self.rules[neighbors]
                if next_state == G:
                    next_grid[x][y] = True
                elif next_state == D:
                    next_grid[x][y] = False
        self.grid = next_grid
        self.generation += 1

    def add_figure(self, points, x=5, y=5):
        for a, b in points:
            self.grid[x+a][y+b] = True


RPENTOMINO = [[1, 0], [2, 0], [0, 1], [1, 1], [1, 2]]
BLOCK = [[0, 0], [1, 0], [0, 1], [1, 1]]
BLINKER = [[1, 0], [1, 1], [1, 2]]
BEACON = [[0, 0], [0, 1], [1, 0], [2, 3], [3, 2], [3, 3]]

if __name__ == '__main__':
    game = Life()
    # game.add_figure(BEACON, x=2, y=1)
    game.add_figure(RPENTOMINO, x=4, y=4)

    while True:
        game.print_grid()
        game.next_generation()
        time.sleep(1)
