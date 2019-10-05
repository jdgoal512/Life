#!/usr/bin/env perl

#Grid size
$WIDTH = 20;
$HEIGHT = 10;

# Rule per number of neighbors
use constant {
    D => 0,  # Die
    S => 1,  # Stay the same
    G => 2,  # Grow
};
#      0 1 2 3 4 5 6 7 8
@RULES = (D, D, S, G, D, D, D, D, D);

my @Grid;

sub get_index {
    my ($x, $y) = @_;
    return $x*$WIDTH + $y;

}

sub get {
    my ($x, $y) = @_;
    if ($x >= 0 && $x < $WIDTH && $y >= 0 && $y < $HEIGHT) {
        return $Grid[get_index($x, $y)];
    }
}

sub get_neighbors {
    my ($x, $y) = @_;
    my $neighbors = 0;
    for my $x_offset (-1 .. 1) {
        for my $y_offset (-1 .. 1) {
            # Don't count the offset 0, 0
            if ($x_offset != $y_offset or $x_offset != 0) {
                if (get($x+$x_offset, $y+$y_offset)) {
                    $neighbors += 1
                }
            }
        }
    }
    return $neighbors
}

sub print_grid {
    print("+" . "-" x $WIDTH . "+\n");
    for my $y (0 .. $HEIGHT-1) {
        print("|");
        for my $x (0 .. $WIDTH-1) {
            if (get($x, $y)) {
                print("0");
            } else {
                print(" ");
            }
        }
        print("|\n");
    }
    print("+" . "-" x $WIDTH . "+\n");
}

sub next_generation {
    my @next_grid;
    for my $x (0 .. $WIDTH-1) {
        for my $y (0 .. $HEIGHT-1) {
            my $neighbors = get_neighbors($x, $y);
            my $next_state = $RULES[$neighbors];
            if ($next_state == G) {
                $next_grid[get_index($x, $y)] = 1;
            } elsif ($next_state == S) {
                $next_grid[get_index($x, $y)] = $Grid[get_index($x, $y)];
            }
        }
    }
    for my $x (0 .. $WIDTH-1) {
        for my $y (0 .. $HEIGHT-1) {
            $Grid[get_index($x, $y)] = $next_grid[get_index($x, $y)];
        }
    }
}

sub add_figure {
    my $x = shift;
    my $y = shift;
    while (@_) {
        my $a = shift;
        my $b = shift;
        $Grid[get_index($x+$a, $y+$b)] = 1;
    }
}

@RPENTOMINO = ((1, 0), (2, 0), (0, 1), (1, 1), (1, 2));
@BLOCK = ((0, 0), (1, 0), (0, 1), (1, 1));
@BLINKER = ((1, 0), (1, 1), (1, 2));
@BEACON = ((0, 0), (0, 1), (1, 0), (2, 3), (3, 2), (3, 3));

# add_figure(0, 0, @BLINKER);
add_figure(4, 4, @RPENTOMINO);

my $generation = 0;
while (1) {
    print("Generation $generation\n");
    print_grid();
    next_generation();
    $generation += 1;
    sleep(1)
}
