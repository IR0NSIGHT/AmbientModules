class CfgFunctions {
    class irn {
        class debug {
            file = "IRN_AmbientModules\functions\debug";
            class test_helloWorld {};
        }
        class Ambience {
            file = "IRN_AmbientModules\functions\ambience";
            class ambientAirtraffic {};
            //ambient airtraffic zeus dialog functions
            class ambPlanes_ParamSelection {};
            class ambPlanes_PlaneSelection {};
            class ambPlanes_WeightSelection {};
            //

        };

        class support {
            file =  "IRN_AmbientModules\functions\support";

            class artilleryVolley {};
            class artilleryVolleyDialog {};

            class cruiseMissile {};
            class cruiseMissileDialog {};
            class cruiseMissileModule {};

            class strikePosition {};
            class strikePositionDialog {};
            class airstrikeModule {};
            
            class strikePositionList {};    //TODO
        };

        class init {
            file = "IRN_AmbientModules\functions";
            class zeusModules_init {
                postInit = 1;
            };
        };
        
		#include "functions\shape\shape.hpp"
		#include "functions\AntiAir\init.hpp"
		
    };
};