
# Iprollogical

This is basically collection of notes and practice programs concerning logic and answer-set programming paradigms. It will continue to grow and change shape as we learn more.

- [Iprollogical](#iprollogical)
  - [Data Types, Concepts \& Vernacular](#data-types-concepts--vernacular)
  - [Prolog Evaluation Procedures (Unification \& Backtracking)](#prolog-evaluation-procedures-unification--backtracking)
    - [Evaluating a Sequence of Goals](#evaluating-a-sequence-of-goals)
    - [Evaluating \& Re-evaluating a Goal](#evaluating--re-evaluating-a-goal)
  - [Operators \& Built-in Predicates](#operators--built-in-predicates)
    - [Associativity Notation](#associativity-notation)
    - [Arithmetic Operators](#arithmetic-operators)
    - [Arithmetic Predicates](#arithmetic-predicates)
    - [Logical Operations](#logical-operations)
    - [List Processing](#list-processing)


## Data Types, Concepts & Vernacular

Prolog **programs** comprise a collection of **clauses**. Clauses are terminated by a dot and at least one whitespace character. They are either facts or rules:
- **Rules** are of the form `head :- body.` or `consequent :- andecedent.` where `:-` is called the *neck operator*. Rules can be read declaratively as "the `head` holds if the `body` holds" or procedurally as "to satisfy the `head`, first satisfy the `body`." The former is usually more idiomatic.
- **Facts** take the form `head.` or `consequent.` and are equivalent to a rule whose antecedent always holds, i.e. `fact :- true`. A collection of facts is called a **database**.

**Terms** are the sole data structure in Prolog; everything is achieved through composition of terms, which provide the concrete basis for more theoretical mechanisms. These are generally described using their own less concrete, more logical or mathematical nomenclature (which I have attempted to depict below). Terms may be **constants** – which comprise real numbers and **atoms**, or named constants – or **compound terms**, which are also called **structures**.

Compound terms are of the form `$functor(x₁, ..., xₙ)` where the **functor** is an atom, `x₁, ..., xₙ` represent **arguments** (which can be any valid terms) and `n` is the `arity` of the structure. The outermost functor of a compound term is called the **principle functor**. Compound terms are used to define **predicates**; in particular, any clause whose head is a compound term is said to define a predicate. The **mode** of an argument refers to whether or not it should be instantiated as part of a goal: `+` means it should be instantiated, `-` the opposite, and `?` either. The mode should always be annotated.

```mermaid
graph TD;
  subgraph Concrete;
  Number --> Constant;
  Atom --> Constant;
  Constant --> Term;
  Variable --> Term;
  Structure --> List;
  end;
  Atom --> Functor;
  Term --> Argument;
  Argument --> Structure["Compound Term\n(Structure)"];
  Functor --> Structure;
  Structure ==> Predicate;
  Structure --> Term;
  Structure ==> Clause;
  Clause --> Fact;
  Clause --> Rule;
  Fact --> Database;
  Fact --> Head["Head\n(Consequent)"];
  Rule --> Head;
  Rule --> Body["Body\n(Antecedent)"];
  Head --> Predicate;
  Clause ==> Program;
```

## Lists

TODO

## Operators

An **operator** is a specialised notation using functors binary and unary predicates: they use infix notation – `X ~ Y` – in the first case, and prefix – `~X` – or postfix – `X~` – notation in the latter. They are converted back into compound terms by the interpreter, i.e. `X * Y + Z` would become `+(*(X, Y), Z)`. This process is governed by the operator's **priority**, which indicates how tightly bound an operator is to its arguments, and **associativity**. Terms can be left or right associative, and may also prohibit association. Their priority is an integer value from 1 to 1200 (directly correlated with priority) that supports the recursive derivation of the princple functor in an expression, i.e. the ordering of each operator in an expression in descending order of precedence, where the operator of lowest precedence becomes the principle functor. Operators are defined by name, priority, and **specifier**, which encodes its associativity and type of notation.

```prolog
% Respectively, left-associative and right-associative operators.
(X * A) * B.
X ^ (A ^ B).

% Directive used to define an operator.
:- op(+Priority, +Specifier, +Name).

% Query the definition of an existing operator.
?- current_op(?Priority, ?Specifier, ?:Name).
```

### Specifiers

For all specifiers, `f` represents the operator, `x` represents an argument with strictly lower precedence than the operator, and `y` an argument with strictly more precedence.

| Operator | Nonassociative | Right-associative | Left-associative |
|----------|----------------|-------------------|------------------|
| Infix    |`xfx`           |`xfy`              |`yfx`             |
| Prefix   |`fx`            |`fy`               |                  |
| Postfix  |`xf`            |                   |`yf`              |

## Prolog Evaluation Procedures: Unification & Backtracking

Charts that visualise the precedural flow of a Prolog program. Based on Figures 3.5 and 3.6 in the second edition of Bramer's *Logic Programming with Prolog* (2013). Given the processes outlined below, it stands to reason that both the order in which the clauses concerning a certain predicate and the order of goals in the antecedent of a rule occur exercise significant influence on the evaluation of any given query; a truly **declarative** program should do what it can to mitigate the effect of these circumstances, refraining from relying on them to communicate the semantics or influence the execution process for any instance of that program.

### Evaluating a Sequence of Goals

```mermaid
graph TD;
    A[Are there any more goals?] -->|No| B[Goal sequence succeeds.];
    A -->|Yes| C[Evaluate the next goal.];
    C -->|"Success†"| A;
    C -->|"Failure"| D[Are there any previous goals?];
    D -->|No| E[Goal sequence fails.];
    D -->|Yes| F[Re-evaluate the previous goal.];
    F -->|Failure| D;
    F -->|"Success"| A;
```
† Some variables may have been instantiated (or bound) as part of this step.<br>
‡ Some variables may be reinstantiated – uninstantiated (or unbound) and reinstantiated to a new term – here.

### Evaluating & Re-evaluating a Goal

```mermaid
graph TD;
    A[Is the goal a built-in predicate?] -->|Yes| B[Evaluate the goal as per a\npredefined implementation procedure.];
    A -->|No| C["Are there any more\nclauses in the database?†"];
    C -->|No| D[Goal fails.];
    C -->|Yes| E["Does the goal unify with the\nconsequent (head) of the next clause?"]
    E -->|No| C;
    E -->|"Yes‡"| F["Evaluate the antecedent\n– another sequence of goals –\nof the clause.*"];
    F -->|Succeeds| G[Goal succeeds.];
    F -->|Fails| C;
```
† First evaluation begins at the top of the database; re-evaluation begins after the clause that last satisfied the goal.<br>
‡ Some variables may have been instantiated (or bound) as part of this step.<br>
\* Clause succeeds immediately if it is a fact (a rule where the antecedent is always true).

## Built-in Operators and Predicates

### Arithmetic Operators

| Operator | Operation             |
|----------|-----------------------|
|`+`       | Addition              |
|`-`       | Subtraction           |
|`*`       | Multiplication        |
|`^`       | Exponentiation        |
|`/`       | Division              |
|`//`      | Integer division      |
|`mod`     | Modulo                |
|`is`      | Arithmetic evaluation |

- Note: `is` is a binary operator operator used to evaluate arithmetic expressions as per `?- Value is Expression`, where if the first argument `Value` is an uninstantiated variable, it is instantiated with the numerical value evaluated from the second argument `Expression`. Otherwise, if the `Value` is already instantiated, `is` only succeeds if the numerical values are the same. More precisely, the second argument is evaluated numerically and *unified* with the first argument.

### Arithmetic Predicates

| Predicate | Operation             |
|-----------|-----------------------|
|`abs\1`    | Absolute value        |
|`sin\1`    | Sine                  |
|`cos\1`    | Cosine                |
|`min\2`    | Minimum               |
|`max\2`    | Maximum               |
|`round\1`  | Round                 |
|`sqrt\1`   | Square root           |

### Comparison Operators

Comparison operators are distinct for arithmetic and literal expressions. Both arguments in arithmetic expressions are always evaluated before comparison. Literal arguments are compared with respect to their lexical order.

| Operation             | Arithmetic comparison | Literal comparison |
|-----------------------|-----------------------|--------------------|
| Equality              | `=:=`                 |`==`
| Inequality            | `=/=`                 |`\==`
| Less than             | `<`                   |`@<`
| Less than or equal    | `=<`                  |`@<=`
| Greater than          | `>`                   |`@>`
| Greater than or equal | `>=`                  |`@>=`

### Logical Operators

| Operation     | Arithmetic            |
|---------------|-----------------------|
|`not` or `\+`  | Negation              |
|`,`            | Conjunction           |
|`;`            | Disjunction           |

- Note: `;` is the infix disjunction operator – as per the predicate `;/2` – which represents the logical or. This can convolute the logical or semantic intention of any given clause, especially contrasted against the equivalent clause making exclusive use of conjunction. Consensus seems to be that it's best to heavily preference the use of conjunction.

### List Operation Predicates

| Predicate       | Functionality         |
|-----------------|-----------------------|
|`member/2`       | Membership            |
|`append/3`       | Concatenation         |
|`delete/3`       | Deletion              |
|`intersection/3` | Intersection          |
|`reverse/2`      | Reversal              |
|`length/2`       | Length                |
|`quicksort/2`    | Sort                  |

#### Example Implementations

```prolog
% TODO: Move to source file?

member(Target, [Target | _]). % Can use cut to return only once in case of duplicate values. Without cut?
member(Target, [_ | List]) :- member(Target, List).

append([], BaseList, BaseList).
append([Value | SourceList], BaseList, [Value | ConcatenatedList]) :-
    append(SourceList, BaseList, ConcatenatedList).

delete([], _, []). % TODO: Verify this is correct without cuts. Should all be mutually exclusive.
delete([Target | List], Target, ListSansTarget) :-
    delete(List, Target, ListSansTarget).
delete([Value | List], Target, [Value | ListSansTarget]) :-
    Value \== Target,
    delete(List, E, ListSansTarget).

intersection([], _, []).
intersection([Shared | SourceList], BaseList, [Shared | IntersectedList]) :-
    member(Shared, BaseList),
    intersection(SourceList, BaseList, ConcatenatedList).
intersection([Value | SourceList], BaseList, IntersectedList) :-
    \+ member(Value, BaseList),
    intersection(SourceList, BaseList, IntersectedList).

reverse(InitialList, ReversedList) :- reverse(InitialList, _, ReversedList).
reverse([], ReversedList, ReversedList).
reverse([Value | SourceList], [Value | Accumulator], ReversedList) :-
    reverse(SourceList, [Value | Accumulator], ReversedList).

length([], 0). % length(+List, ?Length).
length([_ | List], Length) :- length(List, SubLength), Length is SubLength + 1.
```
