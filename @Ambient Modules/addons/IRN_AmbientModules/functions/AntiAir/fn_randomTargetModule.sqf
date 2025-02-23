_logic = param [0, objNull, [objNull]];
_units = param [1, [], [[]]];
_activated = param [2, true, [true]];

// module specific behavior. Function can extract arguments from logic and use them.
if (_activated) then {
	if (isNull _logic) exitWith {
		diag_log "Error: No logic module provided!";
	};

	_synchronizedObjects = synchronizedObjects _logic; // Get all objects linked to the logic
	diag_log ["Synchronized objects found: %1", _synchronizedObjects]; // Log for debugging
	if ((count _synchronizedObjects) != 0) then {
		_synchronizedObjects apply {[_x] call IRN_fnc_randomTargetInit;}
	}
};
true