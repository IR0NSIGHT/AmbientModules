params [
	["_pos",[0,0,0],[[]],3],
	["_timeout",30,[1]],
	["_side",west,[west]],
	["_duration",3,[-1]],
	["_type","Plane",[""]]
];

_getAllPlanes = {
	params ["_type","_side"];
	switch _side do {
		case west: {_side = 1};
		case east: {_side = 2};
		case independent: {_side = 3};
		case civilian: {_side = 4};
		default {_side = str _side};
	};
	if !(_type in ["Helicopter","Plane"]) exitWith {
		["invalid type, expected 'Helicopter' or 'Plane' but received " + str _type] call BIS_fnc_error;
		[]
	};
	if (_side == -1) exitWith {
		["invalid side"] call BIS_fnc_error;
		[]
	};
	_cond = format ["
		(configName _x) isKindOf '%1' &&
		 getNumber (_x >> 'scope') == 2 &&
		 getNumber (_x >> 'side') == %2
		 ",_type, _side];

	diag_log ["condition=",_cond];
	_planes = (_cond configClasses (configFile>>"CfgVehicles"));

	_planes
};


_planes = [_type,_side] call _getAllPlanes;
_planeClassnames = _planes apply {configName _x};
_planeDisplayNames = _planes apply {getText (configFile >> 'CfgVehicles' >> (configName _x) >> "displayName")};

_contentArr = [];
{	//generate a checkbox for every existing plane
	_class = configName _x;
	_displayName = getText (configFile >> 'CfgVehicles' >> (configName _x) >> "displayName");
	_content = [
		"TOOLBOX:YESNO",
		_displayName,
		[
			false
		],
		false
	];
	_contentArr pushBack _content;
} forEach _planes;

[
	"AMBIENT AIRTRAFFIC",
	_contentArr,
	{
		params ["_boolArr","_args"];
		_args params ["_classNames","_pos","_timeout","_side","_duration"];

		//get selected classes
		_classes = [];
		{
			if (_x) then {
				_classes pushBack (_classNames select _forEachIndex);
			};
		} forEach _boolArr;
		_params = [_classes,_pos,_timeout,_side,_duration];
		//_params execVM "fn_ambPlanes_WeightSelection.sqf";
		_params call IRN_fnc_ambPlanes_WeightSelection;
	},	//confirm
	{},	//cancel
	[_planeClassnames,_pos,_timeout,_side,_duration]	//args
] call zen_dialog_fnc_create;