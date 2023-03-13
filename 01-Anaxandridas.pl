:- consult('00-Lacedaemon.pl').

:- write('Ἀναξανδρίδας'), nl. % Directive.

spartan(Figure) :- person(Figure, 'Λακεδαίμων').
father(Father, Son) :- male(Father), parent(Father, Son).

defeated('Λεωνίδας', 'Θερμοπυλῶν').
defeated('Ξέρξης',   'Σαλαμίς').

% Goals. Evaluated: satisfiable; unsatisfiable.
archagetai(Person) :- spartan(Person), dynasty(Person, 'Ἀγιάδαι').
archagetai(Person) :- spartan(Person), dynasty(Person, 'Εὐρυποντίδαι').

% Variables: bound / unbound, instantiated / uninstantiated. Clausal lexical scope.
% List; structure. Consequent / head variable: universally quantified. Antecedent variable: existentially quantified.

heir(Successor, Predecessor) :- father(Predecessor, Successor), archagetai(Predecessor).
lineage([King]) :- archagetai(King).
lineage([King, Scion | Progeny]) :- heir(Scion, King), lineage([Scion | Progeny]). % Direct / indirect recursion.

% Operator; notation. Definition: predicate, directive. Precedence, associativity, functor.
% Infix; binary predicate: xfx, xfy, yfx. Prefix; unary: fx, fy. Postfix: unary: xf, yf.
% Prefix; unary: fx, fy.
succeeded(Successor, Predecessor) :- archagetai(Successor), heir(Successor, Predecessor).
:- op(200, yfx, succeeded).
/*
    =  , /=  : Args unify.
    == , /== : Args identical.
    =:=, =/= : Evaluate identical nos.
*/
iseven(N) :- M is N // 2, M =:= N * 2. % Eg.
increase(N, M) :- M is N + 1.

% Redefinition of lineage predicate using `succeeded` operator.
succession([Last]) :-
    write(Last),
    nl,
    archagetai(Last).
succession([Predecessor, Successor | Descendants]) :-
    write(Predecessor), % Side effects.
    write(' ~ '),
    write(Successor),
    nl,
    Successor succeeded Predecessor,
    succession([Successor | Descendants]).
:- op(200, fy, succession).

% List predicates. TODO: Most haven't yet been tested properly.

exists(Target, [Target | _]). % Member.
exists(Target, [Value | List]) :- Value \== Target, exists(Target, List).

concatenate([], BaseList, BaseList). % Append.
concatenate([Value | SourceList], BaseList, [Value | ConcatenatedList]) :-
    concatenate(SourceList, BaseList, ConcatenatedList).

purge([], _, []). % Delete. TODO: Verify this is correct without cuts. Should all be mutually exclusive.
purge([Target | List], Target, ListSansTarget) :-
    purge(List, Target, ListSansTarget).
purge([Value | List], Target, [Value | ListSansTarget]) :-
    Value \== Target,
    purge(List, Target, ListSansTarget).

shared([], _, []). % Intersection.
shared([Shared | SourceList], BaseList, [Shared | IntersectedList]) :-
    member(Shared, BaseList),
    shared(SourceList, BaseList, IntersectedList).
shared([Value | SourceList], BaseList, IntersectedList) :-
    \+ member(Value, BaseList),
    shared(SourceList, BaseList, IntersectedList).

invert(InitialList, ReversedList) :- invert(InitialList, _, ReversedList). % Reverse.
invert([], ReversedList, ReversedList).
invert([Value | SourceList], [Value | Accumulator], ReversedList) :-
    invert(SourceList, [Value | Accumulator], ReversedList).

size([], 0). % Length: length(+List, ?Length).
size([_ | List], Length) :- size(List, SubLength), Length is SubLength + 1.

negate(X) :- \+ X.
:- op(900, fy, negate). % Redefining not operator.

<~(X, Y) :- number(X), number(Y), X < Y.
<~(X, Y) :-
    negate number(X),
    negate number(Y),
    X @< Y.
:- op(700, xfx, <~).

quickorder([], []) :- !. % Quicksort.
quickorder([Head | List], SortedList) :-
    partition(Head, List, LowerPartition, UpperPartition),
    quickorder(LowerPartition, SortedLower),
    quickorder(UpperPartition, SortedUpper),
    append(SortedLower, [Head | SortedUpper], SortedList).

partition(_, [], [], []) :- !. % Version without cuts?
partition(Pivot, [Value | List], [Value | LowerPartition], UpperPartition) :-
    precedes(Value, Pivot),
    partition(Pivot, List, LowerPartition, UpperPartition).
partition(Pivot, [Value | List], LowerPartition, [Value | UpperPartition]) :-
    negate precedes(Value, Pivot),
    partition(Pivot, List, LowerPartition, UpperPartition).

precedes(First, Second) :- First <~ Second.

% Directive for expedience through toplevel.
test_succession :-
    succession ['Ἀναξανδρίδας', 'Λεωνίδας', 'Πλείσταρχος', 'Πλειστοάναξ'],
    succession ['Ζευξίδαμος', 'Ἀναξίδαμος', 'Ἀρχίδαμος'].

test_sorting(X) :-
    quickorder([
        'Ἀναξανδρίδας',
        'Λεωνίδας',
        'Πλείσταρχος',
        'Πλειστοάναξ',
        'Ζευξίδαμος',
        'Ἀναξίδαμος',
        'Ἀρχίδαμος'
    ], X).

distance(Current, Current, _, Seen, Distance) :- length(Seen, Distance).
distance(Current, Target, Functor, Seen, Distance) :-
    Current \== Target,
    Predicate =.. [Functor, Next, Current],
    call(Predicate),
    negate member(Next, [Current | Seen]),
    distance(Next, Target, Functor, [Current | Seen], Distance).
distance(Current, Target, Distance) :-
    distance(Current, Target, sits_left,  [], Left),
    distance(Current, Target, sits_right, [], Right),
    Distance is min(Left, Right).
