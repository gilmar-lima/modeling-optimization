% workshop 2
% select a set of trade negotiation party
enum NEGOTIATOR;
NEGOTIATOR: dummy; 

int: l; % minimum party size
int: u; % maximum party size
int: m; % minimum joint ability

array[NEGOTIATOR] of int: honor;
array[NEGOTIATOR,NEGOTIATOR] of int: joint;

array[NEGOTIATOR] of var bool: selected_honor;
array[NEGOTIATOR] of var bool: selected_party;


constraint sum(n in NEGOTIATOR)(selected_honor[n]) = 1;
constraint sum(n in NEGOTIATOR)(selected_party[n]) >= l;
constraint sum(n in NEGOTIATOR)(selected_party[n]) <= u;
constraint sum(i,j in NEGOTIATOR where i < j)(selected_party[i]*selected_party[j]*joint[i,j]) >= m;
constraint selected_party[dummy] = 0;

var int: obj;
constraint obj = min(n in NEGOTIATOR where selected_party[n])(selected_honor[n]*honor[n]);

var set of NEGOTIATOR : party = { n | n in NEGOTIATOR where selected_party[n]};

solve maximize obj;

% model not working yet
output["party = \(party); \nobj = \(obj)"];


