/*
 *   ./run_smiths_hygienic.sh live_all 
 */

#define N 5

/* Fork f is shared by smith f (its left fork) and smith (f-1+N)%N
 * (its right fork). owner[f] is whichever of those two currently holds it. */
byte owner[N];
bool dirty_fork[N];
bool requested[N];     /* the non-owner has asked for this fork */

bool hungry[N];
bool eating[N];

proctype smith(byte id)
{
    byte left  = id;
    byte right = (id + 1) % N;
    byte left_neighbor  = (id + N - 1) % N;   /* shares our left fork */
    byte right_neighbor = (id + 1) % N;       /* shares our right fork */

    do
    /* Become hungry */
    :: atomic {
         !hungry[id] && !eating[id] ->
         hungry[id] = true
       }

    /* Request left fork */
    :: atomic {
         hungry[id] && owner[left] != id && !requested[left] ->
         requested[left] = true
       }

    /* Request right fork */
    :: atomic {
         hungry[id] && owner[right] != id && !requested[right] ->
         requested[right] = true
       }

    /* Respond to a request for our left fork (only if dirty) */
    :: atomic {
         owner[left] == id && requested[left] && dirty_fork[left] ->
         owner[left] = left_neighbor;
         dirty_fork[left] = false;
         requested[left] = false
       }

    /* Respond to a request for our right fork */
    :: atomic {
         owner[right] == id && requested[right] && dirty_fork[right] ->
         owner[right] = right_neighbor;
         dirty_fork[right] = false;
         requested[right] = false
       }

    /* Start eating: hungry, own both forks, and no pending request for
     * a dirty fork we own (must hand those over first). */
    :: atomic {
         hungry[id] && owner[left] == id && owner[right] == id &&
         !(requested[left]  && dirty_fork[left]) &&
         !(requested[right] && dirty_fork[right]) ->
         hungry[id] = false;
         eating[id] = true;
         dirty_fork[left]  = false;     /* clean while eating */
         dirty_fork[right] = false
       }

    /* Finish eating */
    :: atomic {
         eating[id] ->
         eating[id] = false;
         dirty_fork[left]  = true;      /* dirty after eating */
         dirty_fork[right] = true
       }
    od
}

init {
    atomic {
        /* Initial ownership: fork f owned by the lower-ID of its two sharers.
         * Fork f shared by smith f and smith (f-1+N)%N. */
        owner[0] = 0;     /* smiths 0 and 4 share fork 0 -> 0 */
        owner[1] = 0;     /* smiths 1 and 0 share fork 1 -> 0 */
        owner[2] = 1;     /* smiths 2 and 1 share fork 2 -> 1 */
        owner[3] = 2;     /* smiths 3 and 2 share fork 3 -> 2 */
        owner[4] = 3;     /* smiths 4 and 3 share fork 4 -> 3 */

        dirty_fork[0] = true;
        dirty_fork[1] = true;
        dirty_fork[2] = true;
        dirty_fork[3] = true;
        dirty_fork[4] = true;

        run smith(0);
        run smith(1);
        run smith(2);
        run smith(3);
        run smith(4);
    }
}

/* --- Properties (select with ./pan -N <name>) --- */

/* Safety: no two adjacent smiths eat simultaneously */
ltl mutex { [] !(
    (eating[0] && eating[1]) ||
    (eating[1] && eating[2]) ||
    (eating[2] && eating[3]) ||
    (eating[3] && eating[4]) ||
    (eating[4] && eating[0])
)}

/* Liveness: every hungry smith eventually eats */
ltl live0 { [] (hungry[0] -> <> eating[0]) }
ltl live1 { [] (hungry[1] -> <> eating[1]) }
ltl live2 { [] (hungry[2] -> <> eating[2]) }
ltl live3 { [] (hungry[3] -> <> eating[3]) }
ltl live4 { [] (hungry[4] -> <> eating[4]) }

/* Liveness for all smiths at once (conjunction of the five above) */
ltl live_all {
    [] ((hungry[0] -> <> eating[0]) &&
        (hungry[1] -> <> eating[1]) &&
        (hungry[2] -> <> eating[2]) &&
        (hungry[3] -> <> eating[3]) &&
        (hungry[4] -> <> eating[4]))
}
