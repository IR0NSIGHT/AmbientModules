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
*		[getPosWorld player] call IRN_fnc_artilleryVolleyDialog
*/

params ["_pos"];
//See ZEN framework for documentation https://zen-mod.github.io/ZEN/#/frameworks/dynamic_dialog

_radiusC = [
	"slider",
	"Radius",
	[25,1000,100,0],//
	false
];

_durationC = [
	"slider",
	"Duration (seconds)",
	[3,300,15,0],//
	false
];

_delay = [
	"slider",
	"Delay/Simulated artillery distance",
	[0,60,0,{
		_this = round _this;
		(str _this)+ "s|"+ str round(_this/10)+"km"
	}]
];

_discreteValues = [0.1,0.2,0.5,1,2,4,8,16];
missionNamespace setVariable ["irn_modZeusDiscreteValues",_discreteValues];
_intensityC = [
	"slider",
	"Seconds between impacts",
	[0,1,0,
		{
			_discreteValues = missionNamespace getVariable ["irn_modZeusDiscreteValues",[]];
			_maxIdx = -1 + count _discreteValues;
			_idx = 0 max round (_this*_maxIdx);	//safety measure?
			str (_discreteValues#_idx)
		}
	],//
	false
];
_projectiles = [
	//category: flare, smoke, HE
	//format: [classname, displayname, isFlare]
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
		"list",
		"Mortar ammo type",
		[
			_projectiles apply {[_x#0,_x#2]},
			_projectiles apply {_x#1},
			0
		],
		false
];

_title = "Single Airstrike this position";
_content = [
	_radiusC,
	_durationC,
	_intensityC,
	_projectileC,
	_delay
];

_onConfirm = {
	params["_output","_args"];
	_output params ["_radius","_duration","_timeBetweenImpactIdx","_projectile","_delay"];
	_projectile params ["_projClass","_isFlare"];
	_spawnHeight = 300;
	_speed = 200;
	if (_isFlare) then {
		_spawnHeight = 100;
		_speed = 0.5;
	};
	_args params ["_pos"];

	//get discrete value for time between impacts
	_discreteValues = missionNamespace getVariable ["irn_modZeusDiscreteValues",[]];
	_maxIdx = -1 + count _discreteValues;
	_timeBetweenImpact = _discreteValues#(0 max round (_timeBetweenImpactIdx*_maxIdx));
	//

	_args = [_pos,_radius, _duration,  _projClass, _speed,_spawnHeight,_timeBetweenImpact];
	[_delay,_args] spawn {
		params ["_delay","_args"];
		sleep _delay;
		diag_log ["calling mortar fire with args:",_args];
		//call mortar volley function on server
		//_args execVM "fn_artilleryVolley.sqf";
		_args remoteExec ["IRN_fnc_artilleryVolley",2];
	}

};

_onCancel = {};
_args = [_pos];

[_title,_content,_onConfirm,_onCancel,_args] call zen_dialog_fnc_create;


