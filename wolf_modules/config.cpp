
class CfgPatches
{
	class WOLF_Modules
	{
		requiredAddons[] = {"A3_Data_F_Oldman_Loadorder"};
		units[] = {"ModuleAmbientBattles"};
		weapons[] = {};
	};
};

class CfgFunctions
{
	class WOLF
	{
		class a
		{
			class ambientbattles {file = "WOLF_Modules\ambient_battles.sqf";};
		};
	};
	
};

class CfgVehicles 
	{
		class ModuleDescription;
		class Module_F;
		class ModuleAmbientBattles: Module_F
		{
			author = "Wolf Corps";
			_generalMacro = "ModuleAmbientBattles";
			scope = 2;
			icon = "\a3\Modules_F_Curator\Data\iconSmoke_ca.paa";
			portrait = "\a3\Modules_F_Curator\Data\portraitSmoke_ca.paa";
			displayName = "Ambient Battles";
			category = "Effects";
			function = "WOLF_fnc_ambientbattles";
			is3DEN = 1;
			isGlobal = 0;
			isTriggerActivated = 1;
			class Arguments
			{
				class distance
				{
					displayName = "Distance";
					description = "Distance of Sounds (closer means louder)";
					class values
					{                  
						class 50
                        {
                            name = "50 Meter";
                            value = "50";
                            default = 1;
                        };
                        class 100
                        {
                            name = "100 Meter";
                            value = "100";
                        };
                        class 150
                        {
                            name = "150 Meter";
                            value = "150";
                        };
                        class 200
                        {
                            name = "200 Meter";
                            value = "200";
                        };
                        class 250
                        {
                            name = "250 Meter";
                            value = "250";
                        };
                        class 300
                        {
                            name = "300 Meter";
                            value = "300";
                        };
                        class 350
                        {
                            name = "350 Meter";
                            value = "350";
                        };
                        class 400
                        {
                            name = "400 Meter";
                            value = "400";
                        };
                        class 450
                        {
                            name = "450 Meter";
                            value = "450";
                        };
                        class 500
                        {
                            name = "500 Meter";
                            value = "500";
                        };
                        class 550
                        {
                            name = "550 Meter";
                            value = "550";
                        };
                        class 600
                        {
                            name = "600 Meter";
                            value = "600";
                        };
					};
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