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

		1: positive number - (Optional, default 50) radius of circle in meters

        2: positive number - (Optional, default 15) duration in seconds

        3: string - (Optional, default "Sh_82mm_AMOS") classname of artillery round to use.

        4: positive number - (Optional, default 250) downwards projectile speed, allows slow speed for flares

        5: positive number - (Optional, default 500) height above ground to spawn projectile at

        6: positive number - (Optional, default 1) average seconds between impacts

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
    ["_center",[],[[]],[3]],    //posASL pls
    ["_radius",50,[-1]],
    ["_duration",15,[-1]],
    ["_projectile","Sh_82mm_AMOS",["owo"]],
    ["_projectileSpeed",250,[0]],
    ["_spawnHeight",500,[0]],
    ["_intensity",1,[-1]]   //seconds between impacts
];
if (!canSuspend) exitWith {
    ["Environment needs to be suspendable."] call BIS_fnc_error;
};
if (!isServer) exitWith {
    ["Must run on server."] call BIS_fnc_error;
};

//TODO test for params to not be nonsense 
_stopTime = time + _duration;
while {time < _stopTime} do {
    //get random position uniform across circle
    _length = _radius*(sqrt(random 1)); //root bc: pi*(sqrt(rand)*r)^2 = pi*rand*r => uniform distribution across circle
    _theta = (random 1) * 360;
    _dir = [_length*cos(_theta),_length*sin(_theta),0];
    _dir set [2,_dir#2+ _spawnHeight +random _spawnHeight/2];    //300m above ground
    _pos = _center vectorAdd _dir;
    //spawn projectile
    _proj = createVehicle[_projectile,_pos];
    _proj setPosWorld _pos;
    _proj setVelocity [0,0,-_projectileSpeed];
    _proj setVectorDirAndUp[[0,0,-1],[1,0,0]];
    sleep random [0,_intensity,2*_intensity];
};
