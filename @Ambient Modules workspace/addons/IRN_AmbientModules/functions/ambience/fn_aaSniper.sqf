/*
	Author: IR0NSIGHT

	Description:
		Will uncover all air assets to unit and tell unit to fire at enemy air assets. Must be spawned, will suspend.

	Parameter(s):
		0:	object - AI controlled object or Ai itself.

	Returns:
		nothing

	Examples:
		[myHMG] call IRN_fnc_aaSniper;
*/
if (!canSuspend) exitWith {
	 ["Function can not be called in unsuspendable context. Use 'spawn' instead"] call BIS_fnc_error;
};

params [["_unit", objNull,[objNull]]];
if (isNull _unit) exitWith {
	["Unit is null."] call BIS_fnc_error;
};
_run = true;
_controlVar = "IRN_aaSniper_on";
_radiusVar = "IRN_fnc_aaSniper";
_unit setVariable [_controlVar,true, true]; //control var
_unit setVariable [_radiusVar,2000, true];
_slep = 4;
{
	_unit setSkill [_x,1];
} forEach ["general","aimingAccuracy","aimingSpeed","spotTime","aimingShake","spotDistance"];
	
while {_run} do {

	_run = alive _unit && _unit getVariable [_controlVar,true];
	_radius = _unit getVariable [_radiusVar,2000];
	_air = ((getPos _unit) nearObjects ["Air",2000]) select {alive _x && [side _x, side _unit] call BIS_fnc_sideIsEnemy};

	//sleep till air assets > zero
	if (count _air == 0) then {sleep 2*_slep; continue;};
	_t = selectRandom _air;

	//fire at air asset
	(gunner _unit) doTarget _t;
	(gunner _unit) doFire _t;
	sleep _slep/2 + random _slep;
}