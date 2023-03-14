:- write('Ἀχιλλεύς.').

:- dynamic fibonacci/2.
% Effectively uses a cache to avoid expensive double-recursion.
fibonacci(1, 1).
fibonacci(2, 1).
fibonacci(N, X) :- % Goals should ideally be in ascending order of expense / search space.
    N > 2,
    N1 is N - 1, fibonacci(N1, X1),
    N2 is N - 2, fibonacci(N2, X2),
    X is X1 + X2, % Naïve version ends here.
    asserta(fibonacci(N, X)).

size(L, N) :- size(L, 0, N).
% Tail recursion is converted to iteration; constant storage use.
size([], N, N).
size([_ | L], N1, N) :- N2 is N1 + 1, size(L, N2, N).

distance(X, Y, _, S, N) :- length(S, N).
distance(X, Y, F, S, N) :-
    X \== Y,
    P =.. [F, Z, X],
    call(P),
    negate member(Z, [X | S]),
    distance(Z, Y, F, [X | S], N).
distance(X, Y, N) :-
    distance(X, Y, sits_left,  [], A),
    distance(X, Y, sits_right, [], B),
    N is min(A, B).
