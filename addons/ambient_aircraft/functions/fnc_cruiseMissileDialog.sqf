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
*		[targetTruck_01] spawn FUNC(cruiseMissile);
*		[[0,800,2222],missile_boat_01] spawn FUNC(cruiseMissile);
*/
// TO BE DONE
	//while {((getPosATL _boat)#2 > -20)} do {
#include "script_component.hpp"

params ["_pos"];
[
	"Cruise missile strike",
	[
		["SLIDER",["Altitude","Missile will fly in this altitude, following the terrain. 200m+ will avoid terrain/sea skimming."],
		[40,2000,75,1],
		false],
		["Combo",["Missile spawn direction","will spawn in this direction 5km outside the map."],
		[[0,1,2,3,4,5,6,7],["N","NE","E","SE","S","SW","W","NW"],0],
		false],
		["VECTOR",["spawn position","Leave at 0,0,0 for directional spawning."],
		[0,0,0],
		false]
	],
	{
		params ["_input","_else"];
		_input params ["_altitude","_spawnDir","_spawnPos"];
		_else params ["_pos"];
		_spawnDir = _spawnDir * 45;
		_mapDiagonal = sqrt(2*(worldSize^2));
		if (_spawnPos isEqualTo [0,0,0]) then {
			_spawnPos = [worldSize/2,worldSize/2] getPos [5000+_mapDiagonal/2,_spawnDir];
			_spawnPos set [2,100];
		};
		//assert spawnpos is 10m above ground or sea
		if ((0 max getTerrainHeightASL _spawnPos)<10) then {
			_spawnPos set [2,_spawnPos#2+10];
		};

		//hint ETA in seconds 
		_distance = _pos distance2D _spawnPos;
		_eta = round(_distance/200);
		hintSilent ("ETA cruise missile: "+str _eta +"s");

		//execute function
		_params = [_pos,_spawnPos,_altitude];
		//_params execVM "fn_cruiseMissile.sqf";
		_params remoteExec [QFUNC(cruiseMissile),2];
	},	//accept
	{},
	[_pos]
] call zen_dialog_fnc_create;

