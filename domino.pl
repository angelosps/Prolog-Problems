/*
%% sample test case %%
dominos([(0,0),(0,1),(0,2),(0,3),(0,4),(0,5),(0,6), 
               (1,1),(1,2),(1,3),(1,4),(1,5),(1,6), 
                     (2,2),(2,3),(2,4),(2,5),(2,6), 
                           (3,3),(3,4),(3,5),(3,6), 
                                 (4,4),(4,5),(4,6), 
                                       (5,5),(5,6), 
                                             (6,6)]). 

frame([[3,1,2,6,6,1,2,2], 
       [3,4,1,5,3,0,3,6], 
       [5,6,6,1,2,4,5,0], 
       [5,6,4,1,3,3,0,0], 
       [6,1,0,6,3,2,4,0], 
       [4,1,5,2,4,3,5,5], 
       [4,1,0,2,4,5,2,0]]).   
*/

put_dominos :-
   dominos(Dominos),
   get_domains(Dominos, AllDomains),
   generate_solution_with_fc_mrv(AllDomains, Solution),
   frame(Frame),
   make_frame(1, Frame, [], NewFrame),
   print_solution(NewFrame,Solution).

%%%%% Makes the solution frame with coordinates %%%%%
make_frame(_,[],F,F).
make_frame(I,[Row|Rest],SoFar,Final) :-
   IPlus is I+1, 
   make_frame(IPlus, Rest, SoFar, RestFrame),
   make_row(I,1,Row,[],HeadFrame),
   append([HeadFrame],RestFrame,Final).

make_row(_, _, [], EncodedRow, EncodedRow).
make_row(I, J, [H|R], SoFar, Result) :-
   JPlus is J+1,
   make_row(I,JPlus,R,SoFar,NewSoFar),
   append([H-(I/J)], NewSoFar, Result).

%%%%% Printing the solution %%%%%
print_solution([],_).

print_solution([LastRow|[]], Solution) :-
   write("\n"),
   print_row(LastRow, Solution),!.

print_solution([Row1,Row2|Rest], Solution) :-
   write("\n"),
   print_row(Row1, Solution),!,
   write("\n"),
   print_between(Row1, Row2, Solution),!,
   print_solution([Row2|Rest], Solution).

print_between([],[],_).

%% member A,C %%
print_between([(A-(X1/Y1))|Rest], [(C-(X3/Y3))|Rest2], Solution) :-
   member((A,C)-(X1/Y1-X3/Y3), Solution),
   write("| "),
   print_between(Rest, Rest2, Solution).

%% member C,A %%
print_between([(A-(X1/Y1))|Rest], [(C-(X3/Y3))|Rest2], Solution) :-
   member((C,A)-(X3/Y3-X1/Y1), Solution),
   write("| "),
   print_between(Rest, Rest2, Solution).

print_between([(A-(X1/Y1))|Rest], [(C-(X3/Y3))|Rest2], Solution) :-
   \+ member((A,C)-(X1/Y1-X3/Y3), Solution),
   \+ member((C,A)-(X3/Y3-X1/Y1), Solution),
   write("  "),
   print_between(Rest, Rest2, Solution).

print_row([],_).
print_row([(A-(_/_))|[]],_) :-
   write(A).

%% member A,B %%
print_row([(A-(X1/Y1)), (B-(X2/Y2))|Rest], Solution) :-
   member((A,B)-(X1/Y1-X2/Y2), Solution),
   (X1/Y1 @< X2/Y2 ->
      write(A),write('-'),write(B),write(' '); 
      write(B),write('-'),write(A),write(' ')),
   print_row(Rest,Solution).

%% member B,A %%
print_row([(A-(X1/Y1)),(B-(X2/Y2))|Rest], Solution) :-
   member((B,A)-(X2/Y2-X1/Y1), Solution),
   (X2/Y2 @< X1/Y1 ->
      write(B),write('-'),write(A),write(' '); 
      write(A),write('-'),write(B),write(' ')),
   print_row(Rest,Solution).

%% print individuals %%
print_row([(A-(_/_)),(B-(X2/Y2))|Rest], Solution) :-
   write(A), write(' '),
   print_row([(B-(X2/Y2))|Rest], Solution).

print_row([_,(B-(X2/Y2))|Rest], Solution) :-
   print_row([(B-(X2/Y2))|Rest], Solution).

%%%%% Generates a valid solution with Forward Checking and MRV heuristic %%%%%
generate_solution_with_fc_mrv([], []). 

generate_solution_with_fc_mrv(AllDomains, [Domino-X|Solution]) :- 
   mrv_var(AllDomains, Domino-X-Domain, RestDomains), 
   member(X, Domain),
   update_domains(X, RestDomains, RestRestDomains),
   generate_solution_with_fc_mrv(RestRestDomains, Solution).

%%%%% Returns the next MRV variable %%%%%
mrv_var([Domino-X-Domain], Domino-X-Domain, []). 

mrv_var([D1-X1-Domain1|SolDom1], Domino-X-Domain, SolDom3) :- 
   mrv_var(SolDom1, D2-X2-Domain2, SolDom2), 
   length(Domain1, N1), 
   length(Domain2, N2), 
   (N1 < N2 -> 
      (X = X1, 
       Domino = D1, 
       Domain = Domain1, 
       SolDom3 = SolDom1) ; 
      (X = X2, 
       Domino = D2, 
       Domain = Domain2, 
       SolDom3 = [D1-X1-Domain1|SolDom2])). 

%%%%% Update the domain for each domino %%%%%
update_domains(_, [], []). 

update_domains(X, [Domino-Y-Domain1|AllDomains], [Domino-Y-Domain2|RestDomains]) :- 
   update_domain(X, Domain1, Domain2), 
   update_domains(X, AllDomains, RestDomains). 

update_domain(X, Domain1, Domain4) :- 
   remove_if_conflicts(X, Domain1, Domain2),
   remove_if_conflicts(X, Domain2, Domain3),
   remove_if_conflicts(X, Domain3, Domain4).

remove_if_conflicts(_, [], []). 

remove_if_conflicts(X1/Y1-X2/Y2, [X1/Y1-X2/Y2|List], List) :- !.

remove_if_conflicts(X1/Y1-_, [X1/Y1-_|List], List) :- !.

remove_if_conflicts(X1/Y1-_, [_-X1/Y1|List], List) :- !.

remove_if_conflicts(_-X2/Y2, [_-X2/Y2|List], List) :- !.

remove_if_conflicts(_-X2/Y2, [X2/Y2-_|List], List) :- !.

remove_if_conflicts(X1/Y1-X2/Y2, [X3/Y3-X4/Y4|List1], [X3/Y3-X4/Y4|List2]) :- 
   remove_if_conflicts(X1/Y1-X2/Y2, List1, List2). 

%%%%% Generates the dominos domains %%%%%
get_domains([],[]).

get_domains([Domino|Others], [Domino-_-Domains|AllDomains]) :- 
   frame(Frame),
   length(Frame, N),
   findall(Domain, get_domain(Domino,Frame,1,N,Domain), Domains),
   get_domains(Others,AllDomains).

%%%%% Generates the domain for each domino %%%%%
get_domain(_,[],_,_,_).

get_domain((A,B), [H1,H2|T], I, N, X1/Y1-X2/Y2) :-
   checkH((A,B), H1, I, 1, X1/Y1-X2/Y2);
   checkV((A,B), H1, H2, I, 1, X1/Y1-X2/Y2); 
   (I2 is I+1, get_domain((A,B),[H2|T],I2,N,X1/Y1-X2/Y2)). 

get_domain((A,B),[H1|[]],I,N,X1/Y1-X2/Y2) :-
   I == N, checkH((A,B),H1,I,1,X1/Y1-X2/Y2).

%%%%% Horizontal Check %%%%%
checkH((A,B),[H1,H2|[]],I,J,X1/Y1-X2/Y2) :-
   ((A,B) == (H1,H2), X1 is I, Y1 is J, X2 is I, Y2 is J+1,!);
   (A \== B, (A,B) \== (H1,H2), (B,A) == (H1,H2), X1 is I, Y1 is J+1, X2 is I, Y2 is J,!).

checkH((A,B),[H1,H2|T],I,J,X1/Y1-X2/Y2) :-
   ((A,B) == (H1,H2), X1 is I, Y1 is J, X2 is I, Y2 is J+1);
   (A \== B, (A,B) \== (H1,H2), (B,A) == (H1,H2), X1 is I, Y1 is J+1, X2 is I, Y2 is J);
   (JPlus is J+1, checkH((A,B),[H2|T],I,JPlus,X1/Y1-X2/Y2)).

%%%%% Vertical Check %%%%%
checkV((A,B),[H1|[]],[H2|[]],I,J,X1/Y1-X2/Y2) :-
   ((A,B) == (H1,H2), X1 is I, Y1 is J, X2 is I+1, Y2 is J,!);
   (A \== B, (A,B) \== (H1,H2), (B,A) == (H1,H2), X1 is I+1, Y1 is J, X2 is I, Y2 is J,!).

checkV((A,B),[H1|T1],[H2|T2],I,J,X1/Y1-X2/Y2) :-
   ((A,B) == (H1,H2), X1 is I, Y1 is J, X2 is I+1, Y2 is J);
   (A \== B, (A,B) \== (H1,H2), (B,A) == (H1,H2), X1 is I+1, Y1 is J, X2 is I, Y2 is J);
   (JPlus is J+1, checkV((A,B),T1,T2,I,JPlus,X1/Y1-X2/Y2)).
