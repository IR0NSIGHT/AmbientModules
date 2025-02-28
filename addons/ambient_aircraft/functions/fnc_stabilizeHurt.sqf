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


[_dude] spawn { 
    params ["_dude"]; 
    [player, _dude] call ace_medical_treatment_fnc_fullHeal; 
	[_dude, true] call ace_medical_fnc_setUnconscious;
    sleep 0.5; 
    for "_i" from 0 to 5 do { 
        [_dude, [[1, selectRandom[
            "Body",
            "Head",
            "LeftArm",
            "RightArm",
            "LeftLeg",
            "RightLeg"], 1]], "bullet"] remoteExecCall ["ace_medical_damage_fnc_woundsHandlerBase"]; 
    }; 
}