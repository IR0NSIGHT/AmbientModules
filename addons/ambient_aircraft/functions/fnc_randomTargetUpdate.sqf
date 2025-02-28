#include "script_component.hpp"

if (!isServer) exitWith {};
params [
	["_target",objNull,[objNull]],
	["_targetState",[],[[]]]
];
_targetState params [
		["_tank", objNull, [objNull]],
		["_heading", random 360],
		["_originPos", getPosATL _target],
		["_state", 0] //movement pattern state of target
	];

if (isNull _target || !alive _target) exitWith {
	diag_log ["stop updating random target because null or dead:", _target,_targetState];
};
if (missionNamespace getVariable ["DEBUG",false]) then {
	diag_log ["auto moving targets:", _target, "heading:",_heading,"origin:", _originPos,"state:", _state];
};

// handle state machine
private _timeout = 0;
private _speed = 10;
private _zPos = 100;
switch (_state) do {
	case 0: { // reset target position to near origin pos
		_heading = random 360;
		private _newPos = [];
		if (!isNull _tank && alive _tank) then {
			_newPos = ((_tank getPos [random 100, random 360]) getPos [-_zPos, _heading]);
			_tank doTarget _target;
		};		
		_target setPosATL [_newPos#0, _newPos#1,_originPos#2];
		_timeout = 0;
	};
	case 1: { // advance in heading
		_timeout = random [10,15,20];
		_handle = [
			{
				_this#0 params ["_target","_speed","_heading","_zPos"];
				_pos = (_target getPos [_speed/10,_heading]);
				_target setPosATL [_pos#0,_pos#1,_zPos];
			},   //statement
				0.1, //seconds timeout
			[_target,_speed,_heading,_zPos]
		] call CBA_fnc_addPerFrameHandler;
		[{[_this] call CBA_fnc_removePerFrameHandler;}, _handle, _timeout] call CBA_fnc_waitAndExecute;
		if (!isNull _tank && alive _tank) then {
			_tank doTarget _target;
		};
	};
	case 2: { // pause
		_target setPos [0, 0, 0];
		_timeout = random 60;
	};
};

//transition to next state
_state = _state + 1;
if (_state > 2) then {
	_state = 0;
};
_target setVariable ["irn_random_target_state",_state];
if (missionNamespace getVariable ["DEBUG",false]) then {
	diag_log [_target, "transition from ",_state - 1, " to ",_state," wait ",_timeout, " seconds"];
};

// schedule next update call
_targetState = [
	_tank,
	_heading,
	_originPos,
	_state
];
[FUNC(randomTargetUpdate), [_target,_targetState], _timeout] call CBA_fnc_waitAndExecute;


