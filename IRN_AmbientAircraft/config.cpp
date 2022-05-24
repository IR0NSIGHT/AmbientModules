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
		class ModuleDescription;
		class Module_F {
            class Edit; //import this thingy
        };
		class ModuleAmbientAirtraffic: Module_F
		{
			author = "IR0NSIGHT";
			//??? _generalMacro = "ModuleAmbientBattles";
			scope = 2;
			icon = "\a3\Modules_F_Curator\Data\iconSmoke_ca.paa";
			portrait = "\a3\Modules_F_Curator\Data\portraitSmoke_ca.paa";
			displayName = "Ambient Airtraffic";
			category = "Effects";
			function = "IRN_fnc_ambientAirtrafficModule";
			is3DEN = 1;
			isGlobal = 0; //only server
			isTriggerActivated = 1;
			class Arguments //make buttons n stuff
			{
				class distance: Edit
				{
					displayName = "Distance";
					description = "Distance of Sounds (closer means louder)";
	
				};
				class duration
				{
					displayName = "Duration";
					description = "Duration of Sounds in Minutes";
					class values
					{                  
						class 1
                        {
                            name = "1 Minute";
                            value = "60";
                            default = 1;
                        };
                        class 2
                        {
                            name = "2 Minutes";
                            value = "120";
                        };
                        class 5
                        {
                            name = "5 Minutes";
                            value = "300";
                        };
                        class 10
                        {
                            name = "10 Minutes";
                            value = "600";
                        };
                        class 30
                        {
                            name = "30 Minutes";
                            value = "1800";
                        };
                        class 60
                        {
                            name = "60 Minutes";
                            value = "3600";
                        };
                        class 120
                        {
                            name = "120 Minutes";
                            value = "7200";
                        };
                        class Infinite
                        {
                            name = "Infinite";
                            value = "25555555";
                        };
					};
				};
			};
			class ModuleDescription: ModuleDescription
			{
				position = 1;
				description = "Create ambient battle sounds. Sound center is module position.";
			};
		};
	};

#include "CfgFunctions.cpp"