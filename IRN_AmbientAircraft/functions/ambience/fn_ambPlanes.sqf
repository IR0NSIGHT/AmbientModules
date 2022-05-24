/*
	Author: IR0NSIGHT

	Description:
		Will spawn ambient planes flying over the heads of the players from time to time
		Planes spawn and despawn at the edge of the map. Planes are set to captive, wont engage/be engaged.

	Parameter(s):
		0:	number - average timeout between flights in seconds
		1:	array of classnames - whitelisted aircrafts with weight, format: [planeclass, weight, planeclass, weight...] (optional)
		2:  side of planes	- which side the planes belong to, default west (optional)
	Returns:
		control object (helipad) with var "irn_amb_planes_run"

	Examples:
		[15, ["B_Heli_Transport_03_unarmed_F",1,
		"B_Heli_Transport_01_F",1,
		"B_CTRG_Heli_Transport_01_sand_F",1,
		"B_Plane_CAS_01_dynamicLoadout_F",1,
		"B_Plane_Fighter_01_F",5]] spawn IRN_fnc_ambPlanes;
		
*/
if (!isServer) exitWith {};
if (!canSuspend) exitWith {
	 ["Function can not be called in unsuspendable context. Use 'spawn' instead"] call BIS_fnc_error;
};
params [
	["_timeout",120,[-1]],
	["_classes",["B_Heli_Transport_03_unarmed_F",1,"B_Heli_Transport_01_F",2],[[]]],
	["_side",west,[]]
];
_dummy = createVehicle ["Land_HelipadEmpty_F",[0,0,0]];
_dummy setVariable ["irn_amb_planes_run",true];

[_timeout,_classes,_side,_dummy] spawn {
	params ["_timeout","_classes","_side","_dummy"];
	_findPosAtMapEdge = {
		params ["_dir","_pos"];
		//pos +k*dir = 0 <=> k*dir = -pos <=> k = -pos/dir
		_low = -5000;
		_high = worldSize + 5000;
		_kLeft = (_low-(_pos#0))/_dir#0;
		_kRight = (_high-(_pos#0))/_dir#0;

		_kBottom = (_low -(_pos#1))/_dir#1;
		_kTop = (_high-(_pos#1))/_dir#1;
		diag_log["left,right,bottom,top",_kLeft,_kRight,_kBottom,_kTop];
		_plusDir = [(_kLeft max _kRight),(_kBottom max _kTop)];
		_negDir = [-1*(_kLeft min _kRight),-1*(_kBottom min _kTop)];
		diag_log ["dir",_dir,"pos",_pos,"plusDir",_plusDir,"negDir",_negDir];
		_out = [_dir vectorMultiply (selectMin _plusDir),_dir vectorMultiply -1*(selectMin _negDir)];
		_out = _out apply {_x vectorAdd _pos};
		_out
	};

	while {_dummy getVariable ["irn_amb_planes_run",true]} do {
		//find a player to fly over
		_ps = allPlayers select {speed _x < 15};
		if (count _ps != 0) then {
			_p = selectRandom _ps;
			_class = selectRandomWeighted _classes;		
			_alt = 100+random 200;
			_dir = (vectorNormalized [-1 + random 2,-1 + random 2,0]);
			
			//get positions for spawn/despawn at edge of map
			_offsets = [_dir, getPosWorld _p] call _findPosAtMapEdge;
			_from = _offsets#0;
			_to = _offsets#1;

			//bring positions to 100m above terrain
			_from set [2,100+getTerrainHeightASL [_from#0,_from#1]];
			_to set [2,100+getTerrainHeightASL [_to#0,_to#1]];
			for "_i" from 0 to (random 3) do {
				[_from, _to, _alt , "FULL", _class, _side] call BIS_fnc_ambientFlyby;
				_from = _from vectorAdd [200,200,0];
				_to = _to vectorAdd [200,200,0];
			};
			//systemChat ("nyoom: "+_class);
		};
		sleep (0.5*_timeout+((random 0.5)*_timeout));
	};
};
_dummy
