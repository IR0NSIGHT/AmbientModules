_logic = param [0, objNull, [objNull]];
_units = param [1, [], [[]]];
_activated = param [2, true, [true]];
// module specific behavior. Function can extract arguments from logic and use them.
if (_activated) then {
    private _radius = _logic getVariable "radius";
    private _movingdistance = _logic getVariable "movingdistance";
    private _duration = _logic getVariable "duration";
    private _intensity = _logic getVariable "intensity";
    private _ammoindex = _logic getVariable "ammo";
    
    private _ammoClass = [
        // category: flare, smoke, HE
        // format: [value, name, isFlare]
        // 40mm UGL
        ["F_40mm_White", true],
        ["F_40mm_Red", true],
        ["F_40mm_Green", true],
        ["G_40mm_HE", false],
        
        // 82mm mortar
        // ["Flare_82mm_AMOS_White", " 82mm Flare", true], 	//todo doesnt work?
        ["Smoke_82mm_AMOS_White", false],
        ["Sh_82mm_AMOS", false],
        
        // 155mm mortar
        ["Smoke_120mm_AMOS_White", false],
        ["Sh_155mm_AMOS", false],
        
        // 230mm MRL rocket
        ["R_230mm_HE", false]
    ] select _ammoindex;
    
    _output = [
        "circle",
        _radius,
        nil, // unused rectangle params
        _duration,
        _intensity,
        _ammoClass,
        0, // delay
        _movingdistance, // rolling barrage
        getDir _logic // direction of rolling barrage
    ];
    _args = [getPosASL _logic];
    
    // organize airstrike on synched objects
    [_output, _args] call irn_fnc_artilleryInitializer;
};
true