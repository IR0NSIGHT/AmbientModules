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
	[50,1000,100,0],//
	false
];

_durationC = [
	"slider",
	"Duration (seconds)",
	[5,300,15,0],//
	false
];

_intensityC = [
	"slider",
	"Intensity (seconds between impacts)",
	[0.5,10,2,1],//
	false
];

_projectileC = [
		"list",
		"Mortar ammo type",
		[[["F_40mm_White",true],["F_40mm_Red",true],["F_40mm_Green",true],["Smoke_82mm_AMOS_White",false],["Smoke_120mm_AMOS_White",false],["Sh_82mm_AMOS",false],["Sh_155mm_AMOS",false]],
		["Flare white 40mm","Flare red 40mm","Flare green 40mm","Smoke 82mm","Smoke 120mm","HE 82mm","HE 155mm"],0],
		false
];

_title = "Single Airstrike this position";
_content = [
	_radiusC,
	_durationC,
	_intensityC,
	_projectileC
];

_onConfirm = {
	params["_output","_args"];
	_output params ["_radius","_duration","_timeBetweenImpact","_projectile"];
	_projectile params ["_projClass","_isFlare"];
	_spawnHeight = 300;
	_speed = 200;
	if (_isFlare) then {
		_spawnHeight = 100;
		_speed = 0.5;
	};
	_args params ["_pos"];
	_args = [_pos,_radius, _duration,  _projClass, _speed,_spawnHeight,_timeBetweenImpact];
	diag_log ["calling mortar fire with args:",_args];
 	//call mortar volley function on server
	//_args execVM "fn_artilleryVolley.sqf";
 	_args remoteExec ["IRN_fnc_artilleryVolley",2];
};

_onCancel = {};
_args = [_pos];

[_title,_content,_onConfirm,_onCancel,_args] call zen_dialog_fnc_create;
