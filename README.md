# 🧮 Prolog Problems 
 
A collection of problems solved using pure Prolog, or with CSP libraries of ECLiPSe such as `ic` and `branch_and_bound`.  
Prolog system used: [ECLiPSe](http://www.eclipseclp.org/).

### Run Length Encoding
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

### Codegen
### Domino

### Maximal Clique

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

### Liars
### Car Sequencing
### Tents Puzzle
