#include "script_component.hpp"

params [
	"_positions",
	["_planeCount",1,[0]],
	["_targetRandomRange",50,[2]],
	["_planeClass",-1,[0]],
	["_bombs",nil,[0]],
	["_flyHeight",nil,[0]],
	["_dir",nil,[2]],
	["_side",nil,[west]],
	["_from",[-5000,0,0],[[]]],
	["_to",[5000,0,0],[[]]]
];
diag_log [_this];
_positions = ((_positions apply {
	_out = _x;
	if (_x isEqualType objNull) then {_out = getPosASL _x};
	if (_x isEqualType "") then {_out = getMarkerPos _x};
	_out
}) select {_x isEqualType []});

diag_log ["strike positions:",_this,_positions];
_y = 0;
{
	for "_i" from 0 to (_planeCount-1) do {
		[   
			(_x vectorAdd [-0.5*_targetRandomRange + random _targetRandomRange,-0.5*_targetRandomRange + random _targetRandomRange,0]), 
			_planeClass,  
			_bombs,
			_flyHeight, 
			_dir,
			_side,
			(_from vectorAdd [100*_y,0,0]),   
			(_to vectorAdd [100*_y,0,0]) 
		] spawn FUNC(strikePosition);
		_y = _y + 1;
	};
} forEach (_positions)