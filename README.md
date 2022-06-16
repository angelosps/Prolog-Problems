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
### Liars
### Car Sequencing
### Tents Puzzle
