class CfgPatches {
    class irn_ambientAircraft {
        name = "Ambient Aircraft Addon";
        author = "IR0NSIGHT";
        requiredVersion = 1.0;

        requiredAddons[] = {"A3_Modules_F"};
        units[] = {"IRN_ModuleAirstrikeZeus"};
        weapons[] = {};
    };
};

class CfgVehicles 
	{
		class Module_F;	//import
/*
		class IRN_ModuleAmbientAirtraffic: Module_F
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
			isTriggerActivated = 1; //wait till all synched triggers are active
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

        class IRN_ModuleAirstrike: Module_F
		{
           //class Combo;
           //class Edit; //import this thingy
			author = "IR0NSIGHT";
			//??? _generalMacro = "ModuleAmbientBattles";
			scope = 2; //editor visible
			icon = "\a3\Modules_F_Curator\Data\iconSmoke_ca.paa";
			portrait = "\a3\Modules_F_Curator\Data\portraitSmoke_ca.paa";
			displayName = "Airstrike";
			category = "Effects";
			function = "IRN_fnc_airstrikeModule";
			is3DEN = 1;
			isGlobal = 0; //only server
			isTriggerActivated = 1; //wait till all synched triggers are active
			scopeCurator = 2;
			scope = 2;
			//class Arguments //make buttons n stuff
			//{
            //   
			//};
		};
*/
        class IRN_ModuleAirstrikeZeus: Module_F
		{
			author = "IR0NSIGHT";
			scope = 2; //editor visible
			scopeCurator = 2; //zeus visible
			curatorCanAttach=1;//idk yet, seen in ZEN module base

			icon = "\a3\Modules_F_Curator\Data\iconSmoke_ca.paa";
			portrait = "\a3\Modules_F_Curator\Data\portraitSmoke_ca.paa";
			displayName = "Airstrike";
			category = "Effects";
			function = "IRN_fnc_airstrikeModule";
			is3DEN = 0;
			isGlobal = 0; //only server
			isTriggerActivated = 0; //wait till all synched triggers are active
		};
	};

#include "CfgFunctions.cpp"