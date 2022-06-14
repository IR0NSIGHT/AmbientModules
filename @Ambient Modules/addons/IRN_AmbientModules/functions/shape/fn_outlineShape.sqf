/* 
*	@Author: IR0NSIGHT 
*	@Date: 2022-06-07 23:25:51 
*	@Last Modified time: 2022-06-07 23:25:51 
*	 
*	Description: 
*		outline this shape with helper objects.
*		helpers are spawned at correct posASL and attached to mother object
* 
*	Environment: 
*		any, any
*		 
*	Parameter(s): 
*		0: object - mother objectt
*		 
*		1: shape - shape
*		 
*		2: number - spacing in meters between the helpers
*
*		3: bool - hide the outlining objects on local machine if the anchor is not selected.
*		 
*	Returns: 
*		array of helper objects
* 
*	Examples: 
*		_shape = ["rect",[player,[5,0,0],[0,7,0]]];	//koordinaten vektoren in der Basis des players: forward, right, up
*		[player,_shape,25] call irn_fnc_outLineShape;
*
*		_shape = ["circle",getPosWorld player,[50]];
*		[player,_shape,25] call irn_fnc_outLineShape;
*/

params [
	["_motherObj",objNull,[objNull]],
	["_shape",[],[[]],3],
	["_helperOffset",20,[-1]],
	["_hideOnUnselect",false,[true]],
	["_deleteOnAnchorDeath",false,[true]]
];

if (isNull _motherObj || {_shape isEqualTo []} || {!([_shape] call irn_fnc_isShape)}) exitWith {
	["invalid input"] call BIS_fnc_error;
};

{
	deleteVehicle _x;
} foreach attachedObjects _motherObj;
_outlineHelpers = [];

//spawn directional red arrow
_arrowDir = "Sign_Arrow_Direction_F" createVehicleLocal getPosATL _motherObj;
_arrowDir setDir 0;
_arrowDir attachTo [_motherObj,[0,0,10]];
_arrowDir setObjectScale 25;
_outlineHelpers pushBack _arrowDir;

_shape params ["_type","_anchorPoint","_shapeParams"];
_anchorObj = objNull;
if (_anchorPoint isEqualType objNull) then {
	_anchorObj = _anchorPoint;
	_anchorPoint = getPosASL _anchorPoint;
};
_offsetArr = [];
switch _type do {
	case "circle": {
		_shapeParams params ["_radius"];
		_amountHelper = round(2*pi*_radius/_helperOffset);	//a helper every 20 meters
		for "_i" from 0 to 360 step (360/_amountHelper) do {
			_theta = _i;
			_offset = [_radius*cos(_theta),_radius*sin(_theta),10];
			_offsetArr pushBack _offset;
		};
	};
	case "rect": {
		if (_anchorPoint isEqualType objNull) then {
			_anchorPoint = getPosASL _anchorPoint;
		};
		_sidesWorld = ([_shape] call irn_fnc_rect_getSidesWorld);
		_sidesWorld params ["_side01","_side02"];
		{
			_amountHelper = ceil((vectorMagnitude (_x#0))/_helperOffset);
			_sideV = (_x#0) vectorMultiply (1/_amountHelper);
			for "_i" from 0 to _amountHelper do {
				_offset =( (_sideV vectorMultiply _i) vectorAdd _x#1);
				_offsetArr pushBack _offset;
			};
		} forEach [[_side01,[0,0,0]],[_side02,[0,0,0]],[_side01,_side02],[_side02,_side01]];
	};
	default {
		["invalid shape given, did not match any type:",_shape] call BIS_fnc_error;
	};
};


//spawn helpers and attach to anchor
_offsetArr = _offsetArr apply {_x set [2,25]; _x};
{
	_sideObj = "Sign_Arrow_Large_Yellow_F" createVehicleLocal [0,0,0];
	_sideObj attachTo [_motherObj,_x];
	_sideObj setObjectScale 4;
	_outlineHelpers pushBack _sideObj;
} forEach _offsetArr;


//spawn loop that hides/shows helpers if flag was used
if (_hideOnUnselect && !isNull _anchorObj) then {
	[_anchorObj,_outlineHelpers] spawn {
		params ["_anchor","_objs"];
		while {!isNull _anchor} do {
			//show outline if anchor is selected, otherwise hide them.
			if (_anchor in curatorSelected#0) then {
				{_x hideObject false} forEach _objs;
			} else {
				{_x hideObject true} forEach _objs;
			};
			sleep 1;
		};
	};
};

if (_deleteOnAnchorDeath && !isNull _anchorObj) then {
	[_anchorObj,_outlineHelpers] spawn {
		params ["_anchor","_objs"];
		waitUntil {
			sleep 1;
			isNull _anchor
		};
		{deleteVehicle _x;} forEach _objs;
	};
};

//return
_outlineHelpers