class CfgPatches {
    class irn_ambientAircraft {
        name = "Ambient Aircraft Addon";
        author = "IR0NSIGHT";
        requiredVersion = 1.0;

        requiredAddons[] = {"A3_Modules_F"};
        units[] = {};
        weapons[] = {};
    };
};

class CfgFactionClasses {
    class NO_CATEGORY;
    class irn_myCat: NO_CATEGORY {
        displayName = "meow";
    };
};

class CfgVehicles 
	{

		class Module_F;
		class ModuleAmbientAirtraffic: Module_F
		{
            class Combo;
            class Edit; //import this thingy
			author = "IR0NSIGHT";
			//??? _generalMacro = "ModuleAmbientBattles";
			scope = 2; //editor visible
			icon = "\a3\Modules_F_Curator\Data\iconSmoke_ca.paa";
			portrait = "\a3\Modules_F_Curator\Data\portraitSmoke_ca.paa";
			displayName = "Ambient Airtraffic";
			category = "Effects";
			function = "IRN_fnc_ambientAirtrafficModule";
			is3DEN = 1;
			isGlobal = 0; //only server
			isTriggerActivated = 0; //wait till all synched triggers are active
			class Arguments //make buttons n stuff
			{
                class timeout: Edit {
                    displayName = "Average timeout";
                    description = "Average time in seconds before the next aircraft is spawned.";
                    defaultValue = "120";
                };
				class planes: Edit
				{
					displayName = "Aircraft/Weights";
					description = "Classnames and Weighting of aircraft in an array";
                    defaultValue = "B_Heli_Light_01_dynamicLoadout_F,2,B_Plane_Fighter_01_F,1";
				};
				class duration: Combo
				{
					displayName = "Side";
					description = "Aircrafts will belong to this side.";
					class values
					{                  
						class 1
                        {
                            name = "West";
                            value = "blufor";
                            default = 1;
                        };
                        class 2
                        {
                            name = "East";
                            value = "opfor";
                        };
                        class 3
                        {
                            name = "Independent";
                            value = "ind";
                        };
                        class 4
                        {
                            name = "Civilian";
                            value = "civ";
                        };
					};
				};
			};
		};
	};

#include "CfgFunctions.cpp"