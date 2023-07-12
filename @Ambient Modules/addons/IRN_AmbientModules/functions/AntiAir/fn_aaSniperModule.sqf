_logic = param [0, objNull, [objNull]];
_units = param [1, [], [[]]];
_activated = param [2, true, [true]];
// module specific behavior. Function can extract arguments from logic and use them.
if (_activated) then {
    {
        [_x] spawn IRN_fnc_aaSniper;
        diag_log ["activate sniper anti-air from module for: ", _x];
    } forEach _units
};
true