#include "script_component.hpp"

_logic = param [0, objNull, [objNull]];
_units = param [1, [], [[]]];
_activated = param [2, true, [true]];
// module specific behavior. Function can extract arguments from logic and use them.
if (_activated) then {
    _altitude = _logic getVariable ["altitude", 150];

    if (count _units != 0) then {
        {
           [_logic, _x, _altitude] spawn FUNC(cruiseMissile);
        } forEach _units
    } else {
        [_logic, nil, _altitude] spawn FUNC(cruiseMissile);
    };
    diag_log ["activate cruise missile from module for: ", _logic, " with params:",[getPosASL _logic, "?spawnpos?", _altitude]];
};
true