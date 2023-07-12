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

		// Description base classes (for more information see below):
		class ModuleDescription
		{
			class AnyBrain;
		};
	};

	class IRN_ModuleBase: Module_F
	{

	}

	class IRN_ModuleAirstrikeEden: IRN_ModuleBase
	{
		author = "IR0NSIGHT";
		scope = 2; //editor visible
		category = "AMB_MODS";
		isGlobal = 0; //only server
		isTriggerActivated = 0; //wait till all synched triggers are active

		displayName = "Airstrike_01";
		function = "irn_fnc_test_helloWorld";
		class Attributes: AttributesBase //GUI to define input parameters to function
		{
			// Module-specific arguments:
			class Yield: Combo	//available as _logic getVariable ["Yield", -1];
			{
				property = "TAG_Module_Nuke_Yield";				// Unique property (use "<tag>_<moduleClass>_<attributeClass>" format to ensure that the name is unique)
				displayName = "Nuclear weapon yield";			// Argument label
				tooltip = "How strong will the explosion be";	// Tooltip description
				typeName = "NUMBER";							// Value type, can be "NUMBER", "STRING" or "BOOL"
				defaultValue = "50";							// Default attribute value. Warning: This is an expression, and its returned value will be used (50 in this case).

				// Listbox items:
				class Values
				{
					class 50Mt	{ name = "50 megatons";	value = 50; };
					class 100Mt	{ name = "100 megatons"; value = 100; };
				};
			};
			class Budget: Edit {
                property = "irn_amb_special_budget_id";
                displayName = "Budget stolen from ace";
                typeName = "NUMBER";
                defaultValue = -1;
            };
		};
	};	
};


#include "CfgFunctions.cpp"