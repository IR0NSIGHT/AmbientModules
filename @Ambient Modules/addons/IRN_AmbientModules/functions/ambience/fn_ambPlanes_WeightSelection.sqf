/* 
*	@Author: IR0NSIGHT 
*	@Date: 2022-06-15 13:53:39 
*	@Last Modified time: 2022-06-15 13:53:39 
*	 
*	Description: 
*		opens ZEN dialog, called by fn_ambPlanes_PlaneSelection to select weights and squadsize for each planeclass
*		calls fn_ambientAirtraffic on confirm with passed values.
*		Not intended to be used outside of the chain of zeus dialogs for ambient airtraffic
* 
*	Environment: 
*		player, any 
*		 
*	Parameter(s): 
*		0: array of classnames - aircarft classes to use
*		 
*		1: positionASL - pos of zeus module
*		 
*		2: number - timeout between flight in seconds
*		 
*		3: side - side of planes
*		 
*		4: number - duration in minutes of airtraffic 
*		 
*	Returns: 
*		nothing
* 
*	Examples: 
*		_params = [_classes,_pos,_timeout,_side,_duration];
*		_params call IRN_fnc_ambPlanes_WeightSelection;
*/

params ["_classes","_pos","_timeout","_side","_duration"];

_contentArr = [];
{	//generate a checkbox for every existing plane
	_displayName = getText (configFile >> 'CfgVehicles' >> _x >> "displayName");
	_content = [
		"Slider",
		_displayName,
		[
			1,10,1,0
		],
		false
	];
	_contentArr pushBack _content;
	_content = [
		"Slider",
		"Maximum Squad size "+ _displayName,
		[
			1,4,3,0
		],
		false
	];
	_contentArr pushBack _content;
} forEach _classes;

[
	"AMBIENT AIRTRAFFIC WEIGHT SELECTION",
	_contentArr,
	{
		params ["_output","_args"];
		_args params ["_classes","_pos","_timeout","_side","_duration"];
		_weights = [];
		_squads = [];
		{
			if (_forEachIndex % 2 == 0) then {
				_weights pushBack (round _x);
			} else {
				_squads pushBack (round _x);
			}
		} forEach _output;
		_params = [_timeout,_classes,_weights,_squads,_side,_duration,_pos];
		diag_log ["params",_params];
		_params remoteExec ["irn_fnc_ambientAirtraffic",2];
		//_params spawn ;
	},	//confirm
	{},	//cancel
	[_classes,_pos,_timeout,_side,_duration]	//args
] call zen_dialog_fnc_create;


//[300,["C_Plane_Civil_01_F","B_T_VTOL_01_vehicle_F"],[2.56662,4.33053],GUER,30,[3450.23,3807.5,0.00151062]] spawn irn_fnc_ambientAirtraffic;