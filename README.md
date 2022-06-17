# 🧮 Prolog Problems 
 
A collection of problems solved using pure Prolog, or with CSP libraries of ECLiPSe such as `ic` and `branch_and_bound`.  
Prolog system used: [ECLiPSe](http://www.eclipseclp.org/).

## Run Length Encoding
Sequence encoding and decoding according to [Run Length](https://en.wikipedia.org/wiki/Run-length_encoding) standard. Some usage examples are as follows.    
**Decoding**
```
?- decode_rl([(a,3),(b,2),c,(d,4),e], L).
L = [a,a,a,b,b,c,d,d,d,d,e]

?- decode_rl([(f(5,a),7)], L).
L = [f(5,a),f(5,a),f(5,a),f(5,a),f(5,a),f(5,a),f(5,a)]

?- decode_rl([g(X),(h(Y),3),k(Z),(m(W),4),n(U)], L).
L = [g(X),h(Y),h(Y),h(Y),k(Z),m(W),m(W),m(W),m(W),n(U)]
```
**Encoding**
```
?- encode_rl([a,a,a,b,b,c,d,d,d,d,e], L).  
L = [(a,3),(b,2),c,(d,4),e]  

?- encode_rl([f(5,a),f(5,a),f(5,a),f(5,a),f(5,a),f(5,a),f(5,a)], L).  
L = [(f(5,a),7)]  

?- encode_rl([g(X),h(Y),h(Y),h(Y),k(Z),m(W),m(W),m(W),m(W),n(U)], L).  
L = [g(X),(h(Y),3),k(Z),(m(W),4),n(U)]
```

## Codegen

Suppose we have a processor N registers (R<sub>1</sub>, .., R<sub>N</sub>) that are connected in a ring structure.  
That is, we can move the contents of register R<sub>i</sub> to register R<sub>i+1</sub>, for 1 < i < N, and R<sub>N</sub> to R<sub>1</sub> with the `move(i)`, for 1 < i < N, and `move(N)`, respectively. It can also swap the contents of registers R<sub>i</sub> and R<sub>j</sub> with the `swap(i,j)` instruction, where i < j. Now suppose we are given the initial contents of N registers, as well as the desired final contents. The task is to find the _shortest_ sequence of move and swap instructions that must be executed to achieve the desired transformation. Note that it is possible in the representation of the contents of registers to have, both in the initial and in the final state, the symbol \*, which means, for the initial state "we don't know what is contained in the register", and for the final state "we don't care what is contained in the register".

Some usage examples are as follows.

```
?- codegen([a,b,c,d],[a,d,a,b],L).
L = [move(2),move(1),swap(3,4),swap(2,3)]

?- codegen([a,*,c],[c,a,*],L).
L = [move(1),move(3)]

?- codegen([a,b,c],[a,a,*],L).
L = [move(1)]

?- codegen([a,b,c,d,e,f],[f,f,b,e,a,e],L).
L = [move(2),swap(4,6),move(5),swap(4,5),swap(1,5),move(1)]
```

## Domino

## Maximal Clique

The maximal [clique problem](https://en.wikipedia.org/wiki/Clique_problem) solved using Constraint Logic Programming (CLP).  
The predicate `maxclq(N, D, Clique, Size)`, first creates a random graph (using `create_graph` as described below), and then finds the maximal clique for that graph.

**Graph Generation:** The predicate `create_graph(N, D, G)` generates random graphs with **N** nodes and **D** density. 
Density, represents (with a value up to 100) the percentage of edges present in the graph in relation to all possible edges.  

Some usage examples are as follows.

```
?- seed(1), maxclq(8, 80, Clique, Size).
Clique = [2, 4, 5, 6, 7]
Size = 5

?- seed(8231), maxclq(120, 40, Clique, Size).  
Clique = [12, 31, 54, 68, 73, 75, 92, 111]  
Size = 8

?- seed(1), maxclq(800, 2, Clique, Size).
Clique = [1, 107, 272]
Size = 3
```

## Liars Puzzle

There is a group of friends, some of whom are always lying, while the others always tell the truth. All of them know about each other, whether they are liars or not. Each person makes a statement of the form "there are _at least K_ liars in the group". We implement a `liars/2` predicate which, when called with the list of numbers declared by each person as the _minimum number of liars in the group_ as the first argument, returns on the second argument a list indicating what each person in the group is, a liar or not, via an appropriate value, 1 or 0.

Some usage examples are as follows.

```
?- liars([3, 2, 1, 4, 2], Liars).
Liars = [1, 0, 0, 1, 0]

?- liars([9, 1, 7, 1, 8, 3, 8, 9, 1, 3], Liars). 
Liars = [1, 0, 1, 0, 1, 0, 1, 1, 0, 0]

?- liars([12, 3, 9, 15, 8, 9, 0, 15, 9, 6, 14, 6, 3, 3, 9], Liars).
Liars = [1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 0, 0, 1]

?- liars([2, 3, 3, 4], Liars).
No

?- liars([15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15], Liars).
Liars = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
```


## Car Sequencing
## Tents Puzzle
