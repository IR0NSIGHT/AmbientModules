/*
	Author: IR0NSIGHT

	Description:
		Unit will fire at all nearby enemy aircraft without hitting them.
		Mode 1 (hybrid) will start using lethal fire at <1000m.

	Parameter(s):
		0:	object - AA Gun
		1:	number - mode [0,1], default 0

	Returns:
		nothing

	Examples:
		[myAAGun, 1] call IRN_fnc_aaAmbient;
*/
params [
	["_unit", objNull, [objNull]],
	["_mode",0,[0]]
];
if (!isServer) exitWith {};
if (!canSuspend) exitWith {
	 ["Function can not be called in unsuspendable context. Use 'spawn' instead"] call BIS_fnc_error;
};
_legalModes = [0,1];
if !(_mode in _legalModes) exitWith {
	diag_log ["error ambientAA, unexpected mode ", _mode," should be ",_legalModes];
};
_modeVarName = "irn_amb_aa_mode";
_unit setVariable [_modeVarName,_mode];

//will move dummy target near helo if timeout over, return target
_updateTarget = {
	params["_helo","_unit","_dummies"];
	_dummy = objNull;
	//select correct target, amtching the side
	switch (side _helo) do {
		case west: {_dummy = _dummies#0};
		case east: {_dummy = _dummies#1};
		case independent: {_dummy = _dummies#2};
	};

	_last = _dummy getVariable ["lastMoved",-1];
	if (_last + 2 < time) then {
		_radius = (sizeOf (typeOf _helo)) * 3;
		_center = getPos _helo;
		//add velocity*forward
		_time =(_helo distance _unit)/980; //time the bullet needs to travel
		_lead = ((velocity  _helo) vectorMultiply (_time * 2));
		_center = _center vectorAdd _lead;
		_offset = (vectorNormalized [selectRandom [1,-1],selectRandom [1,-1],0.2]);
		_offset = (_offset vectorMultiply _radius);
		_offset = _center vectorAdd _offset;
		_dummy setPos _offset;
		_helo setVariable ["lastMoved",time];
	};
	//return
	_dummy
};

//is this helo a legitimate target for unit?
_legalHelo = {
	params["_helo","_unit"];
	_out = !isNull _helo && alive _helo && ([side _helo, side _unit] call BIS_fnc_sideIsEnemy) && (getPosATL _helo) select 2 > 20;
	_out
};

_getHelo = {
	params["_unit","_helo","_lastTime","_range"];
	//keep helo if legal, for ~6 seconds
	if (_lastTime + 6 > time && [_helo,_unit] call _legalHelo) exitWith {
		_helo
	};

	//choose new helo
	_helos = ((getPos _unit) nearObjects ["Air",_range]) select {[_x,_unit] call _legalHelo};
	_helos = [_helos, [_unit], {_x distance _input0}, "ASCEND"] call BIS_fnc_sortBy;
	if (count _helos == 0) exitWith {
		objNull;
	};
	_helo = selectRandom [_helos#0,selectRandom _helos]; //either closest one or a random one.
	_helo
};

_i = 0;
_veh = vehicle _unit;
_gunny = gunner _veh;
_gunny setSkill ["aimingAccuracy",1];

//run parallel loop that force fires whenever the gun is aimedAtTarget
[_gunny] spawn {
	params ["_gunny"];
	while {(alive _gunny)} do {
		sleep 0.2;

		_helo = _gunny getVariable ["irn_amb_aa_helo",objNull];
		_target = _gunny getVariable ["irn_amb_aa_target",objNull];
		_muzzle = ((vehicle _gunny) weaponsTurret [0]) select 0;
		if (!isNull _target && alive _helo) then {

			//fire burst while aimed
			vehicle _gunny setVehicleAmmo 1;
			_i = 0;
			_max = random 50 + 25;
			while {vehicle _gunny aimedAtTarget [_target] > 0.8 && _i < _max} do {
				_i = _i + 1;
				vehicle _gunny fireAtTarget [_target,_muzzle];
				sleep 0.01;
			};	
		} else {
			sleep 1;
		};
	};
};

_unit setVariable ["irn_amb_aa",true,true];
_range = 3000;

//create a dummy target for each side
_dummies = [];
{
	_d = createVehicle [_x,[0,0,0]];
	_dummies pushBack _d;
} forEach ["CBA_B_InvisibleTargetAir","CBA_O_InvisibleTargetAir","CBA_I_InvisibleTargetAir"];
_timeStampHelo = time;
_helo = objNull;
while {alive _unit} do {
	(group _unit) setCombatMode "BLUE";

	//timeout if disabled Sim
	while {!simulationEnabled _unit} do {
		sleep 5;
	};
	sleep 1;

	_isHybrid = 1==(_unit getVariable [_modeVarName,0]); //ambient for 1km+, deadly for <1km
	_heloOld = _helo;
	_helo = [_unit, _helo,_timeStampHelo,_range] call _getHelo;
	if !(_helo isEqualTo _heloOld) then {
		_timeStampHelo = time;
	};
	if (isNull _helo) then {
		sleep 2;
		continue;
	};

	//select firemode
	_fireMode = 0;
	if (_isHybrid && _helo distance _unit < (_range/3)) then {_fireMode = 1};

	_target = objNull;
	//choose target
	if (_fireMode == 1) then {
		//hybrid mode and helo is closer than 50% -> direct fire
		(group _unit) setCombatMode "RED";
		_target = _helo;
		_gunny doFire _target;
		_unit enableAI "AUTOTARGET";
		_unit enableAI "TARGET";
	} else {
		//helo is farther than 50% OR not hybrid -> ambient fire
		_target = [_helo,_unit,_dummies] call _updateTarget; 		//get (pseudo) target
		(group _unit) forgetTarget _helo;
		_unit disableAI "AUTOTARGET";
		_unit disableAI "TARGET";

	};

	//set target as var, reveal and watch target.
	_gunny setVariable ["irn_amb_aa_target",_target];
	_gunny setVariable ["irn_amb_aa_helo",_helo];
	_gunny reveal [_target, 4];

	//_gunny doWatch getPos _target;
	_gunny doWatch getPos _target;
};


{
	deleteVehicle _x
} forEach _dummies;
