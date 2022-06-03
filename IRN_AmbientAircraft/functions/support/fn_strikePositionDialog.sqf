//get all plane configclasses from CfgVehicles. use "apply {className _x}" to get classnames.
_getAllPlanes = {
	_cond = toString {
		(configName _x) isKindOf 'Plane' &&
		getNumber (_x >> 'scope') == 2};
	_planes = (_cond configClasses (configFile>>"CfgVehicles"));
	_planes
};
params ["_pos"];
_planes = [] call _getAllPlanes;
_planeClassnames = _planes apply {configName _x};
_planeDisplayNames = _planes apply {getText (configFile >> 'CfgVehicles' >> (configName _x) >> "displayName")};
_planeTypeContent = [
		"combo",
		"Plane type",
		[_planeClassnames,_planeDisplayNames,0],
		false
];
_bombTypeContent = [
	"combo",
	"Bomb type",
	[["ammo_Bomb_SDB","Bo_Mk82","Bomb_03_F"],["250lb SDB - 8m killradius","500lb Mk82 - 51m killradius","565lb KAB-250 - 58m killradius"],1],
	false
];

_bombCountContent = [
	"slider",
	"Amount of Bombs",
	[1,20,3,{
		_out = str (round _this); if ((round _this) == 1) then {_out = "precise"}; _out
		}],
	false
];

_flyheightContent = [
	"slider",
	"Fly in height",
	[5,600,20,{str ((round _this)*10)}],//
	false
];

_directionContent = [
	"slider",
	"Fly in from direction (compass)",
	[0,360,0,{
		_dir = round(_this/45);
		_out = "";
		switch _dir do {
			case 8;
			case 0: {_out = "N";};
			case 1: {_out = "NE";};
			case 2: {_out = "E";};
			case 3: {_out = "SE";};
			case 4: {_out = "S";};
			case 5: {_out = "SW";};
			case 6: {_out = "W";};
			case 7: {_out = "NW";};
			
		};
		_out = str round _this+" "+_out;
		_out
	}],
	false
];
_sideContent = [
	"sides",
	"Side",
	blufor,
	false
];

_title = "Single Airstrike this position";
_content = [
	_planeTypeContent,
	_bombTypeContent,
	_bombCountContent,
	_flyheightContent,
	_directionContent,
	_sideContent
];

_onConfirm = {
	params["_output","_args"];
	_output params ["_planeClass","_bombType","_bombCount","_flyheight","_dir","_side"];
	_args params ["_pos"];

	//format input
	_bombCount = round _bombCount;
	_flyheight = _flyheight * 10;

 	//call airstrike function on server
 	[_pos,_planeClass,_bombType, _bombCount,_flyheight,_dir,_side] remoteExec ["IRN_fnc_strikePosition",2];
};

_onCancel = {};
_args = [_pos];

[_title,_content,_onConfirm,_onCancel,_args] call zen_dialog_fnc_create;
