import java.util.Arrays;
import java.util.concurrent.TimeUnit;

// D: Die, S: Stay the same, G: Grow a new cell
enum Rules { D, S, G };

// template <int width, int height>
public class Life {
    int generation;
    boolean[][] grid;
    Rules[] rules;
    int width;
    int height;

    public Life(int width, int height, Rules[] rules) {
        this.rules = rules;
        this.width = width;
        this.height = height;
        this.grid = new boolean[width][height];
        this.generation = 0;
    }

    private int getNeighbors(int x, int y) {
        int neighbors = 0;
        for (int xOffset=-1; xOffset<=1; xOffset++) {
            for (int yOffset=-1; yOffset<=1; yOffset++) {
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

    private boolean get(int x, int y) {
        if (x>=0 && x<width && y>=0 && y<height) {
            return grid[x][y];
        }
        return false;
    }

    public void printGrid() {
        char[] barChars = new char[width];
        Arrays.fill(barChars, '-');
        String bar = new String(barChars);
        System.out.println("Generation " + generation);
        System.out.println("+" + bar + "+");
        for (int y=0; y<height; y++) {
            String line = "";
            for (int x=0; x<width; x++) {
                if (grid[x][y]) {
                    line += "0";
                } else {
                    line += " ";
                }
            }
            System.out.println("|" + line + "|");
        }
        System.out.println("+" + bar + "+");
    }

    public void nextGeneration() {
        boolean[][] nextGrid = new boolean[width][height];
        for (int x=0; x<width; x++) {
            for (int y=0; y<height; y++) {
                int neighbors = getNeighbors(x, y);
                Rules nextState = rules[neighbors];
                if (nextState == Rules.G) {
                    nextGrid[x][y] = true;
                } else if (nextState == Rules.S) {
                    nextGrid[x][y] = grid[x][y];
                }
            }
        }
        grid = nextGrid;
        generation++;
    }

    public void addFigure(int x, int y, int[][] points) {
        for (int i=0; i<points.length; i++) {
            grid[x+points[i][0]][y+points[i][1]] = true;
        }
    }

    static int[][] RPENTOMINO = {{1, 0}, {2, 0}, {0, 1}, {1, 1}, {1, 2}};
    static int[][] BLOCK = {{0, 0}, {1, 0}, {0, 1}, {1, 1}};
    static int[][] BLINKER = {{1, 0}, {1, 1}, {1, 2}};
    static int[][] BEACON = {{0, 0}, {0, 1}, {1, 0}, {2, 3}, {3, 2}, {3, 3}};

    public static void main(String[] args) {
        Rules[] rules = new Rules[]{
            Rules.D, Rules.D, Rules.S,
            Rules.G, Rules.D, Rules.D,
            Rules.D, Rules.D, Rules.D
        };
        Life game = new Life(20, 10, rules);
        game.addFigure(0, 0, BEACON);
        game.addFigure(4, 4, RPENTOMINO);

        while (true) {
            game.printGrid();
            game.nextGeneration();
            try {
                TimeUnit.SECONDS.sleep(1);
            }
            catch(InterruptedException ex) {
                    Thread.currentThread().interrupt();
            }
        }
    }
}
