#include "script_component.hpp"

params ["_pos"];
[
	"AMBIENT AIRTRAFFIC PARAMETERS",
	[
		[
			"COMBO",	//TIMEOUT
			"Time between flights",
			[[5,30,60,3*60,10*60,20*60,30*60],["5 sec","30sec","1 min","3 min","10 min","20 min","30 min"],4],
			false
		],
		[
			"SIDES",	//SIDE
			"Faction",
			west,
			false
		],
		[
			"COMBO",
			"Type",
			[
				["Plane","Helicopter"],["Plane","Helicopter"],1
			],
			false
		],
		[
			"COMBO",	//DURATION
			"Duration (minutes)",
			[[1,5,10,30,45,60,120,-1],["1 min","5 min","10 min","30 min","45 min","1 h","2h","unlimited"],3],
			false
		]
	],
	{
		params ["_selected","_args"];
		_selected params ["_timeout","_side","_type","_duration"];
		_args params ["_pos"];
		diag_log ["_selected",_selected,"_anchorPos",_pos];
		//[_pos,_timeout,_side,_duration,_type] execVM "fn_ambPlanes_PlaneSelection.sqf";
		[_pos,_timeout,_side,_duration,_type] call FUNC(ambPlanes_PlaneSelection);

	},
	{},
	[_pos]
] call zen_dialog_fnc_create;