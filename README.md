
# Iprollogical

A collection of notes concerning and exercises reflecting my understanding of logic and answer-set programming paradigms, started as part of my course in Intelligent Decision Making. My intention is to continue expanding this knowledge base in accordance with to the benefit of my own. TODO: This document (and probably the whole repository) will probably need to be decomposed once the content has expanded a bit.

- [Iprollogical](#iprollogical)
  - [Prolog Evaluation Procedures (Unification \& Backtracking)](#prolog-evaluation-procedures-unification--backtracking)
    - [Evaluating a Sequence of Goals](#evaluating-a-sequence-of-goals)
    - [Evaluating \& Re-evaluating a Goal](#evaluating--re-evaluating-a-goal)
  - [Operators: Notation \& Definition](#operators-notation--definition)
    - [Associativity Notation](#associativity-notation)
  - [Useful Built-in Predicates \& Operators (SWI Prolog)](#useful-built-in-predicates--operators-swi-prolog)
    - [Arithmetic Operators](#arithmetic-operators)
    - [Arithmetic Predicates](#arithmetic-predicates)
    - [Logical Operators](#logical-operators)
    - [List Processing](#list-processing)

## Prolog Evaluation Procedures (Unification & Backtracking)

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

## Operators: Notation & Definition

### Associativity Notation

- `x` is an argument with strictly less precedence than the operator itself.
- `y` is as per the above, with strictly more precedence.

## Useful Built-in Predicates & Operators (SWI Prolog)

### Arithmetic Operators

- `+`
- `-`
- `*`
- `/`
- `//` — Integer arithmetic div and mod operators.
- `mod`
- `^`
- `is` — Binary operator, if the left is and uninstantiated variable, it is instantiated with the numerical value on the right. If it's an instantiated numerical value, `is` succeeds if the two values are the same, and fails otherwise. More precisely, the second argument is evaluated numerically and *unified* with the first argument.

### Arithmetic Predicates

- `abs/1`
- `sin/1`
- `cos/1`
- `max/2`
- `round/1`
- `sqrt/1`

### Logical Operators

- `not` — Sometimes implemented as an operator, sometimes left as predicate `not/1`. Can convert using `:- op(1000, fy, not).`
- `;` — Infix disjunction operator, as per the predicate `;/2`; represents the logical or. This can convolute the logical or semantic intention of an antecedent its included in, especially contrasted agains the equivalent clause using conjunction (the `,/2` predicate that represents the logical and) exclusively. Consensus seems to be that it's best to limit its use.

### List Processing

- `append/3` should probably be called `concatenated` or something similar; behaves like `concatenated(PrefixList, SuffixList, ConcatenatedList)`.