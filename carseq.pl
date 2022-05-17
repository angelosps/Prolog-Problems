:- lib(ic).
:- lib(ic_global).
:- set_flag(print_depth, 1000).

carseq(S) :-
   classes(Classes),
   options(Options),
   length(Classes, CLen),
   sum_list(Classes, CSum),
   length(S, CSum),
   S #:: 1..CLen,
   constrain1(S, Classes, 1),
   constrain2(S, Classes, Options),
   search(S,0,first_fail,indomain,complete,[]).

sum_list([], 0) :- !.

sum_list([H|R], Sum) :-
   sum_list(R, RestSum),
   Sum is H + RestSum.

find_minmax([], [], 0) :- !.

find_minmax([1|R], [C|R2], MM) :-
   find_minmax(R, R2, MM2),
   MM is C + MM2.   

find_minmax([0|R], [_|R2], MM) :-
   find_minmax(R, R2, MM).

find_values([], [], _, []) :- !.

find_values([1|R], [C|R2], I, [I|RestValues]) :-
   II is I + 1, 
   find_values(R, R2, II, RestValues).   

find_values([0|R], [_|R2], I, Values) :-
   II is I + 1,
   find_values(R, R2, II, Values).

%% Each configuration has to have exactly C cars %%

constrain1(_, [], _) :- !.

constrain1(S, [C|R], I) :-
   occurrences(I, S, C),
   II is I + 1,
   constrain1(S, R, II).

%% Every M continuous cars, at most K can have the same option %%

constrain2(_, _, []) :- !.

constrain2(S, Classes, [M/K/O|Rest]) :-
   find_minmax(O, Classes, MM),
   find_values(O, Classes, 1, Values),
   sequence_total(MM, MM, 0, K, M, S, Values),
   constrain2(S, Classes, Rest).