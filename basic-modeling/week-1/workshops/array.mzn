par int: n = 10;
set of int: LENGTH = 1..n;

array[LENGTH] of var int : x;

constraint forall( i in LENGTH) ( x[i] >= 0);
constraint forall( i in LENGTH) ( x[i] <= 9);

output ["x= ", show(x) , "\n"];