% Flag for showing the complete list in output
% set_prolog_flag(answer_write_options, [quoted(true), portray(true), max_depth(100), attributes(portray)]).

%%% Decoding %%%

decode_head((_, 0), []). 				

decode_head((X,N), [X|L]) :-		
	N > 0,
	N1 is N-1,
	decode_head((X,N1), L).

decode_head(X, [X]) :-				
	X \= (_,_).

decode_rl([],[]).

decode_rl([H|T], Decoded) :-		
	decode_head(H, DecodedHead),
	decode_rl(T, DecodedTail),
	append(DecodedHead, DecodedTail, Decoded).

%%% Encoding %%%

find_const_prefix([X], [X], []).

find_const_prefix([X,X|List], [X|Prefix], Rest) :- 
	find_const_prefix([X|List], Prefix, Rest).

find_const_prefix([X,Y|List], [X], [Y|List]) :- 
	X \= Y.

encode_prefix([H|[]], [H]).

encode_prefix([H|T], [(H, N)]) :- 
	length([H|T], N), N > 1.

encode_rl([], []).

encode_rl(L, Encoded) :-
	find_const_prefix(L, Prefix, Rest),
	encode_prefix(Prefix, EncodedPrefix),
	encode_rl(Rest, EncodedRest),
	append(EncodedPrefix, EncodedRest, Encoded).

