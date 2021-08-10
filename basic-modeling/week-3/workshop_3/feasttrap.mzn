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
%First dish salty
constraint taste[dish[1]] == salty;
%Last dish sweet
constraint taste[dish[len]] == sweet;
%After spicy bland or sweet
constraint forall(i,j in COURSE where j == i+1)((taste[dish[i]] == spicy) -> 
                                                (taste[dish[j]] == bland \/ taste[dish[j]] == sweet));
%After sour bland or unami
constraint forall(i,j in COURSE where j == i+1)((taste[dish[i]] == sour) -> 
                                                (taste[dish[j]] in {bland, umame}));
%No spicy or umami directly after sweet
constraint forall(i,j in COURSE where j == i+1)((taste[dish[i]] == sweet) -> 
                                                (taste[dish[j]] != spicy /\ taste[dish[j]] != umame));
%Betweem hot and cold must be warm
constraint forall(i,j,k in COURSE where j == i+1 /\ k == i+2)((temp[dish[i]] == hot) -> 
                                                            (temp[dish[j]] == warm /\ temp[dish[k]] == cold));

%Two heavy dishes in a row
constraint forall(i,j,k in COURSE where j == i+1 /\ k == i+2)((heavy[dish[i]] /\ heavy[dish[j]]) -> (heavy[dish[k]] == false));

var int: obj = sum(i in COURSE)(value[dish[i]]) + 
               sum(i,j in COURSE where j == i+1)(taste[dish[i]] != taste[dish[j]]) +
               sum(i,j in COURSE where j == i+1)(temp[dish[i]] != temp[dish[j]]) +
               sum(i,j in COURSE where j == i+1)(heavy[dish[i]] != heavy[dish[j]]);

solve maximize obj;



