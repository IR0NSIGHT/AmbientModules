/*
	Author: IR0NSIGHT

	Description:
		Spawns artillery fire, hitting randomly inside a defined circle, distributed uniformly. Highly customizable.
        Allows for large scale bombardment, high intensity precise barrages, illumination with flares, smoking an area etc.
    
    Environment:
        Server
        Suspendable

	Parameter(s):
		0: posASL - center of the circle in position ASL
            ["shapetype",[shapeparams]]
                ["circle",[centerPosASL,radius]]
                ["rect",anchorPoint/Object,[startPos,endPos]]
		1: positive number - (Optional, default 50) radius of circle in meters

        2: positive number - (Optional, default 15) duration in seconds

        3: positive number - (Optional, default 1) average seconds between impacts

        4: positive number - (Optional, default 250) downwards projectile speed, allows slow speed for flares

        5: positive number - (Optional, default 500) height above ground to spawn projectile at

        6: string - (Optional, default "Sh_82mm_AMOS") classname of artillery round to use.

	Returns:
		none

	Examples:
		[getPosWorld player, 500, 60] spawn irn_fnc_artilleryVolley;

*/

{
	if (_x isKindOf "Sign_Sphere200cm_F") then {
		deleteVehicle _x;
	};
} foreach allMissionObjects "all";

params [
    ["_shape",[],[[], objNull],[3]],    //posASL pls
    ["_duration",15,[-1]],
    ["_intensity",1,[-1]],  //seconds between impacts
    ["_projectile","Sh_82mm_AMOS",["owo"]],
    ["_projectileSpeed",250,[0]],
    ["_spawnHeight",500,[0]]
       
];
_shape params ["_shapeType","_shapeAnchor"];
if (!canSuspend) exitWith {
    ["Environment needs to be suspendable."] call BIS_fnc_error;
};
if (!isServer) exitWith {
    ["Must run on server."] call BIS_fnc_error;
};

//TODO test for params to not be nonsense 
_stopTime = time + _duration;
while {time < _stopTime && (_shapeAnchor isEqualType [] || {!isNull _shapeAnchor})} do {
    _rndPos = [_shape] call irn_fnc_getRndPointInShape;
    _pos = _rndPos vectorAdd [0,0,(1+random 0.5)*_spawnHeight];
    //spawn projectile
    private ["_proj"];

    _proj = createVehicle[_projectile,[-5000,-5000,5000+random 1000]];
    sleep 0.02; //required otherwise the 230mm rocket just fucking glitches and dissapears.
    _proj setPosWorld _pos;
    _proj setVectorDirAndUp[[0,0,-1],[1,0,0]];

    //set velocity
    _v = [0,0,-_projectileSpeed];// vectorAdd wind;
    _proj setVelocity _v;

    sleep (-0.02+random [0,_intensity,2*_intensity]);
};


