/**
	creates ZEN dialog for spawning artillery volley in zeus.
 */

params ["_pos"];

_radiusC = [
	"slider",
	"Radius",
	[50,100,100,0],//
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
	[1,30,2,0],//
	false
];

_projectileC = [
		"combo",
		"Mortar ammo type",
		[["Flare_82mm_AMOS_White","Smoke_82mm_AMOS_White","Sh_82mm_AMOS"],["Flare 82mm","Smoke 82mm","HE 82mm"],0],
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
	_output params ["_radius","_duration","_timeBetweenImpact","_projectileClass"];
	_args params ["_pos"];
	_args = [_pos,_radius, _duration, _timeBetweenImpact, _projectileClass];
	diag_log ["calling mortar fire with args:",_args];
 	//call mortar volley function on server
 	_args remoteExec ["IRN_fnc_artilleryVolley",2];
};

_onCancel = {};
_args = [_pos];

[_title,_content,_onConfirm,_onCancel,_args] call zen_dialog_fnc_create;
