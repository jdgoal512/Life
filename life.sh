#!/usr/bin/env bash

#Grid size
WIDTH=10
HEIGHT=10
 
# Rule per number of neighbors
# D: die, G: grow, S: stay the same
#      0 1 2 3 4 5 6 7 8
RULES=(D D S G D D D D D)

declare -a GRID

get() {
    if (( $1 > 0 && $1 <= $WIDTH && $2 > 0 && $2 <= $HEIGHT )); then
        index=$(( $1*$WIDTH + $2 ))
        echo ${GRID[$index]}
    fi
}

set() {
   index=$(( $1*$WIDTH + $2 ))
   GRID[$index]=$3
}

get_neighbors() {
    neighbors=0
    for x_offset in $(seq -1 1); do
        for y_offset in $(seq -1 1); do
            # Don't count the offset 0, 0
            if [ $x_offset -ne $y_offset ] || [ $x_offset -ne 0 ]; then
                if [ ! -z "$(get $(( $1 + $x_offset )) $(( $2 + $y_offset )))" ]; then
                    neighbors=$(( $neighbors + 1 ))
                fi
            fi
        done
    done
    echo $neighbors
}

print_grid() {
    printf "+"
    for x in $(seq $WIDTH); do
        printf "-"
    done
    printf "+\n"
    for x in $(seq $WIDTH); do
        printf "|"
        for y in $(seq $HEIGHT); do
            if [ -z "$(get $x $y)" ]; then
                printf " "
            else
                printf "0"
            fi
        done
        printf "|\n"
    done
    printf "+"
    for x in $(seq $WIDTH); do
        printf "-"
    done
    printf "+\n"
}

next() {
    unset NEXT
    declare -a NEXT
    for x in $(seq $WIDTH); do
        for y in $(seq $HEIGHT); do
            neighbors=$(get_neighbors $x $y)
            next_state=${RULES[$neighbors]}
            index=$(( $x*$WIDTH + $y ))
            if [ $next_state == G ]; then
                NEXT[$index]="1"
            elif [ $next_state == S ]; then
                NEXT[$index]="$(get $x $y)"
            fi
        done
    done
    for x in $(seq $WIDTH); do
        for y in $(seq $HEIGHT); do
            index=$(( $x*$WIDTH + $y ))
            set $x $y ${NEXT[$index]}
        done
    done
}

# R-pentamino
set 5 5 1
set 6 5 1
set 4 6 1
set 5 6 1
set 5 7 1

# Block
# set 5 5 1
# set 5 6 1
# set 6 5 1
# set 6 6 1

# Blinker
# set 5 4 1
# set 5 5 1
# set 5 6 1

# Beacon
# set 4 4 1
# set 4 5 1
# set 5 4 1
# set 6 7 1
# set 7 6 1
# set 7 7 1

generation=0
while [ 1 ]; do
    echo "Generation $generation"
    print_grid
    next
    generation=$(( $generation + 1 ))
done
