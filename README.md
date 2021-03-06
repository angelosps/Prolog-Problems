# 🧮 Prolog Problems 
 
A collection of problems solved using pure Prolog, or with CSP libraries of ECLiPSe such as `ic` and `branch_and_bound`.  
Prolog system used: [ECLiPSe](http://www.eclipseclp.org/).

## Run Length Encoding
Sequence _encoding_ and _decoding_ according to [Run Length](https://en.wikipedia.org/wiki/Run-length_encoding) standard. Some usage examples are as follows.    
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

Suppose we have a processor of N registers (R<sub>1</sub>, .., R<sub>N</sub>) that are connected in a ring structure.  
That is, we can move the contents of register R<sub>i</sub> to register R<sub>i+1</sub>, for 1 < i < N, and R<sub>N</sub> to R<sub>1</sub> with the `move(i)`, for 1 < i < N, and `move(N)`, respectively. It can also swap the contents of registers R<sub>i</sub> and R<sub>j</sub> with the `swap(i,j)` instruction, where i < j. Now suppose we are given the initial contents of N registers, as well as the desired final contents. The task is to find the _shortest_ sequence of `move` and `swap` instructions that must be executed to achieve the desired transformation. Note that it is possible in the representation of the contents of registers to have, both in the initial and in the final state, the symbol \*, which means, for the initial state "we don't know what is contained in the register", and for the final state "we don't care what is contained in the register".

Some usage examples are as follows.

```
?- codegen([a,b,c,d],[a,d,a,b],L).
L = [move(2),move(1),swap(3,4),swap(2,3)]

?- codegen([a,*,c],[c,a,*],L).
L = [move(1),move(3)]

?- codegen([a,b,c],[a,a,*],L).
L = [move(1)]

?- codegen([a,b,c,d,e,f],[f,f,b,e,a,e],L).
L = [move(2),swap(1,4),move(6),move(1),move(5),swap(4,5)]
```

## Domino

Given a set of dominos, we have to put them in N x M rectangle such that no domino is overlapped with any other and they exactly fit into the rectangle. Note that each domino may be placed in 4 different ways in the frame.  
For example, the domino 

<p align="left">
  <img src="https://github.com/angelosps/Prolog-Problems/blob/main/screenshots/domino2-5.png?raw=true" width="165">
</p>

may be placed as:

<p align="left">
  <img src="https://github.com/angelosps/Prolog-Problems/blob/main/screenshots/domino2-5_4ways.png?raw=true" width="600">
</p>

Given the dominos and the resulting frame, the goal is to find a way to place the dominos to obtain the desired frame.

**Sample test case**

```
%% Given the available dominos %%
dominos([(0,0),(0,1),(0,2),(0,3),(0,4),(0,5),(0,6), 
               (1,1),(1,2),(1,3),(1,4),(1,5),(1,6), 
                     (2,2),(2,3),(2,4),(2,5),(2,6), 
                           (3,3),(3,4),(3,5),(3,6), 
                                 (4,4),(4,5),(4,6), 
                                       (5,5),(5,6),
                                             (6,6)]).
                                             
%% and the final state %%                                             
frame([[3,1,2,6,6,1,2,2],
       [3,4,1,5,3,0,3,6],
       [5,6,6,1,2,4,5,0],
       [5,6,4,1,3,3,0,0],
       [6,1,0,6,3,2,4,0],
       [4,1,5,2,4,3,5,5],
       [4,1,0,2,4,5,2,0]]).
       
%% find a way to put the dominos in order to form the desired frame as stated above %% 
?- put_dominos.
3-1 2 6 6 1 2-2 
    | | | |
3-4 1 5 3 0 3 6
            | | 
5 6-6 1 2-4 5 0
|     |
5 6 4 1 3 3-0 0
  | |   |     | 
6 1 0 6 3 2 4 0 
|     |   | |
4 1-5 2 4 3 5 5
        |     | 
4-1 0-2 4 5-2 0
```

**All test data are located in [/test-data/domino](https://github.com/angelosps/Prolog-Problems/tree/main/test-data/domino). 
First you load the data into eclipse and then the `domino.pl` file, as follows.**

```
?- [domino_test_data].
?- [domino].
```

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

**I also include a *faster* implementation in the `maxclqfast.pl` file.**

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

A number of cars are to be produced on an assembly line where each car is customized with a specific set of options such as air-conditioning, sunroof, navigation, and so on. The assembly line moves through several workstations for installation of these options. The cars cannot be positioned randomly since each of these workstations have limited capacity and need time to set up the options as the assembly line is moving in front of the station. These capacity constraints are formalized using constraints of the form of K out of M,_(at most K cars in each M contiguous in the assembly line must require the option)_. The car sequencing problem is to determine a sequencing of the cars on the assembly line that satisfies the demand constraints for each set of car options and the capacity constraints for each workstation.

```
%% There are six classes. The 1st and 2nd classes will have one car each and the rest of them will have two cars each. %%
classes([1,1,2,2,2,2]).

%% There are five options. Each option is defined via a triad M/K/O, where M and K express the capacity constraint %%
%% of the option (at most K cars in each M contiguous in the assembly line must require the option) and 
%% O is a list of 1 and 0, expressing whether the option is included in the corresponding class (1) or not (0). %%

options([2/1/[1,0,0,0,1,1],
         3/2/[0,0,1,1,0,1],
         3/1/[1,0,0,0,1,0],
         5/2/[1,1,0,1,0,0],
         5/1/[0,0,1,0,0,0]]).
         
?- carseq(S).
S = [1, 2, 6, 3, 5, 4, 4, 5, 3, 6] --> ;
S = [1, 3, 6, 2, 5, 4, 3, 5, 4, 6] --> ;
S = [1, 3, 6, 2, 6, 4, 5, 3, 4, 5] --> ;
S = [5, 4, 3, 5, 4, 6, 2, 6, 3, 1] --> ;
S = [6, 3, 5, 4, 4, 5, 3, 6, 2 ,1] --> ; 
S = [6, 4, 5, 3, 4, 5, 2, 6, 3, 1] --> ;
No
```

**All test data are located in [/test-data/carseq](https://github.com/angelosps/Prolog-Problems/tree/main/test-data/carseq). 
First you load the data into eclipse and then the `carseq.pl` file, as follows.**

```
?- [carseq_data1].
?- [carseq].
```

## Tents Puzzle

We have a rectangular field of given dimensions, let N x M. At certain positions (i,j) in the field, with i from 1 to N and j from 1 to M, there are K trees. We want to place in the field a number of tents at positions such that:
* At least one of the adjacent positions of each tree, horizontally, vertically or diagonally, has a tent.
* No two tents must be located in adjacent positions, neither horizontally, vertically nor diagonally.
* There cannot be a tent in a location where there is a tree.
* For some, not necessarily all, of the rows and columns of the field, maximum numbers of tents that may be present in the row or column, respectively.
* The tents to be placed should be the minimum possible.

We write a `tents/4` predicate, called `tents(RowTents, ColumnTents, Trees, Tents)`, where `RowTents` is a list of the desired total maximum number of tents per row, `ColumnTents` is a list of the desired total maximum number of tents per column, and `Trees` is a list of coordinates of the form Row-Column, where the trees are located.

Some usage examples are as follows.

```
?- tents([0, -1, -1, 3, -1], [1, 1, -1, -1, 1], [1-2, 2-5, 3-3, 5-1, 5-5], Tents). 
Tents=[2-3,3-5,5-2,5-4] --> ; 
Tents=[2-3,3-5,4-2,5-4] --> ; 
Tents=[2-3,3-5,4-1,5-4] --> ; 
Tents=[2-2,3-5,4-1,5-4] --> ;
...
...

?- tents([-1, -1, -1, 2, -1, -1, 2, 1],
         [2, 1, -1, 1, 1, -1, 1, -1, -1, 1, 2, -1],
         [1-4, 1-9, 1-12, 2-1, 2-5, 2-8, 3-1, 3-6, 3-8, 3-12,
          4-5, 4-7, 4-11, 5-3, 5-9, 6-1, 6-7, 6-11, 7-5, 8-10], Tents).
Tents = [2 - 4, 2 - 9, 2 - 12, 3 - 2, 4 - 6, 5 - 1, 6 - 3, 7 - 1, 7 - 6, 8 - 11] --> ; 
Tents = [2 - 4, 2 - 9, 2 - 12, 3 - 2, 4 - 6, 5 - 1, 6 - 3, 7 - 1, 7 - 6, 8 - 9] --> ; 
Tents = [2 - 4, 2 - 9, 2 - 12, 3 - 2, 4 - 6, 5 - 1, 6 - 3, 6 - 6, 7 - 1, 8 - 11] --> ;
...
...
          
?- tents([1, -1, -1, -1, -1, -1, 3, 1, -1, 1, 2, 2, 1],
         [2, 1, -1, 1, 4, 1, 3, -1, 2, 1, 1, 0],
         [2-3, 1-5, 5-4, 4-5, 7-7, 10-6, 2-2, 4-8, 8-5, 9-9,
          1-8, 9-2, 3-3, 1-1, 9-8, 8-7, 10-10, 2-7, 8-6, 4-4, 9-1], Tents).
Tents = [2 - 1, 2 - 4, 2 - 9, 3 - 7, 5 - 5, 8 - 8, 9 - 6, 10 - 2, 11 - 11] --> ;
...
...
```
