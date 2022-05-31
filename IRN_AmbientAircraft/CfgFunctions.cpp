class CfgFunctions {
    class irn {
        class Ambience {
            file = "IRN_AmbientAircraft\functions\ambience";
            class aaSniper {
                recompile = 1;
            };
            class aaAmbient {   
                recompile = 1;
            };
            class ambPlanes {
                recompile = 1;
            };
            class ambientAirtrafficModule {};

        };

        class support {
            file =  "IRN_AmbientAircraft\functions\support";
            class strikePosition {};
            class strikePositionDialog {};

            class strikePositionList {};
            class airstrikeModule {}; //obsolete (?)
        };

        class init {
            file = "IRN_AmbientAircraft\functions";
            class zeusModules_init {
                postInit = 1;
            };
        }

    };
};