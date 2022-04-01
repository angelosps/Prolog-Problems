% :- set_prolog_flag(answer_write_options, [quoted(true), portray(true), max_depth(100), attributes(portray)]).

%% Replaces I-th element with X %%
replace([_|T], 1, X, [X|T]) :- !.

replace([H|T], I, X, [H|R]):- 
	I > 1, I1 is I-1, 
	replace(T, I1, X, R).

%% Gets the N-th element of a list %%
getNth([H|_], 1, H) :- !.

getNth([_|T], N, H) :-
    N > 1, N1 is N-1,
    getNth(T,N1,H).

%% Copies I-th element next to it, cyclically %%
move(CurrState, I, N, NthElement, NextState) :- 
	I == N,
	replace(CurrState, 1, NthElement, NextState).

move(CurrState, I, N, NthElement, NextState) :- 
	I \== N,
	I2 is I+1,
	replace(CurrState, I2, NthElement, NextState).

%% Swaps elements at positions I, J %%
swap(CurrState, I, J, NextState) :-
	getNth(CurrState, I, IthElement),
	getNth(CurrState, J, JthElement),
	replace(CurrState, I, JthElement, DummyNext),
	replace(DummyNext, J, IthElement, NextState).

my_between(I, J, X) :- 
	I < J, X = I.

my_between(I, J, X) :- 
	I == J, !, 
	X = I.

my_between(I, J, X) :- 
	I < J, I2 is I + 1, 
	my_between(I2, J, X).

%% Generates all the move actions %%
next_move(CurrState, NextState, N, Action) :-
	my_between(1, N, NextIter),
	getNth(CurrState, NextIter, NthElement),
	move(CurrState, NextIter, N, NthElement, NextState),
	Action = move(NextIter).

%% Generates all the swap actions %%
next_move(CurrState, NextState, N, Action) :-
	my_between(1, N, NextII),
	NextI is NextII + 1, NextI =< N,
	my_between(NextI, N, NextJ),
	swap(CurrState, NextII, NextJ, NextState),
	Action = swap(NextII, NextJ).

%% Final state check %%
final_state([],[]) :- !.

final_state([H1|R1], [H2|R2]) :- 
	(H2 == * ; H1 == H2),
	final_state(R1, R2).

depth_limited_search(State, FinalState, _, _, _, Actions, Actions) :- 
	final_state(State, FinalState).

depth_limited_search(CurrState, FinalState, SoFarStates, CurrDepth, MaxDepth, SoFarActions, Actions) :-
	CurrDepth =< MaxDepth,
	length(CurrState, N),
	next_move(CurrState, NextState, N, Action),
	\+ member(NextState, SoFarStates),
	append(SoFarStates, [NextState], NewSoFarStates),
	append(SoFarActions, [Action], NewSoFarActions),
	NewCurrDepth is CurrDepth + 1,
	depth_limited_search(NextState, FinalState, NewSoFarStates, NewCurrDepth, MaxDepth, NewSoFarActions, Actions).

codegen(InitialState, FinalState, Actions) :-
	codegen(InitialState, FinalState, 1, Actions), !. % un-cut here (!) to get all the solutions %

codegen(InitialState, FinalState, MaxDepth, Actions) :-
	depth_limited_search(InitialState, FinalState, [InitialState], 1, MaxDepth, [], Actions).

codegen(InitialState, FinalState, MaxDepth, Actions) :-
	NewMaxDepth is MaxDepth + 1,
	codegen(InitialState, FinalState, NewMaxDepth, Actions).

