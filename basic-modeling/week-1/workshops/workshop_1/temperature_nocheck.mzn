array[int] of int: readings;
int: start;
int: n = length(readings);
set of int: HOUR = 1..n;
set of int: HOUR0 = 0..n;

enum CHOICE = {heat, strongly_heat, cool, strongly_cool, do_nothing};
array[CHOICE] of int: choice_cost = [1, 5, 3, 9, 0];
array[CHOICE] of int: choice_temp = [1, 4, -2, -5, 0];

%Decision variables
array[HOUR0] of var 25..30: temp;
array[HOUR] of var CHOICE: choices;
array[HOUR] of var int: cost;

constraint temp[0] = start;
constraint forall(h in HOUR)
                 (temp[h] = ((temp[h-1] + readings[h]) div 2) + choice_temp[choices[h]]);
constraint forall (h in HOUR) (cost[h] = choice_cost[choices[h]]);

solve minimize sum (cost);

output["temp = \(temp)\nchoice = \(choices) \ncost = \(sum(cost))"];