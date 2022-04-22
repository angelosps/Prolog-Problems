%%%%%%%%%%%    Create random graph    %%%%%%%%%%%

create_graph(NNodes, Density, Graph) :-
   cr_gr(1, 2, NNodes, Density, [], Graph).

cr_gr(NNodes, _, NNodes, _, Graph, Graph).
cr_gr(N1, N2, NNodes, Density, SoFarGraph, Graph) :-
   N1 < NNodes,
   N2 > NNodes,
   NN1 is N1 + 1,
   NN2 is NN1 + 1,
   cr_gr(NN1, NN2, NNodes, Density, SoFarGraph, Graph).
cr_gr(N1, N2, NNodes, Density, SoFarGraph, Graph) :-
   N1 < NNodes,
   N2 =< NNodes,
   rand(1, 100, Rand),
   (Rand =< Density ->
      append(SoFarGraph, [N1 - N2], NewSoFarGraph) ;
      NewSoFarGraph = SoFarGraph),
   NN2 is N2 + 1,
   cr_gr(N1, NN2, NNodes, Density, NewSoFarGraph, Graph).

rand(N1, N2, R) :-
   random(R1),
   R is R1 mod (N2 - N1 + 1) + N1.


:- lib(ic).
:- lib(branch_and_bound).

maxclq(N,D,Clique,Size) :-
   create_graph(N,D,Graph),
   length(CClique, N),
   CClique #:: -1..0,
   merge_sort(Graph, SortedGraph),
   create_transpose_graph(1,2,N,SortedGraph,InvGraph),
   constrain(InvGraph,CClique),
   SSize #= sum(CClique),
   bb_min(search(CClique,0,first_fail,indomain,complete,[]),
      SSize, bb_options{strategy:restart}),
   Size is -SSize,
   make_clique(CClique, 1, Clique).

%%%%%%%%%%% Transpose Graph %%%%%%%%%%%

create_transpose_graph(I, _, N, _, []) :- I == N, !.

create_transpose_graph(I,J,N,[],[(I-J)|InvGraph]) :-
   I < N, J =< N,
   JJ is J+1, 
   create_transpose_graph(I,JJ,N,[],InvGraph).

create_transpose_graph(I,J,N,[], InvGraph) :-
   I < N, J > N,
   II is I+1,
   JJ is II+1, 
   create_transpose_graph(II,JJ,N,[],InvGraph).

create_transpose_graph(I, J, N, [(GI-GJ)|RestGraph], InvGraph) :-
   I < N, J > N,
   II is I+1,
   JJ is II+1, 
   create_transpose_graph(II,JJ,N,[(GI-GJ)|RestGraph],InvGraph).

create_transpose_graph(I, J, N, [(GI-GJ)|RestGraph], InvGraph) :-
   I < N, J =< N,
   (I-J) == (GI-GJ),
   JJ is J+1, 
   create_transpose_graph(I,JJ,N,RestGraph,InvGraph).

create_transpose_graph(I, J, N, [(GI-GJ)|RestGraph], [(I-J)|InvGraph]) :-
   I < N, J =< N,
   (I-J) \== (GI-GJ),
   JJ is J+1, 
   create_transpose_graph(I,JJ,N,[(GI-GJ)|RestGraph],InvGraph).


make_clique([], _, []) :- !.

make_clique([Node|Rest], I, Clique) :-
   Node == -1,
   II is I + 1,
   make_clique(Rest, II, RestClique),
   append([I], RestClique, Clique).

make_clique([Node|Rest], I, Clique) :-
   Node == 0,
   II is I + 1,
   make_clique(Rest, II, Clique).


getN([H|_], 1, H) :- !.

getN([_|R], N, Res) :-
   NN is N-1,
   getN(R,NN,Res).


constrain([],_) :- !.

constrain([(X-Y)|Rest], Clique) :-
   getN(Clique,X,Xth),
   getN(Clique,Y,Yth),
   Xth + Yth #\= -2,
   constrain(Rest,Clique).

%%%%%%%%%%% Merge Sort %%%%%%%%%%%

merge_sort([], []).
merge_sort([X], [X]).          
merge_sort(Unsorted, Sorted) :- 
   partition(Unsorted,L, R),
   sort(L,L1),                   
   sort(R,R1),                   
   mergeS(L1,R1,Sorted).

partition([],[],[]). 
partition([X],[X],[]).
partition([X,Y|L], [X|Xs], [Y|Ys]) :- 
   partition(L,Xs,Ys).

mergeS([],[],[]).        
mergeS([],[Y|Ys],[Y|Ys]).       
mergeS([X|Xs],[],[X|Xs]).        

mergeS([X|Xs], [Y|Ys], [Lo,Hi|Zs]) :-  
    compare(X,Y,Lo,Hi),                
    mergeS(Xs,Ys,Zs).

compare(X, Y, X, Y) :- 
   X @=< Y. 

compare(X, Y, Y, X) :- 
   X @> Y.
