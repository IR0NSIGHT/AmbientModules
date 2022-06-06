/* 
*	@Author: IR0NSIGHT 
*	@Date: 2022-06-05 15:05:20 
*	@Last Modified time: 2022-06-05 15:05:20 
*	 
*	Description: 
*		<function description> 
* 
*	Environment: 
*		SERVER, SUSPENDABLE 
*		 
*	Parameter(s): 
*		0: can be of
*			object 		- target object
*			positionASL	- target position 
*		 
*		1: can be of (optional, default [-5000,-5000,1000])
*			object		- spawn above object (vertical start)
*			positionASL - spawn position for missile 
*
*	Returns: 
*		nothing
* 
*	Examples: 
*		[targetTruck_01] spawn IRN_fnc_cruiseMissile;
*		[[0,800,2222],missile_boat_01] spawn IRN_fnc_cruiseMissile;
*/
// TO BE DONE
	//while {((getPosATL _boat)#2 > -20)} do {

params ["_pos"];
[
	"Cruise missile strike",
	[
		["SLIDER","altitude",
		[50,2000,75,1],
		false],
		["Combo",["Missile spawn direction","will spawn in this direction 5km outside the map."],
		[[0,1,2,3,4,5,6,7],["N","NE","E","SE","S","SW","W","NW"],0],
		false]
	],
	{
		params ["_input","_else"];
		_input params ["_altitude","_spawnDir"];
		_else params ["_pos"];
		_spawnDir = _spawnDir * 45;
		_mapDiagonal = sqrt(2*(worldSize^2));
		_spawnPos = [worldSize/2,worldSize/2] getPos [5000+_mapDiagonal/2,_spawnDir];
		_spawnPos set [2,100];
		_m = createMarker ["pos"+str time,_spawnPos];
		_m setMarkerText "SPAWNPOS";
		_m setMarkerType "hd_dot";
		_params = [_pos,_spawnPos];
		[_pos,_spawnPos,_altitude] execVM "fn_cruiseMissile.sqf";
		//[_pos,_spawnPos] spawn IRN_fnc_cruiseMissile;
	},	//accept
	{},
	[_pos]
] call zen_dialog_fnc_create;

