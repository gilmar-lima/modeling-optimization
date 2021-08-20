include "alldifferent.mzn";
include "inverse.mzn";

par int : n = 8;
par set of int: NOTES = 1..n;
par set of int: POSITION = 1..n;

array[POSITION] of var NOTES: order;
array[NOTES] of var POSITION: posn;
array[1..(n-1)] of var POSITION: dposn;

constraint alldifferent(order);
constraint alldifferent([abs(order[i] - order[i+1]) | i in 1..(n-1)]);
constraint abs(posn[1] - posn[n]) == 1;
constraint inverse(order,posn);
constraint inverse(diffs,dposn);

array[1..(n-1)] of var int: diffs = [abs(order[i] - order[i+1]) | i in 1..(n-1)];
constraint dposn[n-1] == min(posn[1],posn[n]);

solve satisfy;

output["order = \(order);\ndiffs = \(diffs);\nposn = \(posn);\ndposn = \(dposn);"];