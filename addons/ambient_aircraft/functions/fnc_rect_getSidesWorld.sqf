/* 
*	@Author: IR0NSIGHT 
*	@Date: 2022-06-08 13:04:12 
*	@Last Modified time: 2022-06-08 13:04:12 
*	 
*	Description: 
*		calculate the worldvectors of the shapes side vectors.
* 		output depends on the anchorobjects rotation.
*
*	Environment: 
*		any,any 
*		 
*	Parameter(s): 
*		0: shape (rect) - ["rect",anchorPoint,[side1,side2]]
*		 
*	Returns: 
*		array of worldvectors: [worldSide1,worldSide2]
* 
*	Examples: 
*		["rect",player",[[10,10,0],[10,-10,0]]] call IRN_fnc_rect_getEdges
*/

params ["_shape"];
_shape params ["_type","_anchor","_sides"];
if !(_type isEqualTo "rect") exitWith {
	["wrong shape type:",_type] call BIS_fnc_error;
};
//get basis of object
_basis = [[1,0,0],[0,1,0],[0,0,1]];
_out = [];
if (_anchor isEqualType objNull) then {
	_basis = [_anchor] call FUNC(getObjectBasis);
	_anchor = getPosASL _anchor;

	//get coordinate vectors as spaltenvector
	_kbv1 = (matrixTranspose [_sides#0]);
	_kbv2 = (matrixTranspose [_sides#1]);
	//worldVector = basis* coordVector 
	_side1World = (_basis matrixMultiply _kbv1) apply {_x#0};	//is a vector in matrix form: [[x],[y],[z]], apply to get [x,y,z]
	_side2World = (_basis matrixMultiply _kbv2) apply {_x#0};
	//diag_log ["basis",_basis,"kbv1",_kbv1,"vAbs1",_side1World,"kbv2",_kbv2,"vAbs2",_side2World];
	_out = [_side1World,_side2World];
} else {	//anchor is a worldpoint, no basis transformation needed.
	_out = _sides;
};
_out;
