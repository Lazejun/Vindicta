#include "common.hpp"

/*
Class: GameMode.LocationGameModeData
Base class of objects assigned as Location.gameModeData
*/

CLASS("LocationGameModeData", "MessageReceiverEx")

	VARIABLE_ATTR("location", [ATTR_SAVE]);

	// 
	METHOD(new)
		params [P_THISOBJECT, P_OOP_OBJECT("_location")];
		T_SETV_PUBLIC("location", _location);
	ENDMETHOD;

	// Meant to do processing and enable/disable respawn at this place based on different rules
	/* virtual */ METHOD(updatePlayerRespawn)
		params [P_THISOBJECT];

	ENDMETHOD;

	METHOD(getMessageLoop)
		gMessageLoopGameMode
	ENDMETHOD;

	METHOD(getRecruitCount) // For common interface
		params [P_THISOBJECT, P_ARRAY("_cities")];
		0
	ENDMETHOD;

	// Returns intel entries for display on the client map UI
	/* public virtual */ METHOD(getMapInfoEntries)
		params [P_THISOBJECT];
		[]

	ENDMETHOD;

	// Overrides the location name
	/* public virtual */ METHOD(getDisplayName)
		params [P_THISOBJECT];
		private _loc = T_GETV("location");
		CALLM0(_loc, "getName")
	ENDMETHOD;

	// STORAGE
	/* override */ METHOD(postDeserialize)
		params [P_THISOBJECT, P_OOP_OBJECT("_storage")];

		// Call method of all base classes
		CALL_CLASS_METHOD("MessageReceiverEx", _thisObject, "postDeserialize", [_storage]);

		T_PUBLIC_VAR("location");

		true
	ENDMETHOD;


ENDCLASS;
