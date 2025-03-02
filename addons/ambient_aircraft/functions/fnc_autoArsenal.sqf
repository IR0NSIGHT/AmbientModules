/**
	create an ace arsenal on object based on the loadout of units
 */
if (!isServer) exitWith {};

params [
	["_logic",objNull,[objNull]],
	["_units",[],[[]]],
	["_cleanup",false,[false]]
];

_items = flatten (_units apply { flatten (getUnitLoadout [_x, true]) select {typeName _x ==  "STRING" && _x isNotEqualTo ""} });
_crate = createVehicle ["B_supplyCrate_F",position _logic];
[_crate, _items, true /*global*/] call ace_arsenal_fnc_initBox;

if (_cleanup) then {
	_units apply {deleteVehicle _x};
};
