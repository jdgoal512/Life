#!/usr/bin/env perl

#Grid size
$WIDTH = 20;
$HEIGHT = 10;

use constant {
    D => 0,
    S => 1,
    G => 2,
};
 
# Rule per number of neighbors
# D: die, G: grow, S: stay the same
#      0 1 2 3 4 5 6 7 8
@RULES = (D, D, S, G, D, D, D, D, D);

my @GRID;

# declare -a GRID

sub get {
    my ($x, $y) = @_;
    if ($x > 0 && $x <= $WIDTH && $y > 0 && $y <= $HEIGHT) {
        return $GRID[$x*$WIDTH + $y];
    }
}

sub get_index {
    my ($x, $y) = @_;
    return $x*$WIDTH + $y

}

sub set {
    my ($x, $y, $value) = @_;
    $GRID[get_index $x, $y] = $value;
}

sub get_neighbors {
    my ($x, $y) = @_;
    my $neighbors = 0;
    for my $x_offset (-1 .. 1) {
        for my $y_offset (-1 .. 1) {
            # Don't count the offset 0, 0
            if ($x_offset != $y_offset or $x_offset != 0) {
                if (get $x+$x_offset, $y+$y_offset) {
                    $neighbors += 1
                }
            }
        }
    }
    return $neighbors
}

sub print_grid {
    printf "+";
    for my $x (0 .. $WIDTH-1) {
        printf "-";
    }
    printf "+\n";
    for my $y (0 .. $HEIGHT-1) {
        printf "|";
        for my $x (0 .. $WIDTH-1) {
            if (get $x, $y) {
                printf "0";
            } else {
                printf " ";
            }
        }
        printf "|\n";
    }
    printf "+";
    for my $x (0 .. $WIDTH-1) {
        printf "-";
    }
    printf "+\n";
}

sub next_generation {
    my @next_grid;
    for my $x (0 .. $WIDTH-1) {
        for my $y (0 .. $HEIGHT-1) {
            my $neighbors = get_neighbors($x, $y);
            my $next_state = $RULES[$neighbors];
            if ($next_state == G) {
                $next_grid[get_index $x, $y] = 1;
            } elsif ($next_state == S) {
                $next_grid[get_index $x, $y] = $grid[get_index $x, $y];
            }
        }
    }
    for my $x (0 .. $WIDTH-1) {
        for my $y (0 .. $HEIGHT-1) {
            set $x, $y, $next_grid[get_index $x, $y];
        }
    }
}

# R-pentomino
set 5, 5, 1;
set 6, 5, 1;
set 4, 6, 1;
set 5, 6, 1;
set 5, 7, 1;

# # Block
# # set 5 5 1
# # set 5 6 1
# # set 6 5 1
# # set 6 6 1

# # Blinker
# # set 5 4 1
# # set 5 5 1
# # set 5 6 1

# # Beacon
# # set 4 4 1
# # set 4 5 1
# # set 5 4 1
# # set 6 7 1
# # set 7 6 1
# # set 7 7 1

my $generation = 0;
while (1) {
    printf "Generation $generation\n";
    print_grid;
    next_generation;
    $generation += 1;
    sleep 1
}
