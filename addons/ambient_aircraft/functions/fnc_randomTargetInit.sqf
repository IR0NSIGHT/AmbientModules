if (!isServer) exitWith {};
params[
    ["_tank",objNull,[objNull]]
];
diag_log ["init random AA target near vehicle",_tank];
_target = "CBA_B_InvisibleTargetAir" createVehicle position _tank;

_side = switch (side _tank) do {
    case blufor: {opfor};
    case opfor: {blufor};
    default {blufor};
};
_side createVehicleCrew _target;
_target allowDamage false;
_pos = getPosATL _target;
_pos = _pos getPos [random 25, random 360];
_target setPosATL [_pos#0,_pos#1,50];

//add this target to global targets array
_targets = missionnamespace getVariable ["irn_aa_targets", []] select { alive _x };
_targets pushback _target;
missionnamespace setVariable ["irn_aa_targets", _targets];

_tank reveal [_target, 4];
_tank synchronizeObjectsAdd [_target];
_tank setVariable ["irn_aa_target",_target];
_tank doTarget _target;
_tank addEventHandler ["Killed", {
    params ["_unit", "_killer", "_instigator", "_useEffects"];
    deleteVehicle (_unit getVariable ["irn_aa_target",objNull]);
}];
[_target,[_tank]] call FUNC(randomTargetUpdate);
