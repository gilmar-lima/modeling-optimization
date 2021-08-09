% Beauty Trap
% Create the most magnificient feast 
include "global_cardinality.mzn";
include "alldifferent.mzn";

enum DISH;
enum TASTE = {spicy, sour, salty, sweet, umame, bland};
enum TEMP = {hot, cold, warm};

array[DISH] of TASTE: taste;
array[DISH] of TEMP: temp;
array[DISH] of bool: heavy;
array[DISH] of int: value;

int: len; % length of banquet
set of int: COURSE = 1..len;


array[COURSE] of var DISH: dish;

%Dishes must occur once
constraint alldifferent(dish);
%No same taste in a row
constraint forall(i,j in COURSE where j == i+1)(taste[dish[i]] != taste[dish[j]]);

