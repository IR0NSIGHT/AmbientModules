/* 
*	@Author: IR0NSIGHT 
*	@Date: 2022-06-08 12:57:47 
*	@Last Modified time: 2022-06-08 12:57:47 
*	 
*	Description: 
*		calculate the 4 edge points as worldpos of a rectangle. 
* 
*	Environment: 
*		any, any
*		 
*	Parameter(s): 
*		0: rect-shape - ["rect",achorpoint/object,[side1,side2]]
*		 
*	Returns: 
*		array of edgepoints in format [anchor,anchor+s1,anchor+s2,anchor+s1+s2]
* 
*	Examples: 
*		["rect",player",[[10,10,0],[10,-10,0]]] call FUNC(rect_getEdges
*/
#include "script_component.hpp"

params ["_shape"];
_shape params ["_type","_anchor","_sides"];
if (_anchor isEqualType objNull) then {
	_anchor = getPosASL _anchor;
};
_sides = [_shape] call FUNC(rect_getSidesWorld);
_sides params ["_side1World","_side2World"];
_out = [_anchor,_anchor vectorAdd _side1World,_anchor vectorAdd _side2World,_anchor vectorAdd _side1World vectorAdd _side2World];
_out