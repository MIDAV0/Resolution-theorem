:-op(140, fy, neg).
:-op(160, xfy, [and, or, imp, revimp, uparrow, downarrow, notimp, notrevimp, equiv, notequiv]).


member(X, [X | _]).
member(X, [_ | Tail]) :- member(X , Tail).

remove(X, [], []).
remove(X, [X | Tail], Newtail) :-
	remove(X, Tail, Newtail).
remove(X, [Head | Tail], [Head | Newtail]):-
    remove(X, Tail, Newtail).
/*
 * To transform a given propositional formula into conjunctive normal form, we need to convert it into a conjunction of disjunctions. Here's the modified code that does this
 * 
 * 
conjunctive(_ and _).
conjunctive(neg(_ or _)).
conjunctive(neg(_ imp _)).
conjunctive(neg(_ revimp _)).
conjunctive(neg(_ uparrow _)).
conjunctive(_ downarrow _).
conjunctive(_ notimp _).
conjunctive(_ notrevimp _). 

disjunctive(neg(_ and _)).
disjunctive(_ or _).
disjunctive(_ imp _).
disjunctive(_ revimp _).
disjunctive(_ uparrow _).
disjunctive(neg(_ downarrow _)).
disjunctive(neg(_ notimp _)).
disjunctive(neg(_ notrevimp _)). 
*/
disjunctive(neg(_ or _)).
disjunctive(_ and _).
disjunctive(neg(_ imp _)).
disjunctive(neg(_ revimp _)).
disjunctive(neg(_ uparrow _)).
disjunctive(_ downarrow _).
disjunctive(_ notimp _).
disjunctive(_ notrevimp _).


conjunctive(_ or _).
conjunctive(neg(_ and _)).
conjunctive(_ imp _).
conjunctive(_ revimp _).
conjunctive(_ uparrow _).
conjunctive(neg(_ downarrow _)).
conjunctive(neg(_ notimp _)).
conjunctive(neg(_ notrevimp _)).


secondary(neg(_ equiv _)).
secondary(_ notequiv _).
secondary(_ equiv _).
secondary(neg(_ notequiv _)).


unary(neg neg _).
unary(neg true).
unary(neg false). 

components(X and Y, X, Y).
components(neg(X and Y), neg X, neg Y).
components(X or Y, X, Y).
components(neg(X or Y), neg X, neg Y).
components(X imp Y, neg X, Y).
components(neg(X imp Y), X, neg Y).
components(X revimp Y, X, neg Y).
components(neg(X revimp Y), neg X, Y).
components(X uparrow Y, neg X, neg Y).
components(neg(X uparrow Y), X, Y).
components(X downarrow Y, neg X, neg Y).
components(neg(X downarrow Y), X, Y).
components(X notimp Y, X, neg Y).
components(neg(X notimp Y), neg X, Y).
components(X notrevimp Y, neg X, Y).
components(neg(X notrevimp Y), X, neg Y). 

eqcomponents(X equiv Y, neg X, Y, X, neg Y).
eqcomponents(neg(X equiv Y), neg X, neg Y, X, Y).
eqcomponents(X notequiv Y, neg X, neg Y, X, Y).
eqcomponents(neg(X notequiv Y), neg X, Y, X, neg Y).

component(neg neg X, X).
component(neg true, false).
component(neg false, true).

singlestep([Conjunction | Rest], New) :-
  member(Formula, Conjunction),
  unary(Formula) ,
  component(Formula, Newformula),
  remove(Formula, Conjunction, Temporary),
  Newconjunction=[Newformula | Temporary],
  New=[Newconjunction | Rest].

singlestep([Conjunction | Rest], New) :-
  member(Alpha , Conjunction),
  disjunctive(Alpha),
  components(Alpha, Alphaone, Alphatwo),
  remove(Alpha, Conjunction, Temporary),
  Newcon=[Alphaone | Temporary],
  Newcontwo=[Alphatwo | Temporary],
  New=[Newcon, Newcontwo | Rest].

singlestep([Conjunction | Rest], New) :-
  member(Beta, Conjunction),
  conjunctive(Beta),
  components(Beta, Betaone, Betatwo),
  remove(Beta, Conjunction, Temporary),
  Newcon=[Betaone, Betatwo | Temporary],
  New=[Newcon | Rest].

singlestep([Conjunction | Rest], New) :-
  member(Gamma, Conjunction),
  secondary(Gamma),
  eqcomponents(Gamma, Alphaone, Alphatwo, Betaone, Betatwo),
  remove(Gamma, Conjunction, Temporary),
  Newcon=[Alphaone, Alphatwo | Temporary],
  Newcontwo=[Betaone, Betatwo | Temporary],
  New=[Newcon, Newcontwo | Rest].

  
singlestep([Conjunction | Rest], [Conjunction | Newrest]) :-
	singlestep(Rest, Newrest).

# resolutionstep - singlestep
# resolution - expand_and_close

expand(Dis, Newdis) :-
  singlestep(Dis, Temp),
  expand(Temp , Newdis).

expand(Dis, Dis).

resolution_rule(Clause1, Clause2 , New) :-
  member(X, Clause1),
  member(neg X, Clause2),
  remove(X, Clause1, Temp1),
  remove(neg X, Clause2, Temp2),
  append(Temp1, Temp2, New).

resolutionstep([], New).

resolutionstep(Clauses, NewClauses) :-
  select(Clause1, Clauses, Rest1),
  select(Clause2, Rest1, Rest2),
  resolution_rule(Clause1, Clause2, Resolvent),
  NewClauses = [Resolvent | Rest2].


clauseform(X,Y) :- expand([[X]], Y).

# closed([Branch | Rest]) :-
#   member(false, Branch),
#   closed(Rest).

# closed([Branch | Rest]) :-
#   includes_negation(Branch, Negation),
#   member(X, Branch),
#   member(neg X, Branch),
#   closed(Rest).

# closed([]).

expand_and_close(Tab) :-
  member([], Tab).

expand_and_close(Tab) :-
  resolutionstep(Tab, Newtab),
  expand_and_close(Newtab).

expand_and_close(Tab) :-
  singlestep(Tab, Newtab), !,
  expand_and_close(Newtab).


test(X) :-
  if_then_else(expand_and_close([[neg X]]), yes, no).

yes :- write('YES'), nl.

no :- write('NO'), nl.
