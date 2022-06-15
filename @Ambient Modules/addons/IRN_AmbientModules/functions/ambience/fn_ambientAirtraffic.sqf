/*
*	Author: IR0NSIGHT
*
*	Description:
*		Will spawn ambient planes flying over the heads of the players from time to time
*		Planes spawn and despawn at the edge of the map. Planes are set to captive, wont engage/be engaged.
*
*	Parameter(s):
*		0:	number - average timeout between flights in seconds
*		1:  array of classnames - whitelisted aircrafts with weight, format: [planeclass, weight, planeclass, weight...] (optional)
*		2:	side of planes	- which side the planes belong to, default west (optional)
*		3:	number - duration (minutes)(optinonal, default = -1 = unlimited)
*		4:	anchor object, used for control (optional) 
*		
*	Returns
*		control object (helipad) with var "irn_amb_planes_run"
*
*	Examples:
*		[15, ["B_Heli_Transport_03_unarmed_F",1,
*		"B_Heli_Transport_01_F",1,
*		"B_CTRG_Heli_Transport_01_sand_F",1,
*		"B_Plane_CAS_01_dynamicLoadout_F",1,
*		"B_Plane_Fighter_01_F",5]] spawn IRN_fnc_ambPlanes;
*		
*/

if (!isServer) exitWith {};
if (!canSuspend) exitWith {
	 ["Function can not be called in unsuspendable context. Use spawn instead"] call BIS_fnc_error;
};

params [
	["_timeout",120,[-1]],
	["_classes",["B_Heli_Transport_03_unarmed_F","B_Heli_Transport_01_F"],[[]]],
	["_weights",[2,1],[[]]],
	["_squadronSize",[],[[]]],	//optional
	["_side",west,[]],
	["_duration",-1,[0]],
	["_pos",[0,0,0],[[]],3]
];


//spawn anchor object for outside control
_anchor = createVehicle ["Sign_Pointer_Blue_F",[0,0,0]];	//anchor is global object, but local to zeus
_anchor hideObjectGlobal true;
_anchor setPosASL _pos;
{
	[_x,[[_anchor], true]] remoteExec ["addCuratorEditableObjects",2,false];
} forEach allCurators;
//TODO assert classes array is legal
if !(_weights isEqualTypeArray (_classes apply {1})) exitWith {
	["invalid weight array"] call BIS_fnc_error;
};
if !(_classes isEqualTypeArray (_classes apply {""})) exitWith {
	["invalid classes array"] call BIS_fnc_error;
};
//generate squad size array if not given 
if (_squadronSize isEqualTo []) then {
	_squadronSize = _classes apply {3};
};

if !(_squadronSize isEqualTypeArray (_classes apply {1})) exitWith {
	["invalid squadron size array"] call BIS_fnc_error;
};

{	//push relevant parameters into anchor object namespace
	diag_log ["pushing var:",_x#0,_x#1];
	_anchor setVariable ["irn_amb_planes_"+_x#0,_x#1];
} forEach [
	["classes",_classes],
	["weights",_weights],
	["squadronSize",_squadronSize],
	["timeout",_timeout],
	["side",_side],
	["start",time],
	["duration",_duration*60]
];


[_anchor] spawn {
	params ["_anchor"];
	_findPosAtMapEdge = {
		params ["_dir","_pos"];
		//pos +k*dir = 0 <=> k*dir = -pos <=> k = -pos/dir
		_low = -5000;
		_high = worldSize + 5000;
		_kLeft = (_low-(_pos#0))/_dir#0;
		_kRight = (_high-(_pos#0))/_dir#0;

		_kBottom = (_low -(_pos#1))/_dir#1;
		_kTop = (_high-(_pos#1))/_dir#1;
		//diag_log["left,right,bottom,top",_kLeft,_kRight,_kBottom,_kTop];
		_plusDir = [(_kLeft max _kRight),(_kBottom max _kTop)];
		_negDir = [-1*(_kLeft min _kRight),-1*(_kBottom min _kTop)];
		//diag_log ["dir",_dir,"pos",_pos,"plusDir",_plusDir,"negDir",_negDir];
		_out = [_dir vectorMultiply (selectMin _plusDir),_dir vectorMultiply -1*(selectMin _negDir)];
		_out = _out apply {_x vectorAdd _pos};
		_out
	};

	_expired = {
		params ["_anchor"];
		_start = (_anchor getVariable ["irn_amb_planes_start",0] );
		_duration = (_anchor getVariable ["irn_amb_planes_duration",0]);
		(_duration > 0 && {_start + _duration < time})
	};

	//############################################################
	_timeout = 1;
	_abort = false;
	while {
		!_abort &&
		!isNull _anchor &&
		!([_anchor] call _expired)
	} do {
		//find a player to fly over
		_ps = allPlayers select {speed _x < 15};	//TODO allow condition as input to filter player
		if (count _ps != 0) then {
			_classes = 		_anchor getVariable ["irn_amb_planes_classes"		,[]];
			_weights = 		_anchor getVariable ["irn_amb_planes_weights"		,[]];
			_timeout = 		_anchor getVariable ["irn_amb_planes_timeout"		,120];
			_side = 		_anchor getVariable ["irn_amb_planes_side"			,west];
			_squadronSize = _anchor getVariable ["irn_amb_planes_squadronSize"	,3];
			if (_classes isEqualTo [] || _weights isEqualTo []) exitWith {
				["invalid vars gotten from anchor namespace"] call BIS_fnc_error;
				_abort = true;
			};
			//assert classes and weights legal

			_p = selectRandom _ps;
			_class = _classes selectRandomWeighted _weights;		
			_alt = 100+random 200;
			_dir = (vectorNormalized [-1 + random 2,-1 + random 2,0]);
			_idx = _classes find _class;	//yeah dont judge me, i was to lazy to redesign

			//get positions for spawn/despawn at edge of map
			_offsets = [_dir, getPosWorld _p] call _findPosAtMapEdge;
			_from = _offsets#0;
			_to = _offsets#1;

			//bring positions to 100m above terrain
			_from set [2,100+getTerrainHeightASL [_from#0,_from#1]];
			_to set [2,100+getTerrainHeightASL [_to#0,_to#1]];
			for "_i" from 0 to (random (_squadronSize#_idx)) do {
				[_from, _to, _alt , "FULL", _class, _side] call BIS_fnc_ambientFlyby;
				_from = _from vectorAdd [200,200,0];
				_to = _to vectorAdd [200,200,0];
				sleep (random [0,0.5,1])
			};

			//TODO attach WP to player until aircraft is closer than 2km
		};
		sleep (1+ (random [0,_timeout,2*_timeout]));
	};
	deleteVehicle _anchor;
};
_anchor




