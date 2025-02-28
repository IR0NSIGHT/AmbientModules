/**

	[player, { player sideChat "hello world" },[], 3] call irn_ambient_aircraft_fnc_zeusSelectedCallback
	[this, { _this#0 sideChat "hello world" }, [player], 3] call irn_fnc_zeusSelectedCallback
	TODO add docu for function
 */

#include "script_component.hpp"

params [
	["_object",objNull,[objNull]],
	["_callback",{}],
	["_callbackParams",[]],
	["_timeout",5],
	["_condition",{ true }]
];

if (isDedicated) exitWith {
	diag_log ["can not execute zeus info callback on dedicated server."];
};

if (!isNull _object)  then {
	if (_object in curatorSelected#0 && ([] call _condition)) then {
		_callbackParams call _callback;
	};
	[FUNC(zeusSelectedCallback), [_object,_callback,_callbackParams,_timeout,_condition], _timeout] call CBA_fnc_waitAndExecute;
};
