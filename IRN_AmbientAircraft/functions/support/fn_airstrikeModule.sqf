params ["_mode","_input"];

_input params [
	"_logic",	//the module
	"_activated", //module activation state
	"_zeused"
];

if (_activated || _zeused) then {
	[getPos _logic] call IRN_fnc_strikePosition;
};