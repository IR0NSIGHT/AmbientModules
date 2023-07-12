class CfgPatches {
    class irn_ambientModules {
        name = "Ambient Module Addon";
        author = "IR0NSIGHT";
        requiredVersion = 1.0;

        requiredAddons[] = {"A3_Modules_F","zen_modules","zen_custom_modules"};
        units[] = {"IRN_ModuleAirstrikeZeus"};
        weapons[] = {};
    };
};

class CfgFactionClasses {
    class NO_CATEGORY;
    class AMB_MODS: NO_CATEGORY {
        displayName = "Ambient Modules";
        priority = 2;
        side = 7;
    };
};

class CfgVehicles 
{
	class Logic;
	class Module_F: Logic
	{
		class AttributesBase
		{
			class Default;
			class Edit;					// Default edit box (i.e. text input field)
			class Combo;				// Default combo box (i.e. drop-down menu)
			class Checkbox;				// Default checkbox (returned value is Boolean)
			class CheckboxNumber;		// Default checkbox (returned value is Number)
			class ModuleDescription;	// Module description
			class Units;				// Selection of units on which the module is applied
		};

		// Description base class
		class ModuleDescription;
	};

	class IRN_ModuleBase: Module_F
	{
		author = "IR0NSIGHT";
		category = "AMB_MODS";
	}

	class IRN_Module_AmbientAA: IRN_ModuleBase
	{
		scope = 2; //editor visible
		isGlobal = 0; //only server
		isTriggerActivated = 0; //wait till all synched triggers are active

		displayName = "Ambient Anti-Air";
		function = "irn_fnc_aaAmbientModule";
		class Attributes: AttributesBase //GUI to define input parameters to function
		{

			class LethalRange: Edit {
                property = "irn_amb_ambientAA_lethalRange";
                displayName = "Lethal Range";
				tooltip = "<meters> AA will shoot down enemy aircraft inside this range. -1 to disable";	// Tooltip description
                typeName = "NUMBER";
                defaultValue = -1;
            };
			class DetectionRange: Edit {
                property = "irn_amb_ambientAA_detectionRange";
                displayName = "Detection Range";
				tooltip = "<meters> AA will detect and engange enemy aircraft inside this range";	// Tooltip description
                typeName = "NUMBER";
                defaultValue = 3000;
            };
			class ModuleDescription: ModuleDescription {};
		};
		class ModuleDescription: ModuleDescription {
			description = "Synched AA Units will fire wildly at enemy aircraft without hitting them.";
		}
	};	

	class IRN_Module_SniperAA: IRN_ModuleBase
	{
		scope = 2; //editor visible
		isGlobal = 0; //only server
		isTriggerActivated = 0; //wait till all synched triggers are active

		displayName = "Sniper Anti-Air";
		function = "irn_fnc_aaSniperModule";
		class Attributes: AttributesBase 
		{
			class ModuleDescription: ModuleDescription {};
		};
		class ModuleDescription: ModuleDescription {
			description = "Synched AA Units will instantly see and engage all enemy aircraft within 2km.";
		}
	};	

	class IRN_Module_CruiseMissile: IRN_ModuleBase
	{
		scope = 2; //editor visible
		isGlobal = 0; //only server
		isTriggerActivated = 1; //wait till all synched triggers are active

		displayName = "Cruise Missile Strike";
		function = "irn_fnc_cruiseMissileModule";
		class Attributes: AttributesBase //GUI to define input parameters to function
		{
			class Altitude: Edit {
                property = "irn_amb_cruiseMissile_altitude";
                displayName = "Altitude";
				tooltip = "<meters> Missile will follow terrain in this altitude.";	// Tooltip description
                typeName = "NUMBER";
                defaultValue = 40;
            };
			class ModuleDescription: ModuleDescription {};
		};
		class ModuleDescription: ModuleDescription {
			description = "Will spawn a cruisemissile above synched object when trigger gets activated. If nothing is synched, the missile is spawned outside the map. Missile will target the module position";
		}
	};	

	class IRN_Module_Airstrike: IRN_ModuleBase
	{
		scope = 2; //editor visible
		isGlobal = 0; //only server
		isTriggerActivated = 1; //wait till all synched triggers are active

		displayName = "Airstrike";
		function = "irn_fnc_airstrikeModule";
		class Attributes: AttributesBase //GUI to define input parameters to function
		{
			class planeClass: Edit {
                property = "irn_amb_Airstrike_planeClass";
                displayName = "Plane Classname";
				tooltip = "Which plane to use.";	// Tooltip description
                typeName = "STRING";
                defaultValue = "'I_Plane_Fighter_03_dynamicLoadout_F'";
            };
			class bombCount: Edit {
                property = "irn_amb_Airstrike_bombCount";
                displayName = "Bomb amount";
				tooltip = "How many bombs to drop: 1 = precise hit, many=spread across area";	// Tooltip description
                typeName = "NUMBER";
                defaultValue = 3;
            };
			class altitude: Edit {
                property = "irn_amb_Airstrike_altitude";
                displayName = "Altitude";
				tooltip = "Plane will fly in height x";	// Tooltip description
                typeName = "NUMBER";
                defaultValue = 150;
            };
			class side: Combo
			{
				property = "irn_amb_Airstrike_side";				// Unique property (use "<tag>_<moduleClass>_<attributeClass>" format to ensure that the name is unique)
				displayName = "side";			// Argument label
				tooltip = "Plane will be of side";	// Tooltip description
				typeName = "NUMBER";							// Value type, can be "NUMBER", "STRING" or "BOOL"
				defaultValue = 0;							// Default attribute value. Warning: This is an expression, and its returned value will be used (50 in this case).

				// Listbox items:
				class Values
				{
					class civ	{ name = "Civilian";	value = 0; };
					class blufor { name = "BluFor"; value = 1; };
					class opfor	{ name = "OpFor"; value = 2; };
					class ind	{ name = "Independent"; value = 3; };
				};
			};
			
			class ModuleDescription: ModuleDescription {};
		};
		class ModuleDescription: ModuleDescription {
			description = "Will spawn airstrikes targetting all synched objects upon trigger activation";
		}
	};	
};


#include "CfgFunctions.cpp"