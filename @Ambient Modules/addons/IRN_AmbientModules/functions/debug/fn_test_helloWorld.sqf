diag_log ["test hello world with params: ", _this];
systemChat str ["test hello world with params: ", _this];

// Argument 0 is module logic.
_logic = param [0,objNull,[objNull]];
// Argument 1 is list of affected units (affected by value selected in the 'class Units' argument))
_units = param [1,[],[[]]];
// True when the module was activated, false when it is deactivated (i.e., synced triggers are no longer active)
_activated = param [2,true,[true]];
// Module specific behavior. Function can extract arguments from logic and use them.
if (_activated) then {
	 // Attribute values are saved in module's object space under their class names
	 _bombYield = _logic getVariable ["Yield",-1]; // (as per the previous example, but you can define your own.)
	 hint format ["Bomb yield is: %1", _bombYield ]; // will display the bomb yield, once the game is started
};
// Module function is executed by spawn command, so returned value is not necessary, but it is good practice.
true;