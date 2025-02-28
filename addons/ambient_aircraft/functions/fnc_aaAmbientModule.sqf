#include "script_component.hpp"

_logic = param [0, objNull, [objNull]];
_units = param [1, [], [[]]];
_activated = param [2, true, [true]];
// module specific behavior. Function can extract arguments from logic and use them.
if (_activated) then {
    _lethalRange = _logic getVariable ["LethalRange", -1];
    _detectionRange = _logic getVariable ["detectionRange", 3000];
    {
        [_x, _lethalRange, _detectionRange] spawn FUNC(aaAmbient);
        diag_log ["activate ambient anti-air from module for: ", _x, " with lethal=", _lethalRange, " detection=",_detectionRange];
    } forEach _units
};
true