/* 
*	@Author: IR0NSIGHT 
*	@Date: 2022-06-03 17:39:46 
*	@Last Modified time: 2022-06-03 17:39:46 
*	 
*	Description: 
*		initializes the ZEN-based zeus modules
* 
*	Environment: 
*		SERVER, SUSPENDABLE 
*		 
*	Parameter(s): none
*		 
*	Returns: 
*		none
* 
*	Examples: 
*		[] call FUNC(zeusModules_init)
*/
#include "script_component.hpp"

//Single airstrike zeus module
[
	"Fire Support",
	"Single Airstrike",
	FUNC(strikePositionDialog),
	"\a3\modules_f\data\portraitmodule_ca.paa"
] call zen_custom_modules_fnc_register;

// artillery barrage zeus module
[
	"Fire Support",
	"Artillery Barrage", 
	FUNC(artilleryVolleyDialog),
	QPATHTOF(images\icon_arty_3.paa)	//use macro to get full path to image here?
]  call zen_custom_modules_fnc_register;

//cruise missile zeus module
[
	"Fire Support",
	"Cruise Missile Strike",
	FUNC(cruiseMissileDialog),
	QPATHTOF(images\icon_cruise_missile.paa)	
] call zen_custom_modules_fnc_register;

//cruise missile zeus module
[
	"AI",
	"Ambient Airtraffic",
	FUNC(ambPlanes_ParamSelection),
	QPATHTOF(images\icon_airtraffic.paa)
] call zen_custom_modules_fnc_register;


//ambient AA
[
	"Fire Support",
	"Ambient AA",
	FUNC(aaAmbientDialog),
	""
] call zen_custom_modules_fnc_register;

//stabilize hurt
[
	"Medical",
	"Stabilize patient",
	FUNC(stabilizeHurt),
	""
] call zen_custom_modules_fnc_register;

//auto arsenal
[
	"Arsenal",
	"Auto Player Arsenal",
	{	diag_log _this;
		[ASLToATL (_this#0)] remoteExec[QFUNC(autoArsenal), 2]},
	""
] call zen_custom_modules_fnc_register;