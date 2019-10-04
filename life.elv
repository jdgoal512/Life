#!/usr/bin/env elvish

#Size
WIDTH = 10
HEIGHT = 10
 
# Rule per number of neighbors (D: die, S: stay the same, G: new cell grows)
#       012345678
RULES = DDSGDDDDD

GENERATION = 0

GRID = [(repeat $WIDTH [(repeat $HEIGHT $false)])]

fn get [x y]{
    try {
        put $GRID[$x][$y]
    } except {
        put $false
    }
}

fn get-neighbors [x y]{
    neighbors = 0
    for x-offset [-1 0 1] {
        for y-offset [-1 0 1] {
            # Don't count the offset 0, 0
            if (not (== $x-offset $y-offset 0)) {
                if (get (+ $x $x-offset) (+ $y $y-offset)) {
                    neighbors = (+ $neighbors 1)
                }
            }
        }
    }
    put $neighbors
}

fn print-grid []{
    echo Generation $GENERATION
    echo "+"(joins "" [(repeat $WIDTH -)])"+"
    for y [(range $HEIGHT)] {
        row = ""
        for col $GRID {
            if $col[$y] {
                row = $row'0'
            } else {
                row = $row' '
            }
        }
        echo "|"$row"|"
    }
    echo "+"(joins "" [(repeat $WIDTH -)])"+"
    GENERATION = (+ $GENERATION 1)
}

fn next-generation []{
    next-grid = [(repeat $WIDTH [(repeat $HEIGHT $false)])]
    for x [(range $WIDTH)] {
        for y [(range $HEIGHT)] {
            neighbors = (get-neighbors $x $y)
            next-state = $RULES[$neighbors]
            if (eq $next-state G) {
                next-grid[$x][$y] = $true
            } elif (eq $next-state S) {
                next-grid[$x][$y] = (get $x $y)
            }
        }
    }
    GRID = $next-grid
}

fn add-figure [&x=5 &y=5 points]{
    for point $points {
        a b = $@point
        GRID[(+ $x $a)][(+ $y $b)] = $true
    }
}

RPENTOMINO = [[1 0] [2 0] [0 1] [1 1] [1 2]]
BLOCK = [[0 0] [1 0] [0 1] [1 1]]
BLINKER = [[1 0] [1 1] [1 2]]
BEACON = [[0 0] [0 1] [1 0] [2 3] [3 2] [3 3]]

# add-figure &x=8 &y=4 $RPENTOMINO
# add-figure &x=2 &y=7 $BLOCK
# add-figure &x=15 &y=1 $BLINKER
add-figure &x=2 &y=1 $BEACON

while $true {
    print-grid
    next-generation
}
