#include <array>
#include <iostream>
#include <time.h>

using namespace std;

// D: Die, S: Stay the same, G: Grow a new cell
enum Rules { D, S, G };

template <int width, int height>
class Life {
    private:
        int generation;
        array<array<bool, height>, width> grid;
        array<int, 9> rules;

    public:
        Life(array<int, 9> rules) {
            this->rules = rules;
            this->grid = array<array<bool, height>, width>();
            this->generation = 0;
        }

        int getNeighbors(int x, int y) {
            int neighbors = 0;
            for (int xOffset = -1; xOffset <= 1; xOffset++) {
                for (int yOffset = -1; yOffset <= 1; yOffset++) {
                    // Don't count the offset 0, 0
                    if (xOffset != 0 || yOffset != 0) {
                        if (get(x+xOffset, y+yOffset)) {
                            neighbors++;
                        }
                    }
                }
            }
            return neighbors;
        }

        bool get(int x, int y) {
            if (x >= 0 && x < width && y >= 0 && y < height) {
                return grid[x][y];
            }
            return false;
        }

        void printGrid() {
            string bar (width, '-');
            cout << "Generation " << generation << endl;
            cout << "+" << bar << "+" << endl;
            for (int y = 0; y < height; y++) {
                cout << "|";
                for (int x = 0; x < width; x++) {
                    if (grid[x][y]) {
                        cout << "0";
                    } else {
                        cout << " ";
                    }
                }
                cout << "|" << endl;
            }
            cout << "+" << bar << "+" << endl;
        }

        void nextGeneration() {
            array<array<bool, height>, width> nextGrid = {};
            for (int x=0; x<width; x++) {
                for (int y=0; y<height; y++) {
                    int neighbors = getNeighbors(x, y);
                    int nextState = rules[neighbors];
                    if (nextState == G) {
                        nextGrid[x][y] = true;
                    } else if (nextState == S) {
                        nextGrid[x][y] = grid[x][y];
                    }
                }
            }
            grid = nextGrid;
            generation++;
        }

    void addFigure(int x, int y, int points[][2], int length) {
        for (int i=0; i<length; i++) {
            grid[x+points[i][0]][y+points[i][1]] = true;
        }
    }
};

int RPENTOMINO[][2] = {{1, 0}, {2, 0}, {0, 1}, {1, 1}, {1, 2}};
int BLOCK[][2] = {{0, 0}, {1, 0}, {0, 1}, {1, 1}};
int BLINKER[][2] = {{1, 0}, {1, 1}, {1, 2}};
int BEACON[][2] = {{0, 0}, {0, 1}, {1, 0}, {2, 3}, {3, 2}, {3, 3}};

int main() {
    array<int, 9> rules = {D, D, S, G, D, D, D, D, D};
    const int WIDTH = 20; 
    const int HEIGHT = 10;
    Life<WIDTH, HEIGHT> game = Life<WIDTH, HEIGHT>(rules);
    game.addFigure(0, 0, BEACON, 6);
    game.addFigure(4, 4, RPENTOMINO, 5);

    while (true) {
        game.printGrid();
        game.nextGeneration();

        struct timespec ts = { 0, 100000000L };
        nanosleep (&ts, NULL);
    }
}
