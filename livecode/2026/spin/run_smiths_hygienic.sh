#!/bin/bash
# Run one property check on smiths_hygienic.pml.
# Usage: ./run_smiths_hygienic.sh <check>
#   <check> = deadlock | mutex | live0 | live1 | live2 | live3 | live4

set -u

if [ $# -ne 1 ]; then
    echo "Usage: $0 <check>"
    echo "  deadlock       — no invalid end states (no LTL claim)"
    echo "  mutex          — safety: no two adjacent smiths eat at once"
    echo "  live0 .. live4 — liveness: smith i eventually eats when hungry"
    echo "  live_all       — liveness for all smiths at once"
    echo "Example: $0 live_all"
    exit 1
fi

check=$1

for tool in spin gcc; do
    command -v "$tool" >/dev/null 2>&1 || { echo "error: $tool not on PATH"; exit 1; }
done

echo "=============================================================="
echo "  smiths_hygienic.pml   $check"
echo "=============================================================="

rm -f pan.* *.trail pan_check _spin_nvr.tmp

case "$check" in
    deadlock)
        spin -a smiths_hygienic.pml
        rm -f _spin_nvr.tmp
        gcc -O2 -DNOCLAIM -o pan_check pan.c
        ./pan_check -m1000000
        ;;
    mutex)
        spin -a smiths_hygienic.pml
        gcc -O2 -o pan_check pan.c
        ./pan_check -m1000000 -N mutex
        ;;
    live0|live1|live2|live3|live4|live_all)
        spin -a smiths_hygienic.pml
        gcc -O2 -DNFAIR=6 -o pan_check pan.c
        ./pan_check -m1000000 -a -f -N "$check"
        ;;
    *)
        echo "error: unknown check '$check' (valid: deadlock, mutex, live0..live4, live_all)"
        exit 1
        ;;
esac

rm -f pan.* *.trail pan_check _spin_nvr.tmp
