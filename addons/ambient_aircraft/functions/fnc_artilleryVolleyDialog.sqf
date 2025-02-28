/* 
*	@Author: IR0NSIGHT 
*	@Date: 2022-06-03 17:38:32 
*	@Last Modified time: 2022-06-03 17:38:32 
*	 
*	Description: 
*		opens a ZEN dialog (GUI) that allows to specifiy an artillery barrage at the defined position
* 
*	Environment: 
*		CLIENT, SUSPENDABLE 
*		 
*	Parameter(s): 
*		0: posASL - position of artillery barrage 
*		 
*	Returns: 
*		none
* 
*	Examples: 
*		[getPosWorld player] call FUNC(artilleryVolleyDialog
*/
#include "script_component.hpp"

params ["_pos"];
//See ZEN framework for documentation https://zen-mod.github.io/ZEN/#/frameworks/dynamic_dialog

_shapeSelection = [
	"COMBO",
	["Shape type","Which shape the bombarded area will have"],
	[["circle","rect"],["Circle","Rectangle"],0]
];

_radiusC = [
	"slider",
	"Circle radius",
	[25,1000,100,0],//
	false
];

//support for RECT shape
_rectDimensionsC = [
	"VECTOR",
	["rectangle dimensions","vector that describes the dimensions of the reactuangulare area that will be bombarded."],
	[200,100]
];

//creeping barrage 
_movingDistance = [
	"COMBO",
	["Moving distance","Barrage will move forward this distance over its lifetime"],
	[[0,100,250,500],["0m","100m","250m","500m"],0],
	false
];

_durationC = [
	"slider",
	"Duration (seconds)",
	[3,300,15,0],//
	false
];

_delay = [
	"COMBO",
	"Delay",
	[
		[0,10,30,60,120,300],
		["0 sec","10 sec","30 sec","60 sec","2 min","5 min"],
		0
	],
	false
];

_discreteValues = [0.1,0.2,0.5,1,2,4,8,16,32];
_intensityC = [
	"COMBO",
	["Seconds between impacts","Average time between to shell impacts"],
	[
		_discreteValues,
		_discreteValues apply {(str _x)+" sec"},
		4
	],
	false
];
_projectiles = [
	//category: flare, smoke, HE
	//format: [value, name, isFlare]
	//40mm UGL
	["F_40mm_White"," 40mm Flare white",true],
	["F_40mm_Red"," 40mm Flare red",true],
	["F_40mm_Green"," 40mm Flare green",true],
	["G_40mm_HE"," 40mm HE",false],

	//82mm mortar
//	["Flare_82mm_AMOS_White"," 82mm Flare",true],	//TODO doesnt work?
	["Smoke_82mm_AMOS_White"," 82mm Smoke",false],
	["Sh_82mm_AMOS"," 82mm HE",false],

	//155mm mortar
	["Smoke_120mm_AMOS_White","155mm Smoke ",false],
	["Sh_155mm_AMOS","155mm HE",false],

	//230mm MRL rocket
	["R_230mm_HE","230mm HE Rocket",false]
];


_projectileC = [
		"COMBO",
		"Mortar ammo type",
		[
			_projectiles apply {[_x#0,_x#2]},
			_projectiles apply {_x#1},
			0
		],
		false
];

_title = "Artillery Barrage";
_content = [
	_shapeSelection,
	_radiusC,
	_rectDimensionsC,
	_durationC,
	_intensityC,
	_projectileC,
	_delay,
	_movingDistance
];

_onConfirm = {	//LOCAL TO ZEUS PLAYER
	params ["_output", "_args"];
	_output pushBack 0;	//initial direction of rolling barrage
	[_output, _args] call FUNC(artilleryInitializer);
};

_onCancel = {};
_args = [_pos];

[_title,_content,_onConfirm,_onCancel,_args] call zen_dialog_fnc_create;


