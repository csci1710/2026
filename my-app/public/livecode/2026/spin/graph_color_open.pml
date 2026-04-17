/*
 *  ./run_coloring_open.sh N K
 */

#ifndef N
#define N 5
#endif
#ifndef K
#define K 4
#endif

bool edge[N*N];
byte color[N];

active proctype search()
{
    byte u, v, c;
    bool ok = true;

    for (u : 0 .. N-1) {
        for (v : u+1 .. N-1) {
            if :: edge[u*N+v] = true :: edge[u*N+v] = false fi;
            edge[v*N+u] = edge[u*N+v] 
        }
    };

    for (u : 0 .. N-1) {
        select (c : 0 .. K-1);
        color[u] = c
    };

    for (u : 0 .. N-1) {
        for (v : 0 .. N-1) {
            if
            :: u != v && !edge[u*N+v]                      -> ok = false
            :: u != v && edge[u*N+v] && color[u]==color[v] -> ok = false
            :: else -> skip
            fi
        }
    };

    assert(!ok)
}
