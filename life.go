package main

import (
	"fmt"
	"strings"
	"time"
)

// Rules
const (
	D = iota // Die
	S = iota // Stay the same
	G = iota // Grow a new cell
)

type Life struct {
	generation int
	grid       [][]bool
	height     int
	width      int
	rules      [9]int
}

func makeGrid(width int, height int) [][]bool {
	var grid = make([][]bool, width)
	for i := 0; i < height; i++ {
		grid[i] = make([]bool, height)
	}
	return grid
}

func NewLife(width int, height int, rules [9]int) Life {
	var game = Life{
		generation: 0,
		grid:       makeGrid(width, height),
		height:     height,
		width:      width,
		rules:      rules,
	}
	return game
}

func (l *Life) get(x int, y int) bool {
	if x >= 0 && x < l.width && y >= 0 && y < l.height {
		return l.grid[x][y]
	}
	return false
}

func (l *Life) getNeighbors(x int, y int) int {
	neighbors := 0
	for xOffset := -1; xOffset <= 1; xOffset++ {
		for yOffset := -1; yOffset <= 1; yOffset++ {
			// Don't count the offset 0, 0
			if xOffset != 0 || yOffset != 0 {
				if l.get(x+xOffset, y+yOffset) {
					neighbors++
				}
			}
		}
	}
	return neighbors
}

func (l *Life) printGrid() {
	fmt.Printf("Generation %d\n", l.generation)
	fmt.Printf("+" + strings.Repeat("-", l.width) + "+\n")
	for y := 0; y < l.height; y++ {
		rowText := "|"
		for x := 0; x < l.height; x++ {
			if l.grid[x][y] {
				rowText += "0"
			} else {
				rowText += " "
			}
		}
		rowText += "|\n"
		fmt.Printf(rowText)
	}
	fmt.Printf("+" + strings.Repeat("-", l.width) + "+\n")
}

func (l *Life) nextGeneration() {
	var nextGrid = makeGrid(l.width, l.height)
	for x := 0; x < l.width; x++ {
		for y := 0; y < l.height; y++ {
			neighbors := l.getNeighbors(x, y)
			nextState := l.rules[neighbors]
			if nextState == G {
				nextGrid[x][y] = true
			} else if nextState == S {
				nextGrid[x][y] = l.grid[x][y]
			}
		}
	}
	l.grid = nextGrid
	l.generation++
}

func (l *Life) addFigure(x int, y int, points [][2]int) {
	for _, point := range points {
		l.grid[x+point[0]][y+point[1]] = true
	}
}

var RPENTOMINO = [][2]int{{1, 0}, {2, 0}, {0, 1}, {1, 1}, {1, 2}}
var BLOCK = [][2]int{{0, 0}, {1, 0}, {0, 1}, {1, 1}}
var BLINKER = [][2]int{{1, 0}, {1, 1}, {1, 2}}
var BEACON = [][2]int{{0, 0}, {0, 1}, {1, 0}, {2, 3}, {3, 2}, {3, 3}}

func main() {
	rules := [9]int{D, D, S, G, D, D, D, D, D}
	game := NewLife(10, 10, rules)
	// game.addFigure(0, 0, BEACON)
	game.addFigure(4, 4, RPENTOMINO)

	for {
		game.printGrid()
		game.nextGeneration()
		time.Sleep(time.Second/2)
	}
}
