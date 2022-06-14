_parse = params [
	["_shape",[],[[]],[3]]
];

if (!_parse) exitWith {
	["invalid shape input"] call BIS_fnc_error;
	false;
};

_parse = _shape params [
	["_type","",["owo"]],
	["_anchor",objNull,[objNull,[]],[3]],
	["_shapeParams",[],[[]],[1,2]]
];

if (!_parse) exitWith {
	["invalid shape input"] call BIS_fnc_error;
	false;
};

if !(_type in ["circle","rect"]) exitWith {
	["invalid shape type"] call BIS_fnc_error;
	false;
};

if (_anchor isEqualTo objNull) exitWith {
	systemChat ("anchor="+str _anchor);
	["invalid anchor point"] call BIS_fnc_error;
	false;
};

if (_shapeParams isEqualTo []) exitWith {
	["invalidshape params"] call BIS_fnc_error;
	false;
};

_legal = true;
switch _type do {
	case "circle": {
		if !(_shapeParams isEqualTypeArray [5] && {(_shapeParams#0 > 0)}) then {
			["invalid circle parameters"] call BIS_fnc_error;
			_legal = false;
		}
	};
	case "rect": {
		if !(_shapeParams isEqualTypeArray [[],[]] && {_shapeParams#0 isEqualTypeArray [1,2,3]} && {_shapeParams#1 isEqualTypeArray [1,2,3]}) then {
			["invalid rect parameters"] call BIS_fnc_error;
			_legal = false;
		}
	};
	default {
		["invalid type"] call BIS_fnc_error;
		_legal = false;
	};
};

_legal


