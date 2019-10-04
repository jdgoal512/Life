#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#ifdef _WIN32
#include <Windows.h>
#else
#include <unistd.h>
#endif

#define TRUE 1
#define FALSE 0

// D: Die, S: Stay the same, G: Grow a new cell
typedef enum { D, S, G } Rules;

typedef struct {
    int generation;
    Rules* rules;
    int width;
    int height;
    int** grid;
    int** nextGrid;
} Life;

int get(Life* self, int x, int y) {
    if (x >= 0 && x < self->width && y >= 0 && y < self->height) {
        return self->grid[x][y];
    }
    return FALSE;
}

int getNeighbors(Life* self, int x, int y) {
    int neighbors = 0;
    for (int xOffset = -1; xOffset <= 1; xOffset++) {
        for (int yOffset = -1; yOffset <= 1; yOffset++) {
            // Don't count the offset 0, 0
            if (xOffset != 0 || yOffset != 0) {
                if (get(self, x+xOffset, y+yOffset)) {
                    neighbors++;
                }
            }
        }
    }
    return neighbors;
}

void printGrid(Life* self) {
    char *bar = malloc(self->width + 1);
    char *row = malloc(self->width + 1);
    memset(bar, '-', self->width);
    bar[self->width] = 0;
    row[self->width] = 0;
    printf("Generation %d\n", self->generation);
    printf("+%s+\n", bar);
    for (int y=0; y<self->height; y++) {
        for (int x=0; x<self->width; x++) {
            if (self->grid[x][y]) {
                row[x] = '0';
            } else {
                row[x] = ' ';
            }
        }
        printf("|%s|\n", row);
    }
    printf("+%s+\n", bar);
    free(bar);
    free(row);
}

void nextGeneration(Life* self) {
    for (int x=0; x<self->width; x++) {
        for (int y=0; y<self->height; y++) {
            int neighbors = getNeighbors(self, x, y);
            int nextState = self->rules[neighbors];
            if (nextState == G) {
                self->nextGrid[x][y] = TRUE;
            } else if (nextState == D) {
                self->nextGrid[x][y] = FALSE;
            }
        }
    }
    self->generation++;
    for (int x=0; x<self->width; x++) {
        for (int y=0; y<self->height; y++) {
            self->grid[x][y] = self->nextGrid[x][y];
        }
    }
}

void addFigure(Life* self, int x, int y, int points[][2], int length) {
    for (int i=0; i<length; i++) {
        self->grid[x+points[i][0]][y+points[i][1]] = TRUE;
        self->nextGrid[x+points[i][0]][y+points[i][1]] = TRUE;
    }
}

int RPENTOMINO[][2] = {{1, 0}, {2, 0}, {0, 1}, {1, 1}, {1, 2}};
int BLOCK[][2] = {{0, 0}, {1, 0}, {0, 1}, {1, 1}};
int BLINKER[][2] = {{1, 0}, {1, 1}, {1, 2}};
int BEACON[][2] = {{0, 0}, {0, 1}, {1, 0}, {2, 3}, {3, 2}, {3, 3}};

int main() {
    Rules rules[9] = {D, D, S, G, D, D, D, D, D};
    const int WIDTH = 10; 
    const int HEIGHT = 10;

    int * grid[WIDTH];
    int * nextGrid[WIDTH];

    for (int i=0; i<WIDTH; i++) {
        grid[i] = malloc(HEIGHT*sizeof(int));
        memset(grid[i], 0, HEIGHT);
        nextGrid[i] = malloc(HEIGHT*sizeof(int));
        memset(nextGrid[i], 0, HEIGHT);
    }

    Life game = {
        .generation = 0,
        .rules = rules,
        .width = WIDTH,
        .height = HEIGHT,
        .grid = grid,
        .nextGrid = nextGrid
    };
    
    addFigure(&game, 0, 0, BEACON, 6);
    addFigure(&game, 4, 4, RPENTOMINO, 5);

    while (TRUE) {
        printGrid(&game);
        nextGeneration(&game);
        sleep(1);
    }
}
