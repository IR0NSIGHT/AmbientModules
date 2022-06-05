diag_log["module function was called:",_this];

{
	systemChat ("class: "+ className _x);
	systemChat (getText (_x >> "manualControl"));
} forEach configProperties [configFile >> "CfGAmmo","isClass _x"];

_cond = {
	getNumber (_x >> 'manualControl')>0
};
_transporters = (toString _cond) configClasses (configFile >> "CfgAmmo");
hint str (_transporters) apply {configName _x};