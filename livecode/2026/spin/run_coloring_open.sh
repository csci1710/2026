#!/bin/bash
# Graph k-coloring (open search: nondet graph + coloring, assert K_N + valid).
# Usage: ./run_coloring_open.sh N K

set -u

if [ $# -ne 2 ]; then
    echo "Usage: $0 N K"
    echo "  N = number of vertices"
    echo "  K = number of colors"
    echo "Example: $0 5 4   # matches Forge's k5_4col (UNSAT, Spin OOMs)"
    exit 1
fi

N=$1
K=$2

for tool in spin gcc; do
    command -v "$tool" >/dev/null 2>&1 || { echo "error: $tool not on PATH"; exit 1; }
done

echo "=============================================================="
echo "  graph_color_open.pml   N=$N, K=$K"
echo "=============================================================="
rm -f pan.* *.trail pan_gc
spin -DN=$N -DK=$K -a graph_color_open.pml
gcc -O2 -DMEMLIM=2048 -o pan_gc pan.c
./pan_gc -E
rm -f pan.* *.trail pan_gc
