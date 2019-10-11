const std = @import("std");
const warn = std.debug.warn;

// D: Die, S: Stay the same, G: Grow a new cell
const Rule = enum {
    D,  // Die
    S,  // Stay the same
    G,  // Grow a new cell
};

const Life = struct {
    generation: i32,
    rules: []const Rule,
    width: usize,
    height: usize,
    grid: [][]bool,
    next_grid: [][]bool,
};

fn get(self: *Life, x: i32, y: i32) bool {
    if (x >= 0 and y >= 0) {
        const x_usize = @intCast(usize, x);
        const y_usize = @intCast(usize, y);
        if (x_usize < self.width and y_usize < self.height) {
            return self.grid[x_usize][y_usize];
        }
    }
    return false;
}

fn getNeighbors(self: *Life, x: usize, y: usize) usize {
    const x_i32 = @intCast(i32, x);
    const y_i32 = @intCast(i32, y);
    var neighbors: usize = 0;
    for ([_]i32{-1, 0, 1}) |x_offset| {
        for ([_]i32{-1, 0, 1}) |y_offset| {
            // Don't count the offset 0, 0
            if (x_offset != 0 or y_offset != 0) {
                if (get(self, x_i32 + x_offset, y_i32 + y_offset)) {
                    neighbors += 1;
                }
            }
        }
    }
    return neighbors;
}

fn printGrid(self: *Life) void {
    warn("Generation {}\n", self.generation);
    warn("+");
    var i: usize = 0;
    while (i < self.width) {
        warn("-");
        i += 1;
    }
    warn("+\n");
    for (self.grid) |row, y| {
        warn("|");
        for (row) |cell, x| {
            if (self.grid[x][y]) {
                warn("0");
            } else {
                warn(" ");
            }
        }
        warn("|\n");
    }
    warn("+");
    i = 0;
    while (i < self.width) {
        warn("-");
        i += 1;
    }
    warn("+\n");
}

fn nextGeneration(self: *Life) void {
    for (self.grid) |row, y| {
        for (row) |cell, x| {
            const neighbors = getNeighbors(self, x, y);
            const next_state = self.rules[neighbors];
            if (next_state == Rule.G) {
                self.next_grid[x][y] = true;
            } else if (next_state == Rule.D) {
                self.next_grid[x][y] = false;
            }
        }
    }
    self.generation += 1;
    for (self.next_grid) |row, y| {
        for (row) |cell, x1| {
            self.grid[x1][y] = self.next_grid[x1][y];
        }
    }
}

fn addFigure(self: *Life, x: usize, y: usize, points: []const [2]usize) void {
    for (points) |point| {
        self.grid[x+point[0]][y+point[1]] = true;
        self.next_grid[x+point[0]][y+point[1]] = true;
    }
}

const rpentomino = [_][2]usize{
    [2]usize{1, 0},
    [2]usize{2, 0},
    [2]usize{0, 1},
    [2]usize{1, 1},
    [2]usize{1, 2},
};
const block = [_][2]usize{
    [2]usize{0, 0},
    [2]usize{1, 0},
    [2]usize{0, 1},
    [2]usize{1, 1},
};
const blinker = [_][2]usize{
    [2]usize{1, 0},
    [2]usize{1, 1},
    [2]usize{1, 2},
};
const beacon = [_][2]usize{
    [2]usize{0, 0},
    [2]usize{0, 1},
    [2]usize{1, 0},
    [2]usize{2, 3},
    [2]usize{3, 2},
    [2]usize{3, 3},
};

pub fn main() void {
    const rules = [_]Rule{
        Rule.D, Rule.D, Rule.S,
        Rule.G, Rule.D, Rule.D,
        Rule.D, Rule.D, Rule.D
    }; 
    const width = 10; 
    const height = 10;

    // Create grids of slices for current and next generation
    var grid = init: {
        var original_grid: [width*height]bool = [_]bool{false} ** (width*height);
        var sliced_grid: [width][]bool = undefined;
        for (sliced_grid) |*pt, i| {
            pt.* = original_grid[i*height..(i+1)*height];
        }
        break :init sliced_grid[0..sliced_grid.len];
    };
    var next_grid = init: {
        var original_grid: [width*height]bool = [_]bool{false} ** (width*height);
        var sliced_grid: [width][]bool = undefined;
        for (sliced_grid) |*pt, i| {
            pt.* = original_grid[i*height..(i+1)*height];
        }
        break :init sliced_grid[0..sliced_grid.len];
    };

    var game = Life {
        .generation = 0,
        .rules = rules,
        .width = width,
        .height = height,
        .grid = grid,
        .next_grid = next_grid
    };
    
    // addFigure(&game, 0, 0, beacon[0..BEACON.len]);
    addFigure(&game, 4, 4, rpentomino[0..rpentomino.len]);

    while (true) {
        printGrid(&game);
        nextGeneration(&game);
        std.time.sleep(1000000000);
    }
}
