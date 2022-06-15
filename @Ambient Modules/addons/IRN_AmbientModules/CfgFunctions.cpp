class CfgFunctions {
    class irn {
        class Ambience {
            file = "IRN_AmbientModules\functions\ambience";
            class aaSniper {};
            class aaAmbient {};
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

            class strikePosition {};
            class strikePositionDialog {};
            class strikePositionList {};    //TODO
        };

        class init {
            file = "IRN_AmbientModules\functions";
            class zeusModules_init {
                postInit = 1;
            };
        };
        #include "functions\shape\shape.hpp"
    };
};