enum CHOICE = {heat, strongly_heat, cool, strongly_cool, do_nothing};

array[int] of int: readings;
int: start;
int: n = length(readings);
set of int: HOUR = 1..n;
set of int: HOUR0 = 0..n;

array[CHOICE] of par int: choice_cost = [1, 5, 3, 9, 0];
array[CHOICE] of par int: choice_temp = [1, 4, -2, -5, 0];

%Decision variables
array[HOUR0] of var int: temp;
array[HOUR] of var int: choices;



%Minimize cost
%solve minimize 


