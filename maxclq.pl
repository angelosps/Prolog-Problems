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
   create_graph(N,D,Graph), %%% You have to include it! %%%
   length(CClique, N),
   CClique #:: -1..0,
   create_transpose_graph(1, N, Graph, CClique, InvGraph),
   constrain(InvGraph),
   SSize #= sum(CClique),
   bb_min(search(CClique,0,first_fail,indomain,complete,[]),
      SSize, bb_options{strategy:restart}),
   Size is -SSize,
   make_clique(CClique, 1, Clique).


%%%%%%%%%%% Make the clique for output %%%%%%%%%%%

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


%%%%%%%%%%% Create the transpose graph %%%%%%%%%%%

create_transpose_graph(N,N,_,_,[]) :- !.

create_transpose_graph(I,N,Graph,Clique,InvGraph) :-
   I < N,
   J is I+1,
   generate_edges(I,J,N,AllEdges),
   get_inverse_edges(AllEdges, Graph, Clique, NonExist),
   append(NonExist, RestNonExist, InvGraph),
   Iplus is I + 1,
   create_transpose_graph(Iplus,N,Graph,Clique,RestNonExist).


generate_edges(I, J, N, [(I-J)|Edges]) :-
   J =< N, Jplus is J + 1,
   generate_edges(I, Jplus, N, Edges),!.

generate_edges(_,_,_,[]) :- !.


get_inverse_edges([], _, _, []) :- !.

get_inverse_edges([(X-Y)|Rest], Graph, Clique, [(Xth-Yth)|Res]) :-
   \+ member((X-Y), Graph), 
   getN(Clique, X, Xth),
   getN(Clique, Y, Yth),
   get_inverse_edges(Rest,Graph,Clique,Res).

get_inverse_edges([Edge|Rest], Graph, Clique, Res) :-
   get_inverse_edges(Rest, Graph, Clique, Res). 


getN([H|_], 1, H) :- !.

getN([_|R], N, Result) :-
   N > 1,
   NN is N-1,
   getN(R,NN,Result).


constrain([]) :- !.

constrain([(X-Y)|Rest]) :-
   X + Y #\= -2,
   constrain(Rest).
