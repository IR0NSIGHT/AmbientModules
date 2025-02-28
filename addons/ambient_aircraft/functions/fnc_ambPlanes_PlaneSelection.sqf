/* 
*	@Author: IR0NSIGHT 
*	@Date: 2022-06-15 13:57:40 
*	@Last Modified time: 2022-06-15 13:57:40 
*	 
*	Description: 
*		opens ZEN dialog used to select plane classes.
*		called by fn_ambPlanes_ParamSelection.
*		calls fn_ambPlanes_WeightSelection on confirm
*		Not intended to be used outside of the chain of zeus dialogs for ambient airtraffic
* 
*	Environment: 
*		player, any 
*		 
*	Parameter(s): 
*		0: posASL - position of module
*		 
*		1: number - timeout between flights in seconds
*		 
*		2: side - side of planes
*		 
*		3: number - duration in minutes of airtraffic 
*		 
*		4: string, configparent - type the classes must inherit from in config (optional, default= "plane") 
*		 
*		 
*	Returns: 
*		nassing
* 
*	Examples: 
*		[] call IRN_fnc_someFunction 
*/
#include "script_component.hpp"

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
		case east: {_side = 0};
		case west: {_side = 1};
		case independent: {_side = 2};
		case civilian: {_side = 3};
		default {
			diag_log ["unknown side selection:",_side];
			_side = -1
			};
	};
	if (_side == -1) exitWith {
		["invalid side"] call BIS_fnc_error;
		[]
	};
	diag_log ["find all planes for side ",_side];
	if !(_type in ["Helicopter","Plane"]) exitWith {
		["invalid type, expected 'Helicopter' or 'Plane' but received " + str _type] call BIS_fnc_error;
		[]
	};

	_cond = format ["
		(configName _x) isKindOf '%1' &&
		 getNumber (_x >> 'scope') == 2 &&
		 getNumber (_x >> 'side') == %2
		 ",_type, _side];

	diag_log ["condition=",_cond];
	_planes = (_cond configClasses (configFile>>"CfgVehicles"));
	_planesUnique = [];
	_planes apply { 
		if (!(_x in _planesUnique)) then {
			_planesUnique pushBack _x;
		};
	};
	_planesUnique
};

// format: [displayName, configName]
_planesNames = ([_type,_side] call _getAllPlanes) apply {[getText (configFile >> 'CfgVehicles' >> (configName _x) >> "displayName"), configName _x]};
diag_log ["planes array:",_planesNames];
//sort by display name
_planesNames =[_planesNames, [], {_x#0}, "ASCEND"] call BIS_fnc_sortBy;

_planeDisplayNames = _planesNames apply {_x#0};
_planeClassnames = _planesNames apply {_x#1};


_contentArr = [];
{	//generate a checkbox for every existing plane
	_displayName = _x#0;
	_content = [
		"TOOLBOX:YESNO",
		_displayName,
		[
			false
		],
		false
	];
	_contentArr pushBack _content;
} forEach _planesNames;

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
		_params call FUNC(ambPlanes_WeightSelection);
	},	//confirm
	{},	//cancel
	[_planeClassnames,_pos,_timeout,_side,_duration]	//args
] call zen_dialog_fnc_create;