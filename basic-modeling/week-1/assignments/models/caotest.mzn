include "alldifferent.mzn";

var 1..9: C;
var 0..9: A;
var 0..0: O;
var 1..9: Z;
var 0..9: H;
var 0..9: I;
var 1..9: P;
var 1..9: T;
var 0..9: E;
var 0..9: S;

constraint alldifferent([C,A,O,Z,H,I,P,T,E,S]);
constraint P = 3*Z;
constraint 100*C+10*A+1*O
          +100*Z+10*H+1*I
          +100*C+10*A+1*O
                +10*P+1*I
        = 1000*T+100*E+10*S+1*T;
        
solve satisfy;
%output["C = \(C);\nA = \(A);\nO = \(O);\nZ = \(Z);\nH = \(H);\nI = \(I);\nP = \(P);\nT = \(T);\nE = \(E);\nS = \(S);\n"]