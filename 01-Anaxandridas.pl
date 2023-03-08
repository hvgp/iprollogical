:- write('Anaxandridas.'). % Directive. Built-in predicate; cannot redefine. Side-effect.

% go :- expedience.

spartan('Anaxandridas').   % Clauses; dot final. Facts; database.
spartan('Pleistarchus').   % Fact: head / consequent.
spartan('Leonidas').       % Rule: consequent :- body / antecedent. Neck operator.
spartan('Pleistoanax').    % Structures; functor, args; arity. Predicate = clause, consequent: functor, arity.

% Declarative: consequent satisfiable if antecedent satisfiable. Goal; subgoals.
% Procedural: to satisfy consequent, first satisfy antecedent.

spartan('Zeuxidamus').
spartan('Anaxidamus').
spartan('Archidamus').

dynasty('Anaxandridas', 'Agiad'). % User-defined predicate.
dynasty('Pleistarchus', 'Agiad').
dynasty('Leonidas',     'Agiad').
dynasty('Pleistoanax',  'Agiad').

dynasty('Zeuxidamus',  'Eurypontid').
dynasty('Anaxidamus',  'Eurypontid').
dynasty('Archidamus',  'Eurypontid').

% Goals. Evaluated: satisfiable; unsatisfiable.
archagetai(Person) :- spartan(Person), dynasty(Person, 'Agiad').
archagetai(Person) :- spartan(Person), dynasty(Person, 'Eurypontid').

father('Anaxandridas', 'Leonidas').
father('Leonidas',     'Pleistarchus').
father('Pleistarchus', 'Pleistoanax').
father('Zeuxidamus',   'Anaxidamus').
father('Anaxidamus',   'Archidamus').

% Variables: bound / unbound, instantiated / uninstantiated. Clausal lexical scope.
heir(Successor, Predecessor) :- father(Predecessor, Successor), archagetai(Predecessor).

% List; structure. Consequent / head variable: universally quantified. Antecedent variable: existentially quantified.
lineage([Solitary]) :- archagetai(Solitary).
lineage([Reigning, Scion | Progeny]) :- heir(Scion, Reigning), lineage([Scion | Progeny]). % Direct / indirect recursion.

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
