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
};


#include "CfgFunctions.cpp"