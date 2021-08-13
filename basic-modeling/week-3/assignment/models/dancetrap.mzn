% Beauty Trap
% Perform the most seductive dance
include "regular.mzn";
include "global_cardinality_low_up.mzn";

enum LEGS = {spin, leap, waltz, curtsey, prep, stand};
enum ARMS = {beckon, out, up, wrapped, neutral};
enum FACE = {smile, wink, batt, think, glow, blank};

int: maxlen;
int: boredom; % how bored each step make the viewer
set of int: STEP = 1..maxlen;
array[LEGS] of int: maxlegs;
array[ARMS] of int: maxarms;
array[FACE] of int: maxface;
array[LEGS,ARMS] of int: dance_value;
array[ARMS,FACE] of int: entice_value;

var STEP: len;
array[STEP] of var LEGS: legs;
array[STEP] of var ARMS: arms;
array[STEP] of var FACE: face;

constraint assert(maxlegs[stand] >= maxlen, "maxlegs[stand] smaller than maxlen");
constraint assert(maxarms[neutral] >= maxlen, "maxarms[neutral] smaller than maxlen");
constraint assert(maxface[blank] >= maxlen, "maxface[blank] smaller than maxlen");
constraint assert(dance_value[stand,neutral] = 0, "incorrect dance_value array");
constraint assert(entice_value[neutral,blank] = 0, "incorrect entice_value array");

%Solution steps:
% 1. Draw the state machines for sequences of moves legs, arms and face.
% 2. Number of occurences in a row will have a separate constaint.
% 3. Number of occurences of each move will be modeled with golbal_constraint function.
% 4. For impossible combinations put a constaint not permiting values less than 0.

constraint regular([legs[s] | s in STEP], 7, card(LEGS), legs_dfa, 1,{7});
%2-spin, 3-leap, 4-waltz, 5-curtsey, 6-prep, 7-stand
array[1..7,LEGS] of 0..7: legs_dfa = 
      [|2,0,4,5,6,7 %1
       |0,0,0,5,6,7 %spin
       |2,0,4,0,0,7 %leap
       |0,0,4,0,0,7 %waltz
       |2,0,4,5,0,7 %curtsey
       |2,3,4,5,6,7 %prep
       |2,0,4,5,6,7|]; %stand

constraint forall(s in 1..maxlen-3) 
                 ((legs[s] == waltz /\ legs[s+1] == waltz /\ legs[s+2] == waltz) ->
                 (not (legs[s+3] == waltz)));

constraint regular([arms[s] | s in STEP], 6, card(ARMS), arms_dfa, 1,{6});
%2-beckon, 3-out, 4-up, 5-wrapped, 6-neutral
array[1..6,ARMS] of 0..6: arms_dfa = 
      [|0,3,4,5,6 %1
       |0,3,4,5,6 %beckon
       |2,0,4,0,6 %out
       |2,3,0,0,6 %up
       |0,3,4,0,6 %wrapped
       |0,3,4,5,6|]; %neutral

constraint regular([face[s] | s in STEP], 7, card(FACE), face_dfa, 1,{7});
%2-smile, 3-wink, 4-batt, 5-think, 6-glow, 7-blank
array[1..7,FACE] of 0..7: face_dfa = 
      [|2,3,4,5,6,7 %1
       |2,3,4,0,6,7 %smile
       |2,3,4,5,6,7 %wink
       |2,3,4,0,6,7 %batt
       |2,3,4,5,6,7 %think
       |2,3,4,5,6,7 %glow
       |2,3,4,5,6,7|]; %blank

constraint forall(s in 1..maxlen-2) 
                 ((face[s] == face[s+1]) /\ (face[s] != blank) ->
                 (not (face[s+2] == face[s+1])));

%Strange combinations and impossible
constraint forall(s in STEP)(dance_value[legs[s],arms[s]] >= 0);
constraint forall(s in STEP)(entice_value[arms[s],face[s]] >= 0);
             
%Number of occurences constraints
constraint global_cardinality_low_up([legs[s] | s in STEP],[l | l in LEGS],[0 | l in LEGS],[maxlegs[l] | l in LEGS]);
constraint global_cardinality_low_up([arms[s] | s in STEP],[a | a in ARMS],[0 | a in ARMS],[maxarms[a] | a in ARMS]);
constraint global_cardinality_low_up([face[s] | s in STEP],[f | f in FACE],[0 | f in FACE],[maxface[f] | f in FACE]);

constraint forall(s in STEP where s > len)(legs[s] == stand);
constraint forall(s in STEP where s > len)(arms[s] == neutral);
constraint forall(s in STEP where s > len)(face[s] == blank);

var int: obj = sum(s in 1..len)(dance_value[legs[s],arms[s]] + entice_value[arms[s],face[s]]) - boredom*len;

solve maximize obj;

output["len = \(len); \nlegs = \(legs); \narms = \(arms); \nface = \(face); \nobj = \(obj);"];