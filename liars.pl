:- lib(ic).

genrand(N, List) :-
   length(List, N),
   make_list(N, List).

make_list(_, []).

make_list(N, [X|List]) :-
   random(R),
   X is R mod (N+1),
   make_list(N, List).

liars(List,Liars) :-
   length(List, Len),
   length(Liars, Len),
   Liars #:: 0..1,
   Sum #= sum(Liars),
   constrain(List, Liars, Sum),
   search(Liars,0,input_order,indomain,complete,[]).

constrain([], [], _) :- !.

%% (Sum #< List) will be True if person is a liar %%
constrain([List|R1], [Liar|R2], Sum) :-
   Liar #= (Sum #< List), 
   constrain(R1, R2, Sum).