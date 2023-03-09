:- write('Ἀναξανδρίδας.'). % Directive. Built-in predicate; cannot redefine. Side-effect.

% TODO: Move all concepts in the comments to the README and delete from the source files.
% go :- expedience.

person('Ἀναξανδρίδας', 'Λακεδαίμων').   % Clauses; dot final. Facts; database.
person('Πλείσταρχος',  'Λακεδαίμων').
person('Πλειστοάναξ',  'Λακεδαίμων').   % Structures; functor, args; arity. Predicate = clause, head consequent: functor, arity.
person('Λεωνίδας',     'Λακεδαίμων').
person('Ζευξίδαμος',   'Λακεδαίμων').
person('Ἀναξίδαμος',   'Λακεδαίμων').
person('Ἀρχίδαμος',    'Λακεδαίμων').
person('Ξέρξης',       'Περσίς').

spartan(Figure) :- person(Figure, 'Λακεδαίμων');

dynasty('Ἀναξανδρίδας', 'Ἀγιάδαι'). % User-defined predicate.
dynasty('Πλείσταρχος',  'Ἀγιάδαι').
dynasty('Πλειστοάναξ',  'Ἀγιάδαι').
dynasty('Λεωνίδας',     'Ἀγιάδαι').
dynasty('Ζευξίδαμος',   'Εὐρυποντίδαι').
dynasty('Ἀναξίδαμος',   'Εὐρυποντίδαι').
dynasty('Ἀρχίδαμος',    'Εὐρυποντίδαι').

father('Ἀναξανδρίδας', 'Λεωνίδας').
father('Λεωνίδας',     'Πλείσταρχος').
father('Πλείσταρχος',  'Πλειστοάναξ').
father('Ζευξίδαμος',   'Ἀναξίδαμος').
father('Ἀναξίδαμος',   'Ἀρχίδαμος').

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
    =:=, =/= : Evaluate identical nos. Also < > =< >=
    R is E   : E is no. R unbound, bound to E. Bound no, succeeds as per =:=
    not      : Occasionally predicate instead of operator. Can redefine if desired.
*/
iseven(N) :- M is N // 2, M =:= N * 2. % Eg.
increase(N, M) :- M is N + 1.

% Redefinition of lineage predicate using `succeeded` operator.
succession([Final]) :- archagetai(Final).
succession([Predecessor, Successor | Descendants]) :-
    Successor succeeded Predecessor,
    succession([Successor | Descendants]).

:- op(200, fy, succession). % Prefix operator. `succession X`.
