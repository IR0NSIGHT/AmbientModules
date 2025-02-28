#include "script_component.hpp"

_logic = param [0, objNull, [objNull]];
_units = param [1, [], [[]]];
_activated = param [2, true, [true]];
// module specific behavior. Function can extract arguments from logic and use them.
if (_activated) then {
    _planeClass = _logic getVariable ["planeClass", "I_Plane_Fighter_03_dynamicloadout_F"];
    _bombcount = _logic getVariable ["bombcount", 3];
    _altitude = _logic getVariable ["altitude", 150];
    _sideId = _logic getVariable ["side", 0];
    _side = civilian;
    _targets = _units;
    
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
    _spawnPos = getPosASL _logic vectorAdd [0, _altitude, 0];
    // organize airstrike on synched objects
    {
        _spawnPos = _spawnPos vectorAdd [random 500, random 200, 200 + random 500];
        _dir = (getPosASL _x) getDir _spawnPos;
        [_x, _planeClass, nil, _bombcount,
        _altitude, _dir, _side, _spawnPos, _spawnPos] spawn FUNC(strikeposition);
        
        diag_log ["activate airstrike from module for: ",
            _logic, " with params:", [_x, _planeClass, nil, _bombcount,
            _altitude, _dir, _side, _spawnPos, _spawnPos]];
    } forEach _units
};
true