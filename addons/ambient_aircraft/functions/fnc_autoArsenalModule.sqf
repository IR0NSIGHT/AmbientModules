#include "script_component.hpp"

_logic = param [0, objNull, [objNull]];
_units = param [1, [], [[]]];
_activated = param [2, true, [true]];

diag_log ["AUTO ARSENAL CALLED",_this];
// module specific behavior. Function can extract arguments from logic and use them.
if (_activated) then {
    private _onlySynched = _logic getVariable ["onlySynched",true];
    private _cleanup = _logic getVariable ["cleanup",false];

    _units = [allPlayers,synchronizedObjects _logic] select _onlySynched;

    // organize airstrike on synched objects
    [position _logic, _units, _cleanup] call FUNC(autoArsenal);
};
true