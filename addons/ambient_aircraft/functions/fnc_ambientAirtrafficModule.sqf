#include "script_component.hpp"

_logic = param [0, objNull, [objNull]];
_units = param [1, [], [[]]];
_activated = param [2, true, [true]];
if (!isServer) exitWith {};	//is this necessary?

//parse values
_planeClass = parseSimpleArray (_logic getVariable ["planeClass", "['I_Plane_Fighter_03_dynamicloadout_F']"]);
_weights = parseSimpleArray (_logic getVariable ["weights", "[2]"]);	//relative weights
_squadSize = parseSimpleArray (_logic getVariable ["squadsize", "[2]"]);	//maximum squad sizes

_includeZones = parseSimpleArray (_logic getVariable ["includeZones", "[]"]) select { _x in allMapMarkers};
_excludeZones = parseSimpleArray (_logic getVariable ["excludeZones", "[]"]) select { _x in allMapMarkers};

if ((count _planeClass) != (count _weights)) then {
    ERROR_MSG("airtraffic eden module parsing error: weights array has wrong number of elements.");
};
if ((count _planeClass) != (count _squadSize)) then {
    ERROR_MSG("airtraffic eden module parsing error: squads array has wrong number of elements.");
};

_timeout = _logic getVariable ["timeout", 10];	//minutes
_duration = _logic getVariable ["duration", 30];	//minutes
_sideId = _logic getVariable ["side", 0];
_side = civilian;    
switch (_sideId) do {
    case 1: {
        _side = blufor;
    };
    case 2: {
        _side = opfor;
    };
    case 3: {
        _side = independent;
    };
    default {
        _side = civilian;
    };
};

_params = [_timeout,_planeClass,_weights,_squadSize,_side,_duration, getPos _logic, _includeZones, _excludeZones];
diag_log ["module airtraffic with values:","params",_params];

if (_activated) then {
	_params call FUNC(ambientAirtraffic);
};
true