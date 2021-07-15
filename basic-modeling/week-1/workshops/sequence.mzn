par int: n;
set of int: LENGTH = 1..n;

array[LENGTH] of var int : x;

constraint forall( i in LENGTH) ( x[i] >= 0);
constraint forall( i in LENGTH) ( x[i] <= 3);
constraint x[1] = 0;
constraint x[n] = 3;
constraint forall (i, j in LENGTH where i = j - 1) (x[i] + x[j] <=3);
constraint forall (i in LENGTH where i mod 3 = 0) (x[i] >= 2);

solve maximize sum (i in LENGTH) (x[i]);

output [show(sum(i in LENGTH) (x[i])),"= ", show(x) , "\n"];