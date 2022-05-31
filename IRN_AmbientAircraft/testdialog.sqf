_content = [
	[
		"checkbox",//type
		["Currywurst rot/weiss","content tooltip"],//displayname + tooltip
		[],
		true
	],
	[
		"checkbox",//type
		["Maultaschenburger","content tooltip"],//displayname + tooltip
		[],
		true
	],
	[
		"checkbox",//type
		["Kartoffelsalat","content tooltip"],//displayname + tooltip
		[],
		true
	],
	[	//dropdown menu
		"combo",
		"Anzahl Pommes",
		[[0,1,2,3,-1],["keine","1","2","3","alle"],1],
		false
	],
	[
		"list",
		["eine Liste","mit zwei bergen"],
		[[west,east,independent,civilian],["west","east","independent","civilian"],0],
		false
	],
	[
		"owners",
		["Seite","seite"]
	]
];
//get all plane configclasses from CfgVehicles. use "apply {className _x}" to get classnames.
_getAllPlanes = {
	_cond = toString {
		(configName _x) isKindOf 'Plane' &&
		getNumber (_x >> 'scope') == 2};
	_planes = (_cond configClasses (configFile>>"CfgVehicles"));
	_planes
};
_planes = [] call _getAllPlanes;
_planeClassnames = _planes apply {configName _x};
_planeDisplayNames = _planes apply {getText (configFile >> 'CfgVehicles' >> (configName _x) >> "displayName")};
_planeTypeContent = [
		"combo",
		"Plane type",
		[_planeClassnames,_planeDisplayNames,0],
		false
];

_bombCountContent = [
	"combo",
	"Amount of Bombs",
	[[1,2,4,8,16],["1 (precise)","2","4","8","16"],1],
	false
];

_flyheightContent = [
	"slider",
	"Fly in height",
	[50,4000,200,{str (50*(round (_this/50)))}],
	false
];

_title = "Single Airstrike this position";
_content = [
	_planeTypeContent,
	_bombCountContent,
	_flyheightContent

];

_onConfirm = {
	params["_output","_args"];
	_output params ["_planeClass","_bombCount","_flyheight"];
	[getPos c_2,_planeClass,_bombCount,_flyheight] call irn_fnc_strikePosition;
	hint ("dialog confirmed"+_output);
	};
_onCancel = {hint ("canceled dialog"+str _this);};
_args = ["owo"];

[_title,_content,_onConfirm,_onCancel,_args] call zen_dialog_fnc_create;


