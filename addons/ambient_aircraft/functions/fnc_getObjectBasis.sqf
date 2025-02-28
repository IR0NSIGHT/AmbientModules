/* 
*	@Author: IR0NSIGHT 
*	@Date: 2022-06-08 11:41:44 
*	@Last Modified time: 2022-06-08 11:41:44 
*	 
*	Description: 
*		calculate the basis matrix for this object: (forward, right, up)
* 
*	Environment: 
*		any, any
*		 
*	Parameter(s): 
*		0: <type> - (Optional, default <value>) <description> 
*	 
*	Returns: 
*		base matrix 3x3 (forward, right, up)
* 
*	Examples: 
*		[player] callFUNC(getObjectBasis
*/
params [
	["_obj",objNull,[objNull]]
];

if (_obj isEqualTo objNull) exitWith {
	["null object"] call BIS_fnc_error;
};

_forward = vectorNormalized(vectorDir _obj);
_up = vectorNormalized (vectorUp _obj);
_right = _forward vectorCrossProduct _up;
_basis = matrixTranspose [_forward,_right,_up];
//diag_log ["basis for obj",_obj," is:",_basis];
_basis