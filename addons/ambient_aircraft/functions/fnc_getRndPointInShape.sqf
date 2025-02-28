/* 
*	@Author: IR0NSIGHT 
*	@Date: 2022-06-08 13:28:15 
*	@Last Modified time: 2022-06-08 13:28:15 
*	 
*	Description: 
*		get a random, uniformly space point (posASL) in shape
* 
*	Environment: 
*		any, any
*		 
*	Parameter(s): 
*		0: shape - a shape that shapes a shape.
*		 
*	Returns: 
*		point ASL inside of shape
* 
*	Examples: 
*		[
			["rect",anchor_01,[[100,100,0],[100,-200]]]
		] call IRN_fnc_getRndPointInShape
*/

params ["_shape"];
_shape params ["_type","_anchorPoint","_shapeParams"];
if (_anchorPoint isEqualType objNull) then {
	_anchorPoint = getPosASL _anchorPoint;
};
_randPos = [];
switch _type do {
	case "circle": {
		_shapeParams params ["_radius"];
		//get random position uniform across circle
		//root bc: pi*(sqrt(rand)*r)^2 = pi*rand*r => uniform distribution across circle
		_randRadius = _radius*(sqrt(random 1)); 
		//random angle
		_theta = (random 1) * 360;
		_dir = [_randRadius*cos(_theta),_randRadius*sin(_theta),0];
		//_dir set [2,200];
		_randPos = _anchorPoint vectorAdd _dir;
	};
	case "rect": {  //doesnt have to be reactuangular, but needs to have 2 sides.
		_sidesWorld = [_shape] call irn_fnc_rect_getSidesWorld;
		diag_log ["sidesWorld of shape =",_sidesWorld];
		_sidesWorld params ["_side01","_side02"];
		_aVal = random 1;
		_bVal = random 1;
		_randPos = ((_anchorPoint vectorAdd (_side01 vectorMultiply _aVal)) vectorAdd (_side02 vectorMultiply _bVal));
	};
	default {
		["invalid shape given, did not match any type:",_shape] call BIS_fnc_error;
	};
};
_randPos