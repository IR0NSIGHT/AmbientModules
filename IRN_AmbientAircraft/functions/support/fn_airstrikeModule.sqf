params ["_mode","_input"];

_input params [
	"_logic",	//the module
	"_activated", //module activation state
	"_zeused"
];

diag_log ["airstrike module input:",_this];
if (_activated || _zeused) then {
	diag_log["executing airstrike module"];
	[getPos _logic] call IRN_fnc_strikePosition;
};