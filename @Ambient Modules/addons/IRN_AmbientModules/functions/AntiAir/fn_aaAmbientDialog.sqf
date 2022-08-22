/* 
*	@Author: IR0NSIGHT 
*	@Date: 2022-08-22 12:10:07 
*	@Last Modified time: 2022-08-22 12:10:07 
*	 
*	Description: 
*		<function description> 
* 
*	Environment: 
*		SERVER, SUSPENDABLE 
*		 
*	Parameter(s): 
*		0: <type> - (Optional, default <value>) <description> 
*		 
*		1: <type> - (Optional, default <value>) <description> 
*		 
*		2: <type> - (Optional, default <value>) <description> 
*		 
*		3: <type> - (Optional, default <value>) <description> 
*		 
*		4: <type> - (Optional, default <value>) <description> 
*		 
*		5: <type> - (Optional, default <value>) <description> 
*		 
*	Returns: 
*		<return type> 
* 
*	Examples: 
*		[] call IRN_fnc_someFunction 
*/

params [
	"_pos",
	["_obj",objNull,[objNull]]
];

if (isNull _obj) exitWith {
	["module must be executed on a unit, was given null object."] call BIS_fnc_error
};

[
	"Ambient Anti Air",
	[
		[
			"SLIDER",
			["Lethal Range","Will accurately destroy all aircraft inside this radius."],
			[-1,5000,-1,{if (_this < 0) exitWith {"disabled"}; str _this}],
			false
		],
		[
			"SLIDER",
			["Detection Range","Will detect and ambient-engage all aircraft inside this radius."],
			[-1,5000,3000,1],
			false
		]
	],
	{
		params ["_input","_else"];
		_input params ["_lethalRange","_detectionRange"];
		_else params ["_pos","_obj"];
		diag_log ["this:",_this];
		
		//execute function
		_params = [_obj,_lethalRange, _detectionRange];
		_params remoteExec ["IRN_fnc_aaAmbient",2];
	},	//accept
	{},
	[_pos,_obj]
] call zen_dialog_fnc_create;

