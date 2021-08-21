include "alldifferent.mzn";

par int : n = 8;
par set of int: POSSIBLE_NOTES = 1..n;
par set of int: ORDER = 1..n;

array[ORDER] of var POSSIBLE_NOTES: order;

constraint alldifferent(order);
constraint alldifferent(diffs);

array[1..(n-1)] of var int: diffs = [abs(order[i] - order[i+1]) | i in 1..(n-1)];

solve satisfy;

output["order = \(order);\ndiffs = \(diffs);"];