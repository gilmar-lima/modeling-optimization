include "global_cardinality.mzn";
include "alldifferent_except_0.mzn";
int: n; % number of court members
set of int: COURT = 1..n;
int: emperor = 1;
array[COURT] of int: rank;
array[COURT] of int: ability;

int: m; % number of horses
set of int: HORSE = 1..m;
set of int: HORSE0 = 0..m;
set of int: COURT0 = 0..n;
array[HORSE] of int: beauty;
array[HORSE0] of int: beauty0 = array1d(HORSE0,[min(beauty)-1]++beauty);
array[HORSE] of int: speed;
array[COURT,HORSE] of int: enjoy;
array[COURT0] of int: ability0 = array1d(COURT0,[max(ability)+1] ++ ability);

array[COURT] of var HORSE0: horse;
array[HORSE] of var COURT0: assigned_court;
array[COURT] of var int: joyfullness;

%Count the number of violations
var int: violations = sum(h1,h2 in HORSE where h1 < h2)(violation(h1,h2));

var int: zeroes = if((n-m) < 0)
                  then 0
                  else n-m
                  endif;

var int: objective = sum (c in COURT)(joyfullness[c]) - 100*violations;

predicate violation(var int: horse1, var int: horse2) = not( (speed[horse1] > speed[horse2]) -> 
                                                        (ability0[assigned_court[horse1]] >= ability0[assigned_court[horse2]] \/ assigned_court[horse1] == 0 \/ (assigned_court[horse1] == 0 /\ assigned_court[horse2] == 0))); 

%Horse must occur once
%constraint global_cardinality(horse,[h | h in HORSE],[1 | h in HORSE]);
constraint alldifferent_except_0(horse);
constraint alldifferent_except_0(assigned_court);

%Filling the joy array
constraint forall(c in COURT)(joyfullness[c] = if horse[c] == 0 
                                               then 0 
                                               else enjoy[c,horse[c]]
                                               endif);
%Emperor must enjoy the most                  
constraint forall(c in COURT where c != 1)(joyfullness[1] > joyfullness[c]);

%Some horses can't be assigned
constraint forall(c in COURT)(joyfullness[c] != -1);

%All court members must ride unless horse not available
constraint count(horse,0,zeroes); 

%Higher rank
constraint forall(c1,c2 in COURT where c1 != c2)((rank[c1] > rank[c2]) ->
                                                 ((beauty0[horse[c1]] >= beauty0[horse[c2]]) \/
                                                  (horse[c2] == 0) \/
                                                  (horse[c2] == 0 /\ horse[c1] == 0)
                                                  )
                                                 );
constraint forall(c in COURT where horse[c] != 0)(assigned_court[horse[c]] = c);
constraint forall(h in HORSE)((not(assigned_court[h] in COURT)) -> (assigned_court[h] = 0));

solve maximize objective;

%var bool: violation_value = violation(5,7);

output["horse = \(horse);\nobjective = \(objective);\nenjoyment = \(joyfullness);\nassigned_court = \(assigned_court)"];

%output["\((speed[5] > speed[7])->(ability0[assigned_court[5]] >= ability0[assigned_court[7]] \/ assigned_court[5] == 0 \/(assigned_court[5] == 0 /\ assigned_court[7] == 0)))\n violation_value = \(violation_value)\n assigned_court = \(assigned_court)"];

%output["horse = \(horse);\nobjective = \(objective);"];