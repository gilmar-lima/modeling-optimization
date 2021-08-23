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
array[HORSE] of int: beauty;
array[HORSE] of int: speed;
array[COURT,HORSE] of int: enjoy;

array[COURT] of var HORSE0: assigned_horse;
%array[HORSE] of var COURT: horse_to_court;
array[COURT] of var int: joyfullness;

var int: zeroes = if((n-m) < 0)
                  then 0
                  else n-m
                  endif;
var int: objective = sum (c in COURT)(if assigned_horse[c] == 0 
                                      then 0 
                                      else enjoy[c,assigned_horse[c]]
                                      endif);

%Horse must occur once
%constraint global_cardinality(assigned_horse,[h | h in HORSE],[1 | h in HORSE]);
constraint alldifferent_except_0(assigned_horse);

%Filling the joy array
constraint forall(c in COURT)(joyfullness[c] = if assigned_horse[c] == 0 
                                               then 0 
                                               else enjoy[c,assigned_horse[c]]
                                               endif);
%Emperor must enjoy the most                  
constraint forall(c in COURT where c != 1)(joyfullness[1] > joyfullness[c]);

%Some horses can't be assigned
constraint forall(c in COURT)(joyfullness[c] != -1);

%All court members must ride unless horse not available
constraint count(assigned_horse,0,zeroes); 
    
%Higher rank
constraint forall(c1,c2 in COURT where c1 != c2)((rank[c1] > rank[c2]) ->
                                                 ((beauty[assigned_horse[c1]] >= beauty[assigned_horse[c2]]) \/
                                                  (assigned_horse[c2] == 0) \/
                                                  (assigned_horse[c2] == 0 /\ assigned_horse[c1] == 0)
                                                  )
                                                 );

solve maximize objective;

output["horse = \(assigned_horse);\nobjective = \(objective);\njoyfullness =\(joyfullness)"];