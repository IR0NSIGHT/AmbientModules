#include "script_component.hpp"
// only executed on client

//call FUNC(printAddonName);
call FUNC(zeusModules_init);

#ifdef DEBUG_MODE_FULL
	diag_log QFUNC(aaAmbient);
	diag_log QFUNC(aaAmbientDialog);
	diag_log QFUNC(aaAmbientModule);
	diag_log QFUNC(aaSniper);
	diag_log QFUNC(aaSniperModule);
	diag_log QFUNC(airstrikeModule);
	diag_log QFUNC(ambientAirtraffic);
	diag_log QFUNC(ambientAirtrafficModule);
	diag_log QFUNC(ambPlanes_ParamSelection);
	diag_log QFUNC(ambPlanes_PlaneSelection);
	diag_log QFUNC(ambPlanes_WeightSelection);
	diag_log QFUNC(artilleryInitializer);
	diag_log QFUNC(artilleryVolley);
	diag_log QFUNC(artilleryVolleyDialog);
	diag_log QFUNC(artilleryVolleyModule);
	diag_log QFUNC(cruiseMissile);
	diag_log QFUNC(cruiseMissileDialog);
	diag_log QFUNC(cruiseMissileModule);
	diag_log QFUNC(getObjectBasis);
	diag_log QFUNC(getRndPointInShape);
	diag_log QFUNC(isShape);
	diag_log QFUNC(outlineShape);
	diag_log QFUNC(printAddonName);
	diag_log QFUNC(randomTargetInit);
	diag_log QFUNC(randomTargetModule);
	diag_log QFUNC(randomTargetUpdate);
	diag_log QFUNC(rect_getEdgePoints);
	diag_log QFUNC(rect_getSidesWorld);
	diag_log QFUNC(stabilizeHurt);
	diag_log QFUNC(strikePosition);
	diag_log QFUNC(strikePositionDialog);
	diag_log QFUNC(strikePositionList);
	diag_log QFUNC(zeusModules_init);
	diag_log QFUNC(zeusSelectedCallback);
	diag_log QFUNC(autoArsenal);
	diag_log QFUNC(autoArsenalModule);
	systemChat "HELLO WORLD";
#endif
