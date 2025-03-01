/* 
*	@Author: IR0NSIGHT 
*	@Date: 2022-06-05 15:05:20 
*	@Last Modified time: 2022-06-05 15:05:20 
*	 
*	Description: 
*		WORK IN PROGRESS, VERY BOOTLEG, not BaerMitUmlaut approved
*		allows the caller to stabilize a wounded patient. essentially patient is first healed, then dealt random damage (5 bullet wounds).
*		use case: a player peaked a tank, has 67 large wounds and you dont want him to die but also not slow down the group for 23 minutes to recover. 		
*
*	Environment: 
*		TODO, SUSPENDABLE 
*		 
*	Parameter(s): 
*		0: can be of
*			object 		- hurt unit to stablize
*
*	Returns: 
*		nothing
* 
*	Examples: 
*		
*/
#include "script_component.hpp"

params [    //ZEN params
	"_pos",
	["_dude",objNull,[objNull]]
];

if (isNull _dude) exitWith {
	["module must be executed on a unit, was given null object."] call BIS_fnc_error
};

[player, _dude] remoteExecCall ["ace_medical_treatment_fnc_fullHeal", _dude];
[_dude, true] call ace_medical_fnc_setUnconscious;
[{  //dont remember why, but damage dealing must be delayed a bit to take effect.
    _dude = _this;
    _count = [3, 5] select (isPlayer _dude);
    for "_i" from 0 to _count do { 
        [
            _dude,
            1,
            selectRandom[
                "Body",
                "Head",
                "LeftArm",
                "RightArm",
                "LeftLeg",
                "RightLeg"],
            "bullet",
            player
        ] remoteExecCall ["ace_medical_fnc_addDamageToUnit",_dude]; 
    }; 
}, _dude] call CBA_fnc_execNextFrame;
