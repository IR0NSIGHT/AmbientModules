diag_log ["ambient air traffic module executed with input: ",_this];
params ["_mode","_input"];

_input params [
	"_logic",	//the module
	"_activated", //module activation state
	"_zeused"
];
//parameters are saved in modules namespace:
_timeout = parseNumber (_logic getVariable ["timeout",120]);
_classes =  _logic getVariable ["planes",[]] splitString ",";
_classesWeighted = [];	
//_classes = "B_Heli_Light_01_dynamicLoadout_F,2,B_Plane_Fighter_01_F,1" splitString ",";
_classesWeighted = []; 
for "_i" from 0 to (count _classes -1) step 2 do { 
 _classesWeighted pushBack (_classes#_i); 
 _weight = parseNumber (_classes#(_i+1)); 
 _classesWeighted pushBack _weight; 
};
_side = _logic getVariable ["side",west];
switch _side do {
	case "blufor": {_side = west};
	case "opfor": {_side = east};
	case "ind": {_side = independent};
	case "civ": {_side = civilian};
};
diag_log ["airtraffic module input:",_this];
diag_log["airtraffic module parsed params:",_timeout,_classesWeighted,_side];
if (_activated || _zeused) then {
	diag_log["executing airtraffic module"];
	[_timeout,_classesWeighted,_side] call IRN_fnc_ambPlanes;
};