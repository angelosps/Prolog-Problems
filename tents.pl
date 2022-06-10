:- lib(ic).
:- lib(branch_and_bound).

tents(RowTents, ColumnTents, Trees, Tents) :-
	length(RowTents, N), 
	length(ColumnTents, M),
	make_tents(N, M, Tents2D),
	flatten_tents(Tents2D, LinearTents),
	at_least_one_tent(N,M,Trees,Tents2D),
	no_adjacent_tents(Tents2D),
	constrain_trees(Trees, Tents2D),
	constrain_rows(RowTents, Tents2D),
	constrain_columns(1, ColumnTents, Tents2D),
	Sum #= sum(LinearTents),
	bb_min(search(LinearTents,0,most_constrained,indomain_min,complete,[]),
         Sum, bb_options{strategy:restart, solutions: all}),
	make_sol(1, Tents2D, Tents).

flatten_tents([],[]) :- !.

flatten_tents([H|R], LinearTents) :-
	flatten_tents(R, RestTents),
	append(H, RestTents, LinearTents).

make_sol(_,[],[]) :- !.

make_sol(I, [Row|Rest], Sol) :-
	II is I+1,
	make_sol(II, Rest, RestSol),
	make_sol_row(I, 1, Row, RowSol),	
	append(RowSol, RestSol, Sol).

make_sol_row(_,_,[],[]) :- !.

make_sol_row(I, J, [H|R], [(I-J)|Sol]) :-
	H == 1, !, JJ is J+1,
	make_sol_row(I, JJ, R, Sol).

make_sol_row(I, J, [H|R], Sol) :-
	H == 0,
	JJ is J+1,
	make_sol_row(I, JJ, R, Sol).

make_tents(0, _, []) :- !.

make_tents(N, M, [NewRow|Tents]) :-
	N >= 1,
	NN is N-1,
	length(NewRow, M),
	NewRow #:: 0..1,
	make_tents(NN, M, Tents).

%%%%%%%%% Each row has no more than allowed tents %%%%%%%%%%

constrain_rows([], []) :- !.

constrain_rows([-1|[]], [_|[]]) :- !.

constrain_rows([RowsMax|[]], [TentsRow|[]]) :- 
	RowsMax \== -1,
	sum(TentsRow) #=< RowsMax, !.

constrain_rows([-1|Rest], [_|TentsRest]) :-
	constrain_rows(Rest, TentsRest), !.

constrain_rows([RowsMax|Rest], [TentsRow|TentsRest]) :-
	RowsMax \== -1,
	sum(TentsRow) #=< RowsMax,
	constrain_rows(Rest, TentsRest).

%%%%%%% Each column has no more than allowed tents %%%%%%%%

constrain_columns(_, [-1|[]], _) :- !.

constrain_columns(M, [ColsMax|[]], Tents) :-
	ColsMax \== -1, 
	get_column(1, M, Tents, Column, Tents),
	sum(Column) #=< ColsMax, !.

constrain_columns(M, [-1|Rest], Tents) :-
	MM is M+1,
	constrain_columns(MM, Rest, Tents).

constrain_columns(M, [ColsMax|Rest], Tents) :-
	ColsMax \== -1, 
	get_column(1, M, Tents, Column, Tents),
	sum(Column) #=< ColsMax,
	MM is M+1,
	constrain_columns(MM, Rest, Tents).

get_column(_, _, _, [], []) :- !.

get_column(I, M, Tents, [ColItem|ColumnItems], [TentsRow|TentsRest]) :-
	II is I+1,
	get_column_item(M, TentsRow, ColItem),
	get_column(II, M, Tents, ColumnItems, TentsRest).

get_column_item(1, [H|_], H) :- !.

get_column_item(M, [_|R], ColItem) :-
	MM is M-1,
	get_column_item(MM, R, ColItem).

constrain_trees([],_) :- !.

constrain_trees([(I-J)|RestTrees], Tents) :-
	get_item((I-J), Tents, TreePos),
	TreePos #= 0, %% no tent on a tree %%
	constrain_trees(RestTrees, Tents).

at_least_one_tent(_,_,[],_) :- !.

at_least_one_tent(N,M,[(I-J)|RestTrees], Tents) :-
	constrain_neighbors(N,M,I-J,Tents),
	at_least_one_tent(N,M,RestTrees,Tents).

constrain_neighbors(N, M, (I-J), Tents) :-
	get_up(N,M,(I-J),Tents,Up),
	get_down(N,M,(I-J),Tents,Down),
	get_left(N,M,(I-J),Tents,Left),
	get_right(N,M,(I-J),Tents,Right),
	get_diag_up_left(N,M,(I-J),Tents,DiagUpLeft),
	get_diag_up_right(N,M,(I-J),Tents,DiagUpRight),
	get_diag_down_left(N,M,(I-J),Tents,DiagDownLeft),
	get_diag_down_right(N,M,(I-J),Tents,DiagDownRight),

	Neighbors = [Up, Down, Left, Right, DiagUpLeft, DiagUpRight, DiagDownLeft, DiagDownRight],
	
	sum(Neighbors) #>= 1.

%%% Get Up tile %%%
get_up(_,_,(I-_),_,0) :-
	I == 1, !.

get_up(_,_,(I-J),Tents,Up) :-
	Iup is I-1,
	get_item((Iup-J), Tents, Up).

%%% Get Down tile %%%
get_down(N,_,(I-_),_,0) :-
	I == N, !.

get_down(_,_,(I-J),Tents,Down) :-
	Idown is I+1,
	get_item((Idown-J), Tents, Down).

%%% Get left tile %%%
get_left(_,_,(_-J),_,0) :-
	J == 1, !.

get_left(_,_,(I-J),Tents,Left) :-
	Jleft is J-1,
	get_item((I-Jleft), Tents, Left).

%%% Get right tile %%%
get_right(_,M,(_-J),_,0) :-
	J == M, !.

get_right(_,_,(I-J),Tents,Right) :-
	Jright is J+1,
	get_item((I-Jright), Tents, Right).

%%% Get diagonal up left tile %%%
get_diag_up_left(_,_,(I-J),_,0) :-
	((I == 1 ; J == 1)), !.

get_diag_up_left(_,_,(I-J),Tents,DiagUpLeft) :-
	Iup is I-1,
	Jleft is J-1,
	get_item((Iup-Jleft), Tents, DiagUpLeft).

%%% Get diagonal up right tile %%%
get_diag_up_right(_,M,(I-J),_,0) :-
	((I == 1 ; J == M)), !.

get_diag_up_right(_,_,(I-J),Tents,DiagUpRight) :-
	Iup is I-1,
	Jright is J+1,
	get_item((Iup-Jright), Tents, DiagUpRight).

%%% Get diagonal down left tile %%%
get_diag_down_left(N,_,(I-J),_,0) :-
	(I == N ; J == 1), !.

get_diag_down_left(_,_,(I-J),Tents,DiagDownLeft) :-
	Idown is I+1,
	Jleft is J-1,
	get_item((Idown-Jleft), Tents, DiagDownLeft).

%%% Get diagonal down right tile %%%
get_diag_down_right(N,M,(I-J),_,0) :-
	(I == N ; J == M), !.

get_diag_down_right(_,_,(I-J),Tents,DiagDownRight) :-
	Idown is I+1,
	Jright is J+1,
	get_item((Idown-Jright), Tents, DiagDownRight).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

get_row(1, [H|_], H) :- !.

get_row(I, [_|R], Row) :-
	I > 1,
	II is I-1,
	get_row(II, R, Row).

get_item((I-J), Tents, Item) :-
	get_row(I, Tents, Row),
	get_column_item(J, Row, Item).

no_adjacent_tents(Tents) :-
	constrain_horiz(Tents),
	constrain_vert(Tents).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

constrain_horiz([]) :- !.

constrain_horiz([Row|Rest]) :-
	constrain_row(Row),
	constrain_horiz(Rest).

constrain_row([_|[]]) :- !.

constrain_row([I,II|Rest]) :-
	I + II #=< 1,
	constrain_row([II|Rest]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

constrain_vert([_|[]]) :- !.

constrain_vert([Row1,Row2|Rest]) :-
	constrain_cols(Row1, Row2),
	constrain_vert([Row2|Rest]).

constrain_cols([H1|[]], [H3|[]]) :-
	%% just vertical check %%
	H1 + H3 #=< 1, !. 	%% vertical constrain %%

constrain_cols([H1, H2|[]], [H3, H4|[]]) :-
	H1 + H3 #=< 1, 		%% vertical constrain %%
	H1 + H4 #=< 1,		%% left diag constrain %%
	H2 + H3 #=< 1, !.	%% right diag constrain %%

constrain_cols([H1, H2|T1], [H3, H4|T2]) :-
	H1 + H3 #=< 1, 	%% vertical constrain %%
	H1 + H4 #=< 1,	%% left diag constrain %%
	H2 + H3 #=< 1,	%% right diag constrain %%
	constrain_cols([H2|T1], [H4|T2]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
