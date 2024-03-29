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
	irn_fnc_artilleryVolleyDialog,
	"IRN_AmbientModules\images\icon_arty_3.paa"	
]  call zen_custom_modules_fnc_register;

//cruise missile zeus module
[
	"Fire Support",
	"Cruise Missile Strike",
	irn_fnc_cruiseMissileDialog,
	"IRN_AmbientModules\images\icon_cruise_missile.paa"	
] call zen_custom_modules_fnc_register;

//cruise missile zeus module
[
	"AI",
	"Ambient Airtraffic",
	irn_fnc_ambPlanes_ParamSelection,
	"IRN_AmbientModules\images\icon_airtraffic.paa"	
] call zen_custom_modules_fnc_register;


//ambient AA
[
	"Fire Support",
	"Ambient AA",
	irn_fnc_aaAmbientDialog,
	""
] call zen_custom_modules_fnc_register;