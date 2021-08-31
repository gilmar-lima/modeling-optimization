include "alldifferent_except_0.mzn";

int: n; % number of court members
set of int: COURT = 1..n;
set of int: COURT0 = 0..n;
int: emperor = 1;
array[COURT] of int: rank;
array[COURT] of int: ability;
array[COURT0] of int: ability0 = array1d(COURT0,[max(ability)+1] ++ ability);

int: m; % number of horses
set of int: HORSE = 1..m;
set of int: HORSE0 = 0..m;
array[HORSE] of int: beauty;
array[HORSE0] of int: beauty0 = array1d(HORSE0,[min(beauty)-1]++beauty);
array[HORSE] of int: speed;
array[COURT,HORSE] of int: enjoy;

array[COURT] of var HORSE0: horse;
array[HORSE] of var COURT0: horse_to_court;
array[COURT] of var int: joyfullness;

constraint alldifferent_except_0(horse);
constraint alldifferent_except_0(horse_to_court);

%Filling the joy array
constraint forall(c in COURT)(joyfullness[c] = if horse[c] == 0 
                                               then 0 
                                               else enjoy[c,horse[c]]
                                               endif);
%Some horses can't be assigned
constraint forall(c in COURT)(joyfullness[c] != -1);

%All court members mus ride
var int: sum_horses_assigned = sum(c in COURT)(if horse[c] == 0 then 0 else 1 endif);
constraint (m >= n) -> (sum_horses_assigned == n);
constraint (m < n) -> (sum_horses_assigned == m);
                                               
%Emperor must enjoy the most                  
constraint forall(c in COURT where c != 1)(joyfullness[emperor] > joyfullness[c]);

%Higher rank
constraint forall(c1,c2 in COURT where c1 != c2)((rank[c1] > rank[c2]) ->
                                                 ((beauty0[horse[c1]] >= beauty0[horse[c2]]) \/
                                                  (horse[c2] == 0) \/
                                                  (horse[c2] == 0 /\ horse[c1] == 0)
                                                 )
                                               );
                                              
%Fill the horse to court
constraint forall(c in COURT where horse[c] != 0)(horse_to_court[horse[c]] = c);
                                                                                            
predicate violation(var int: horse1, var int: horse2) = not( (speed[horse1] > speed[horse2]) -> 
                                                        (ability0[horse_to_court[horse1]] >= ability0[horse_to_court[horse2]] \/ horse_to_court[horse1] == 0 \/ (horse_to_court[horse1] == 0 /\ horse_to_court[horse2] == 0))); 

%Count the number of violations
var int: violations = sum(h1,h2 in HORSE where h1 != h2)(violation(h1,h2));
                                               
var int: objective = sum (c in COURT)(joyfullness[c]) - 100*violations;

solve maximize objective;

%output["horse = \(horse);\nobjective = \(objective);\nviolations = \(violations);\nhorse_to_court = \(horse_to_court);\n joyfullness = \(joyfullness)\nsum_horses_assigned= \(sum_horses_assigned)"];
output["horse = \(horse);\nobjective = \(objective);"];