/**
	Function
	TODO: 
	-	allow moving targets/objects, update target pos constantly
	-	bomb type selection
 */

params [
	["_target",[],[[],objNull,""],3],										//targetpos (ASL) to bomb, or object or marker
	["_planeClass","O_Plane_CAS_02_dynamicLoadout_F",[""]],					//plane class, default: vanilla CSAT YAK
	["_bombType","Bomb_03_F",["strink"]],
	["_bombCount",2+random 2,[0]],  										//amount of bombs dropped, default: 2-4, use 1 for precision strike
	["_flyHeight",150,[0]],													//how low to fly over the target (meters above ground), impacts spread of bombs.
	["_dir",45,[0]],  														//in what direction to fly over the target (compass)
	["_side",east,[civilian]],												//side that is performing the bomb run: default civilian (wont be shot at)
	["_spawnPos",[0,0,0],[[]],3], 										//spawnpos for plane (ignore z)
	["_despawnPos",[-5000,0,0],[[]],3]									//despawn pos for plane  (ignore z)
];
diag_log ["bomb run ",_this];
_error = {
	params ["_mssg","_extra"];
	diag_log [_mssg,_extra];
	[_mssg] call BIS_fnc_error;
};
_abort = false;
//test valid spawnpos, targetpos, despawnpos
if (_spawnPos isEqualTo [] || _target isEqualTo [] || _despawnPos isEqualTo []) exitWith {
	["invalid positions given:",[_spawnPos,_target,_despawnPos]] call _error;
};

if (_target isEqualType "") then { // marker, get pos
	if (_target in allMapMarkers) then {
		_target = getMarkerPos _target;
	} else {
		["target is string but not existing marker.",_target] call _error;
		_abort = true;
	}
};
if (_target isEqualType objNull) then { //obj, get pos ASL
	_target = getPosWorld _target;
};
if (_abort) exitWith {
	["aborted bc faulty input parameters"] call _error;
};

_flyHeight = _flyHeight max 75; 
_spawnPos set [2,_flyHeight];
_dir = [ //direction compass -> 2d vector on grid
	sin(_dir),
	cos(_dir),
	0
];
_despawnPos set [2,_flyHeight];
diag_log ["params for spawnplane:",_this];
diag_log ["side plane:",_side];
_bombCount = (0 max (_bombCount -1));
//TODO allow aborting/redirecting strike
//plane class:
_arr =
[
	_spawnPos,		//position
	(_spawnPos getDir _target),				//direction
	_planeClass,			//type
	_side				//side
] call BIS_fnc_spawnVehicle;
_arr params ["_plane","_crew","_grp"];
_plane setVelocityModelSpace [0, 100, 0]; //pushes car forward

diag_log ["spawned plane:",_arr];

//make plane ignore everyone
_grp setBehaviour "AWARE";
_grp setCombatMode "BLUE";
//_plane setCaptive true;
_plane flyInHeight _flyHeight;

//public control var for abort 
_plane setVariable ["irn_bombrun",1,true]; //on target

//add move waypoints for plane
_i = 0;
_wps = []; _wp = ""; _o = 4000;

_wps append [(_target vectorAdd (_dir vectorMultiply (_o))),[]+_target,(_target vectorAdd (_dir vectorMultiply (-1*_o))),_despawnPos];
{
	_i = _i + 1; 
	_x set [2,_flyHeight];
	_wp = _grp addWaypoint [_x,0,_i];
	_wp setWaypointSpeed "FULL";
	_wp setWaypointCompletionRadius 1000; //plane might end up circeling infinetly otherwise.
} forEach _wps;
//add plane to Zeus
{
	_x addCuratorEditableObjects [[_plane], true];	
} forEach allCurators;

//create bomb impact positions
_bombPosArr = [];
_offset = 50;
_spread = 20*_flyHeight/100;
if (_bombCount == 0) then {
	_bombPosArr = [_target]; //right on target
} else {
	for "_i" from -0.5 *_bombCount to 0.5 *_bombCount do {
		_bombPos = _target vectorAdd (_dir vectorMultiply _offset * _i);
		_bombPos = _bombPos vectorAdd [-0.5*_spread + random _spread,-0.5*_spread + random _spread,0]; //shift position randomly +/- 10m
		_bombPos set [2,1 + (getTerrainHeightASL _bombPos)];
		_bombPosArr pushBack _bombPos;
	};
};
planetarget = _target;
//mark target (debug)

//for "_i" from -20 to 20 do {
//	_h = "Sign_Sphere200cm_F" createVehicle [0,0,0];
//	_h setPosWorld ([_i,0,0] vectorAdd (_target));
//
//	_h = "Sign_Sphere200cm_F" createVehicle [0,0,0];
//	_h setPosWorld ([0,_i,0] vectorAdd (_target));
//};


[_plane,_flyHeight,_wp,_bombPosArr,_target,_despawnPos,_bombType] spawn {
	//internal loop that will spawn the bombs once the plane is flying over the position.
	params ["_plane","_flyHeight","_wp","_bombPosArr","_target","_despawnPos","_bombType"];
	//wait until the plane is closer than 100m, then wait again until its 200m+ away again (time at which bombs would hit the ground at 150m height + 220m/s)
	_splashSpeed = 9.81*sqrt(2*_flyHeight/9.81); _splashDir = [0,0,1];

	//first loop: wait till plane is close to target to drop bombs
	while {!(isNull _plane) && alive _plane} do {
		if ((_plane getVariable ["irn_bombrun",0])!=1) exitWith { 			//bombrun was aborted.
			(group _plane) setCurrentWaypoint _wp; //despawn wp
		};

		//plane is close to target, release bombs
		_targetOffset = abs((getDir _plane) - (_plane getDir _target));
		if (_targetOffset < 10 && _plane distance2D _target < 300) exitWith { 
			_splashDir = (getPosWorld _plane) vectorDiff _target; //vector from target to plane
			_splashDir = (_splashDir vectorMultiply 0.95);
			_bombPosArr = _bombPosArr apply {[_x,_x vectorAdd _splashDir]}; //offset spawn pos for bombs to be near plane

			//spawn bombs
			{ 
				_bomb = objNull;_pos = [0,0,0];
				isNil { //force into single frame
					_pos = _x select 1;
					_bomb = _bombType createVehicle [0,-random 1000,1000];
					_bomb setPosWorld _pos;
					//helper
					//_h = "Sign_Sphere200cm_F" createVehicle (getPosWorld _bomb);
					//_h = "Sign_Sphere200cm_F" createVehicle [0,0,0];
					//_h attachTo [_bomb,[0,0,0]];
				};

				[_bomb,_x select 0,_splashSpeed] spawn {
					params ["_bomb","_target","_speed"];
					private ["_t","_dir"];
					_pos = [];
					_t = 3;
					//_bomb addEventHandler ["hit", {
					//	params ["_unit", "_killer"];
					//	_pos = getPosWorld _unit;
					//	if (!surfaceIsWater _pos) then {
					//	_crater = createVehicle ["Land_ShellCrater_02_small_F",[0,-random 1000,1000]];
					//	_crater setDir (random 360);
					//	_pos set [2,(getTerrainHeightASL _pos)-0.7];
					//	_crater setPosWorld _pos;
					//	_normal = surfaceNormal	[_pos#0,_pos#1];
					//	_crater setVectorUp _normal;
					//	};
					//}];

					while {!isNull _bomb && _t < 30 && (getPosWorld _bomb )#2>_target#2} do {	//30 seconds = 4000 meter freefall
						_dir = (vectorNormalized (_target vectorDiff(getPosWorld _bomb)));
						_bomb setVelocity (_dir vectorMultiply (9.81*_t*_t));
						_pos = getPosWorld _bomb;
						sleep 0.1;
						_t = _t + 0.1;
					};

				};
				sleep random 0.5;
			} forEach _bombPosArr;
			//set control var/state
			_plane setVariable ["irn_bombrun",2,true]; //bombs away
		};
		sleep 0.2; 
	};

	//second loop: despawn plane if close to despawn pos
	_time = 180;
	while {!(isNull _plane) && alive _plane} do {
		if (_plane distance2D _despawnPos < 500 || _time <= 1) exitWith {
			{_plane deleteVehicleCrew _x} forEach crew _plane;
			deleteVehicle _plane;
		};
		_time = _time - 3;
		sleep 3;
	};
	_plane setVariable ["irn_bombrun",3,true]; //dead but not despawned
};
_plane //out
