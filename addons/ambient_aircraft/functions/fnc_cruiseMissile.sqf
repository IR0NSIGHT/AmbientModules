/* 
*	@Author: IR0NSIGHT 
*	@Date: 2022-06-05 15:05:20 
*	@Last Modified time: 2022-06-05 15:05:20 
*	 
*	Description: 
*		Spawns a cruisemissile that will follow the terrain and hit the target.
*		Make sure the spawnpoint of the cruisemissile is ~5m above anything it could collide with.
* 
*	Environment: 
*		SERVER, SUSPENDABLE 
*		 
*	Parameter(s): 
*		0: can be of
*			object 		- target object
*			positionASL	- target position 
*		 
*		1: can be of (optional, default [-5000,-5000,1000])
*			object		- spawn above object (vertical start)
*			positionASL - spawn position for missile 
*
*	Returns: 
*		nothing
* 
*	Examples: 
*		[targetTruck_01] spawn FUNC(cruiseMissile);
*		[[0,800,2222],missile_boat_01] spawn FUNC(cruiseMissile);
*/

//############### cruise missile
//###### helper functions
#include "script_component.hpp"

//rotate missile towards this posASL
_fn_headTowards = {
	params ["_missile","_wp"];
	_missilePosASL = getPosWorld _missile;
	_dirWp = vectorNormalized (_missilePosASL vectorFromTo _wp);
	_vectorForward = vectorNormalized (vectorDir _missile);
	_dot = _dirWp vectorDotProduct _vectorForward;
	//systemChat ("dot="+str _dot);
	_angle = acos (_dirWp vectorCos _vectorForward);
	if (_angle > 16) then {	//why 16??
		//_h = createVehicle ["Sign_Sphere200cm_F",_missilePosASL];
		//_h setPosWorld _missilePosASL;
		_diff =  (vectorNormalized (_dirWp vectorDiff vectorDir _missile))vectorMultiply 0.3;
		_dirWp = vectorNormalized (vectorDir _missile vectorAdd _diff);
	};
	//cap how fast the missile can turn

	_sideV = [1,0,0];
	if (abs (_sideV vectorDotProduct _dirWp) > 0.7) then {
		_sideV = [0,1,0];
	};
	_up = _dirWp vectorCrossProduct [1,0,0];
	_missile setVectorDirAndUp [
		_dirWp,
		_up
	];
};

//height above sealevel. no negative values.
_fn_getTerrainHeight = {
	params ["_pos"];
	(0 max (getTerrainHeightASL _pos))
};

//reject incorrect environment
if (!isServer) exitWith {
	["must be run on server"] call BIS_fnc_error;
};
if (!canSuspend) exitWith {
	["must be suspendable environment"] call BIS_fnc_error;
};

//#### gameloop
params [
	["_targetASL",[],[[],objNull],3],
	["_spawnPosASL",[-5000,-5000,100],[[], objNull],3],
	["_altitude",40,[-1]]
];
_altitude = _altitude max 35;
//reject nil target
if (_targetASL isEqualTo []) exitWith {
	["invalid target position."] call BIS_fnc_error;
};
//target is object
if (_targetASL isEqualType objNull) then {
	_targetASL = getPosASL _targetASL;
};

//spawnpos is object
if (_spawnPosASL isEqualType objNull) then {
	_objectHeight = _spawnPosASL call BIS_fnc_boundingBoxDimensions;
	_originObj = _spawnPosASL;
	_spawnPosASL = (getPosWorld _spawnPosASL) vectorAdd [0,0,2*_objectHeight#2];
};

if (_spawnPosASL#2<0) then {
	_spawnPosASL set [2,5];	//under water launch
};

//spawn missile
private ["_missile","_nextWP"];
_missile = objNull;	//shut up linter, its not undefined
isNil {
	_missile = createVehicle ["ammo_Missile_Cruise_01",[-5000,-5000,1000]];
};

_missile setVectorDirAndUp [
	[0,0,1],[1,0,0]
];
_missile setVelocity [0,0,20];
_missile setPosWorld _spawnPosASL;

// spawn anchor object
_anchor = createVehicle ["Sign_Pointer_Blue_F", _targetASL];
_anchor setPosASL _targetASL;
_anchor hideObjectGlobal true;
{
    [_x, [[_anchor], true]] remoteExec ["addcuratorEditableObjects", 2, false];
} forEach allCurators;



//ZEUS information while anchor is selected
[
    _anchor,
    {
        params [
            "_missile",
            "_targetASL"
        ];
		_dist = round ((getPosASL _missile) distance2D _targetASL);
		_dir = (_targetASL getDir (getPosASL _missile));
        player sideChat ("cruise missile");
        player sideChat ("distance to target: " + str _dist);
		player sideChat ("missile incoming from " + str _dir);
    }, 
    [
        _missile,
		_targetASL
    ],
    5
] remoteExec [QFUNC(zeusSelectedCallback), 2, false];

_flyUpwards = {
	params ["_missile","_targetASL","_altitude","_fn_getTerrainHeight","_fn_headTowards","_anchor","_handle"];
	diag_log["do UP MODE"];
	_missilePos = getPosWorld _missile;
	_dir = (vectorNormalized(_missilePos vectorFromTo _targetASL)) vectorMultiply 10;
	_nextWP = _dir vectorAdd  _missilePos;
	_nextWP set [2,([_missilePos] call _fn_getTerrainHeight) + _altitude];
	//home towards next wp

	if (isNull _missile || (getPosASL _missile # 2) > _altitude) then {
		_missile setVariable ["STATE","TARGET"];
		diag_log["switch to TARGET MODE"];
	};

	_nextWP
};

_flyTarget = {
	params ["_missile","_targetASL","_altitude","_fn_getTerrainHeight","_fn_headTowards","_anchor","_handle"];
	diag_log["do TARGET MODE"];
	//fly towards a point 100m towards the target, always at _altitude above ground
	_missilePosASL = getPosWorld _missile;
	_missile setVectorUp surfaceNormal _missilePosASL;
	_dir = (_missilePosASL vectorFromTo _targetASL);
	_distanceToTarget = _missilePosASL distance2D _targetASL;
	_wpOffset = 200 min _altitude*4;
	//calculate next wp
	_nextWP = (getPosWorld _missile) vectorAdd (_dir vectorMultiply (_wpOffset min _distanceToTarget));
	_distanceToTarget;
	_height = _altitude;

	//MODULATE ALTITUDE 
	if (_altitude > 200) then {	//no terrain skimming execpt if necessary
		_height = _altitude max (([_nextWP] call _fn_getTerrainHeight) + 50);
	} else {
		_height = ([_nextWP] call _fn_getTerrainHeight) + _altitude;
		if (surfaceIsWater _nextWP) then {	//fly higher right before going into dive onto target. otherwise might hit ground to early (waves or hills)
			_height = _altitude/3 max 20;
		};	
	};

	// SPECIAL MOVES NEAR TARGET
	if (_distanceToTarget < 600) then {	//arch upwards near target
		_height = _height max 150;
	};
	_nextWP set [2,_height];
	_dMax = 400 max (_altitude min 1000);
	if (_distanceToTarget < _dMax) then { //arch downwards directly at target
		_nextWP = _targetASL;
	};

	if (isNull _missile) then {
		_handle call CBA_fnc_removePerFrameHandler;
		deleteVehicle _anchor;
		deleteVehicle HELPER;
		diag_log ["exit missile thread"];
	};
	
	_nextWP
};

//### go vertical into the sky until reaching 100m height
_missile setVariable ["STATE","UP"];
_handle = [{
    params ["_args", "_handle"];
	_args params ["_missile","_targetASL","_altitude","_fn_getTerrainHeight","_fn_headTowards","_anchor","_flyUpwards","_flyTarget"];
	_state = _missile getVariable ["STATE","UP"];
	diag_log ["target of cruise missile",_state, [_missile,_targetASL,_altitude,_anchor,_handle]];
	_params = [_missile,_targetASL,_altitude,_fn_getTerrainHeight,_fn_headTowards,_anchor,_handle];
	private ["_nextWP"];
	switch (_missile getVariable ["STATE","UP"]) do {
		case "UP": {
			_nextWp = _params call _flyUpwards;
		};
		case "TARGET": {
			_nextWp = _params call _flyTarget;
		};
	};
	//home towards next wp
	if (!isNull _missile) then {
		[_missile, _nextWP] call _fn_headTowards;
		_helper = "Sign_Sphere200cm_F" createVehicle _nextWP;
		_helper setPosWorld _nextWP;
	};

	diag_log ["nextWp",_nextWP];
}, 1, [_missile,_targetASL,_altitude,_fn_getTerrainHeight,_fn_headTowards,_anchor,_flyUpwards, _flyTarget]] call CBA_fnc_addPerFrameHandler;










