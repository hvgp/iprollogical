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
