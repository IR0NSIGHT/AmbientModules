/*
made by IR0NSIGHT
a script which plays gunshots at 400m distance in the direction of a given center object.
creates illusion of nearby gunfight in the direction of the specified object, while allowing bigger distances than are possible with vanilla soundsimulation.
call skript with: 
execVM "yourlinktoskriptinMissionFolder\ambient_battles.sqf";
will only execute on the server machine.
*/
//--------------------------------------------------------------------------------------------
// will remotely call sounds on all clients (including server). define paramters in _handles array
//requires an object called "center" (as its varname in editor) as the soundsource. object will not be touched or teleported.
diag_Log ["#############################################################", _this]; 
params ["_action", "_ambientbattles"];
_module = _ambientbattles select 0;
_dist = _module getVariable "distance";
_dist = parseNumber _dist;
_duration = _module getVariable "duration";
_duration = parseNumber _duration;
_center = _module;


if (!isServer) exitWith {};
if (_action !="init") exitWith {}; //only executes ingame, not in Eden
_handle = [false, _duration, _dist, _center] spawn { //[debug mode, duration in seconds]
	params["_debug","_duration","_dist","_center"];
	IRN_calcSoundPos = {
		params ["_center","_dist","_headPos"];
		_posP = getPosASL player;	//getpos player
		_posC = getPosASL _center;	//getpos of center
		_direction = _posC vectorDiff _posP; //get desired positon of selfiestick headgear
		//TODO add safeguard for players that manage to get very far away
		if (vectorMagnitude _direction < _dist) then { //if center is closer than _dist, set pos directly at center
			_headPos = _posC;
		} else { //else set in direction of center at _dist meters away
			_dirNorm = vectorNormalized _direction;
			_direction = _dirNorm vectorMultiply _dist;
			_headPos = _posP vectorAdd _direction;
		};
		_headPos
	};

	IRN_spawnSalvo = {
		params["_sound","_pos","_shots","_delay","_volume"];
		sleep _delay;
		for "_i" from 0 to _shots do {
			playSound3D [_sound, nil, false, _pos, _volume, 0, 0]; // play sound
			sleep random [0.02,0.2,0.5];
		};
	};

	IRN_remoteSound = { //plays the specified sound on client
		params["_sound","_pos","_shots","_delay","_volume","_center","_dist"];
		//get pos
		_pos = [_center,_dist] call IRN_calcSoundPos;
		//play salvo
		[_sound,_pos,_shots,_delay,_volume] call IRN_spawnSalvo;
	};

	private _i = 0; //iteration counter
	private ["_posC","_posP","_direction","_dirNorm","_dist","_center","_source"];
	private	_listShots = [
		"A3\Sounds_F\weapons\HMG\HMG_gun.wss",
		"A3\Sounds_F\weapons\M4\m4_st_1.wss",
		"A3\Sounds_F\weapons\M200\M200_burst.wss",
		"A3\Sounds_F\weapons\mk20\mk20_shot_1.wss"
	];
	private _listRare = [
		"A3\Sounds_F\weapons\Explosion\explosion_antitank_1.wss",
		"A3\Sounds_F\weapons\Explosion\expl_shell_1.wss",
		"A3\Sounds_F\weapons\Explosion\expl_big_1.wss"
	];
	//place soundsource in direction of city with 400m away from player
	_headPos = _center;
	if (_debug) then {
		hint "starting audio";
	};
	
	sleep 2;
	_start = time;
	_end = _start + _duration;
	while {time < _end} do {
		//loop
		_i = _i + 1;
		if (_debug) then {
			hint str _i;	
		};
		//--------play sounds
		//remote exec position and sound play

		for "_i" from 0 to 5 do { //spawn up to 5 salvos of fast fire (MG)
			_sound = selectRandom (if (random 1 < 0.05) then {_listRare} else {_listShots});
			//params["_sound","_pos","_shots","_delay","_volume"];
			[_sound,	[0,0,0],	random 15,	random 10,0.5 + random 0.5,_center,_dist] remoteExec ["IRN_remoteSound",0, true];
		};

		//--------------
		sleep random 20;
	};
	if (_debug) then {
		hint ("player to soundsource: " + str (getPosASL player distance _headPos));
		hint "finished audio";
	};
}
