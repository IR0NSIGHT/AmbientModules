/**
	Call this at mission start to register the ZEN modules via script.
*/

//Single airstrike
[
	"Fire Support",
	"Single Airstrike",
	irn_fnc_strikePositionDialog,
	"\a3\modules_f\data\portraitmodule_ca.paa"
] call zen_custom_modules_fnc_register;

//##########################