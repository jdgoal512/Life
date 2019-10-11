#!/usr/bin/env php
<?php
/* grid size */
$width = 20;
$height = 10;

/* Rule per number of neighbors */
const D = 0;
const S = 1;
const G = 2;
$default_rules = array(D, D, S, G, D, D, D, D, D);

class Life {
    private $generation;
    private $width;
    private $height;
    private $rules;
    private $grid;


    function __construct($width, $height, $rules) {
        $this->width = $width;
        $this->height = $height;
        $this->rules = $rules;
        $this->generation = 0;
        $this->grid = array_fill(0, $height, array_fill(0, $width, False));
    }

    function get($x, $y) {
        if ($x >= 0 && $x < $this->width && $y >= 0 && $y < $this->height) {
            return $this->grid[$y][$x];
        }
    }

    function get_neighbors($x, $y) {
        $neighbors = 0;
        foreach (array(-1, 0, 1) as $x_offset) {
            foreach (array(-1, 0, 1) as $y_offset) {
                /* Don't count the offset 0, 0 */
                if ($x_offset != $y_offset or $x_offset != 0) {
                    if ($this->get($x+$x_offset, $y+$y_offset)) {
                        $neighbors += 1;
                    }
                }
            }
        }
        return $neighbors;
    }

    function print_grid() {
        print("Generation " . $this->generation . "\n");
        print("+" . str_pad("", $this->width, "-") . "+\n");
        foreach ($this->grid as $row) {
            print("|");
            foreach ($row as $cell) {
                if ($cell) {
                    print("0");
                } else {
                    print(" ");
                }
            }
            print("|\n");
        }
        print("+" . str_pad("", $this->width, "-") . "+\n");
    }

    function next_generation() {
        $next_grid = array_fill(0, $this->height, array_fill(0, $this->width, False));
        foreach ($this->grid as $y => $row) {
            foreach ($row as $x => $cell) {
                $neighbors = $this->get_neighbors($x, $y);
                $next_state = $this->rules[$neighbors];
                if ($next_state == G) {
                    $next_grid[$y][$x] = True;
                } elseif ($next_state == S) {
                    $next_grid[$y][$x]= $cell;
                }
            }
        }
        $this->grid = $next_grid;
        $this->generation++;
    }

    function add_figure($x, $y, $points) {
        foreach ($points as $p) {
            $this->grid[$y+$p[1]][$x+$p[0]] = True;
        }
    }
}

$RPENTOMINO = array(array(1, 0), array(2, 0), array(0, 1), array(1, 1), array(1, 2));
$BLOCK = array(array(0, 0), array(1, 0), array(0, 1), array(1, 1));
$BLINKER = array(array(1, 0), array(1, 1), array(1, 2));
$BEACON = array(array(0, 0), array(0, 1), array(1, 0), array(2, 3), array(3, 2), array(3, 3));

# add_figure(0, 0, @BLINKER);
$life = new Life(10, 10, $default_rules);
$life->add_figure(4, 4, $RPENTOMINO);
while (True) {
    $life->print_grid();
    $life->next_generation();
    sleep(1);
}
?>
