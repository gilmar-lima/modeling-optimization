par int: n = 10;
set of int: LENGTH = 1..n;

array[LENGTH] of var int : x;

constraint forall( i in LENGTH) ( x[i] >= 0);
constraint forall( i in LENGTH) ( x[i] <= 9);
constraint forall( i, j in LENGTH where i < j) ( x[i] <= x[j] );
constraint sum( i in LENGTH) ( x[i] ) = product( i in LENGTH) ( x[i] );

output ["x= ", show(x) , "\n"];