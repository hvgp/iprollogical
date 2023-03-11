:- consult('00-Lacedaemon.pl').

:- write('Ἀναξανδρίδας.'), nl. % Directive. Built-in predicate; cannot redefine. Side-effect.

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
succession([Last | []]) :-
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
go :-
    succession ['Ἀναξανδρίδας', 'Λεωνίδας', 'Πλείσταρχος', 'Πλειστοάναξ'],
    succession ['Ζευξίδαμος', 'Ἀναξίδαμος', 'Ἀρχίδαμος'].
