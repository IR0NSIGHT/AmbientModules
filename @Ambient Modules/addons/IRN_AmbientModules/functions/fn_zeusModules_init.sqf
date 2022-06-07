/* 
*	@Author: IR0NSIGHT 
*	@Date: 2022-06-03 17:39:46 
*	@Last Modified time: 2022-06-03 17:39:46 
*	 
*	Description: 
*		initializes the ZEN-based zeus modules:
*		single airstrike, artillery barrage
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
*		[] call IRN_fnc_zeusModules
*/

//Single airstrike zeus module
[
	"Fire Support",
	"Single Airstrike",
	irn_fnc_strikePositionDialog,
	"\a3\modules_f\data\portraitmodule_ca.paa"
] call zen_custom_modules_fnc_register;

// artillery barrage zeus module
[
	"Fire Support",
	"Artillery Barrage", 
	irn_fnc_artilleryVolleyDialog
]  call zen_custom_modules_fnc_register;

//cruise missile zeus module
[
	"Fire Support",
	"Cruise Missile Strike",
	irn_fnc_cruiseMissileDialog
] call zen_custom_modules_fnc_register;