#include "..\CivilianPresence\common.hpp"
#include "..\OOP_Light\OOP_Light.h"
#include "..\Dialogue\defineCommon.inc"

#define __BOOST_SUSP {CALLSM2("undercoverMonitor", "boostSuspicion", player, 0.2 + (random 0.1))}

private _array = [

	["intro_hello",{
		private _return = [
			[TYPE_SENTENCE,[
				"Hey, can I talk to you for a moment?",
				"Hi! Can I talk to you?",
				"Hey, do you have a second?",
				"Hey! Got a minute?",
				"Hey, I'd like to talk to you."
			],1]
		];
		if(random 1000 < 2)then{
			_return pushBack [TYPE_SENTENCE,[
				"I am nothing but a simulation on some computer.",
				"This all is not real! This is a simulation! What shall we do now?",
				"How can you prove that this world is real? It's all a simulation!",
				"Me and you and this world, we are just a bunch of 1s and 0s!",
				"Help! I don't remember what happened to me 3 minutes ago. I just appeared out of nowhere!!",
				"What has happened? All my furniture is gone and I must sleep on the floor now.",
				"I think therefore I am.",
				"To be is to be perceived.",
				"The only thing I know is that I know nothing",
				"Nothing is enough for the man to whom enough is too little."
			],2];
		};
		_return pushBack [TYPE_JUMP_TO,"intro_question"];
		
		_return;
	}],

	["intro_question",{
		params["_player","_civ"];
		[
			[TYPE_QUESTION,"What do you need?",2],
			[TYPE_ANSWER,"Enemy activity [locations]","info_militaryBases"],
			[TYPE_ANSWER,"agitate","agitate"],
			[TYPE_ANSWER,"Never mind","intro_question_neverMind"]

		];
	}],
	["intro_question_neverMind",{
		[
			[TYPE_SENTENCE, "Never mind",1],
			[TYPE_SENTENCE, "Oke, bye",2]
		]
	}],
	["info_militaryBases",{
		params ["_player","_civ"];
		private _locs = _civ getVariable [CP_VAR_KNOWN_LOCATIONS, []];
		private _return = [[TYPE_SENTENCE,[
			"Do you know any military outposts in the area?",
			"Do you know of any military places around here?",
			"Hey, are there any ... you know ... military places near here?",
			"Have you seen any military activity around here?",
			"Do you know any military locations around here?"
		],1]];

		if (count _locs == 0) then {
			_return append [
				[TYPE_SENTENCE,"No, there aren't any within kilometers of this place.",2],
				[TYPE_SENTENCE,"Oke",1]
			];
		}else{
			if (count _locs == 1) then{
				_return pushBack [TYPE_SENTENCE,[
					"Yeah, I know a place like that",
					"Yeah, I think I know one place"
				],2];
			}else{
				_return pushBack [TYPE_SENTENCE,[
					"Yeah, I know of a few places like that ...",
					"I know a few places"
				],2];
			};

			{//for each location
				private _loc = _x;
				private _type = CALLM0(_loc, "getType");
				private _locPos = CALLM0(_loc, "getPos");
				private _bearing = player getDir _locPos;
				private _distance = player distance2D _locPos;

				// Strings
				private _typeString = CALLSM1("Location", "getTypeString", _type);
				private _bearingString = _bearing call pr0_fnc_dialogue_common_bearingToID;
				private _distanceString = if(_distance < 400) then {
					selectRandom ["quite close.", "within 400 meters.", "right over here.", "five-minute walk from here."]
				} else {
					if (_distance < 1000) then {
						selectRandom ["not too far away from here.", "within a kilometer.", "10 minute walk from here.", "not far from here at all."];
					} else {
						selectRandom ["very far away.", "pretty far away.", "more than a kilometer from here.", "quite a bit away from here."];
					};
				};

				private _intro = selectRandom [
					"There is a ",
					"I know about a",
					"I think there is a",
					"Some time ago I saw a",
					"A friend told me about a",
					"People are nervous about a",
					"People are talking about a",
					"A long time ago there was a",
					"Not sure about the coordinates, there is a"
				];


				private _posString = if (_type == LOCATION_TYPE_POLICE_STATION) then {
					private _locCities = CALLSM1("Location", "getLocationsAtPos", _locPos) select {
						CALLM0(_x, "getType") == LOCATION_TYPE_CITY
					};
					if (count _locCities > 0) then {
						format ["at %1", CALLM0(_locCities select 0, "getName")];
					} else {
						format ["to the %1", _bearingString];
					};
				} else {
					format ["to the %1", _bearingString];
				};

				private _text = format ["%1 %2 %3, %4", _intro, _typeString, _posString, _distanceString];

				//this code runs when sentence is spoken
				private _arg = [_distance, _type];
				private _script = {
					_this#3 params ["_distance","_type"];
					__BOOST_SUSP;

					// reveal the location to player's side
					private _updateLevel = -666;
					private _accuracyRadius = 0;
					private _dist = _distance;
					private _distCoeff = 0.22; // How much accuracy radius increases with  distance

					switch (_type) do {
						case LOCATION_TYPE_CITY: {_updateLevel = CLD_UPDATE_LEVEL_SIDE; };
						case LOCATION_TYPE_POLICE_STATION: {_updateLevel = CLD_UPDATE_LEVEL_SIDE; };
						case LOCATION_TYPE_ROADBLOCK: {
							_updateLevel = CLD_UPDATE_LEVEL_SIDE;
							_accuracyRadius = 50+_dist*_distCoeff;
						};
						case LOCATION_TYPE_CAMP: {_updateLevel = CLD_UPDATE_LEVEL_TYPE_UNKNOWN; _accuracyRadius = 50+_dist*_distCoeff; };
						case LOCATION_TYPE_BASE: {_updateLevel = CLD_UPDATE_LEVEL_TYPE_UNKNOWN; _accuracyRadius = 50+_dist*_distCoeff; };
						case LOCATION_TYPE_OUTPOST: {_updateLevel = CLD_UPDATE_LEVEL_TYPE_UNKNOWN; _accuracyRadius = 50+_dist*_distCoeff; };
						case LOCATION_TYPE_AIRPORT: {_updateLevel = CLD_UPDATE_LEVEL_SIDE; _accuracyRadius = 50+_dist*_distCoeff; };
					};

					if (_updateLevel != -666) then {
						private _commander = CALLSM1("AICommander", "getAICommander", playerSide);
						CALLM2(_commander, "postMethodAsync", "updateLocationData", [_x ARG _updateLevel ARG sideUnknown ARG false ARG false ARG _accuracyRadius]);
					};
				};

				_return pushBack [TYPE_SENTENCE, _text,2,1,_script, _arg];

			}forEach _locs;
		};
		
		_return append [
			[TYPE_SENTENCE,[
				"That's all I can tell you.",
				"I don't know any more than that. I need to go.",
				"Have to be careful out here. I'm going to leave now.",
				"We might be watched, I must go now!",
				"It's dangerous to talk about this out in the open, I have to go!"
			],2],
			[TYPE_SENTENCE,[
				"No problem. See you!",
				"Thanks for helping us. See you around!",
				"Yes, I understand. See you!",
				"Perfect, thanks.",
				"That's okay. See you!"	
			],1],
			[TYPE_JUMP_TO,"#end"]
		];

		_return;
	}],
	["agitate",{
		params ["_player","_civ"];
		private _return = [
			[TYPE_SENTENCE,[
				"Hey, consider joining the resistance. We need you.",
				"You know there's a resistance movement, right? Would you like to join us?",
				"Our group needs people like you.",
				"Join us if you want to liberate this place."
			],1,1,__BOOST_SUSP]
		];

		if (!(_civ getVariable [CP_VAR_AGITATED, false])) then { // If not agitated yet
			_return pushBack [TYPE_SENTENCE,[
				"Alright, I'm going to think about it.",
				"Yeah, I'm tired of those thugs, I'll consider joining.",
				"Thanks, I'll keep it in mind.",
				"I might join some time later, thanks.",
				"It's not like I have anything left to lose ... sure ...",
				"I thought you'd never ask. I'm in.",
				"You son of a bitch, I'm in!",
				"Those bastards destroyed my village and arrested all my friends. Yes, I will join you.",
				"I'm going to find you as soon as I can. Yes, I'm in.",
				"You know what, I will join."
			],2,1,__BOOST_SUSP];

			// Now unit is agitated and suspicious
			_civ setVariable [CP_VAR_AGITATED, true, true];
			_civ setVariable ["bSuspicious", true, true];
			// Also increase activity in the city
			CALLSM("AICommander", "addActivity", [CALLM0(gGameMode, "getEnemySide") ARG getPos player ARG (7+random(7))]);
		} else {
			_return pushBack [TYPE_SENTENCE,[
				"Thanks, I know about that already.",
				"I already know about it, thanks.",
				"I have already heard about it, yes.",
				"Yes, I know.",
				"Shhh ... I know ..."
			],2,1,__BOOST_SUSP];
		};

		_return append [
			[TYPE_SENTENCE,"Oke, good!",2],
			[TYPE_JUMP_TO,"#end"]
		];
		

	}],


	["dont_shoot_me",{
		[
			[TYPE_SENTENCE,[
				"Don't shoot! Please!",
				"Please, don't shoot!",
				"Fuck this shit!",
				"Put the gun away!",
				"I surrender!",
				"I am not armed!",
				"Don't kill me! I have a family!",
				"What do you want??",
				"Leave me alone! Please!",
				"I'm not the guy you are looking for!",
				"Please, put the weapon away!",
				"I have no weapon!",
				"Oh My God!",
				"I am not ready to die!",
				"Someone, help me!"
			],1]
		]
	}],


	["release_start",{
		[
			[TYPE_SENTENCE,[
				"Let me free you",
				"Let me help you",
				"I will untie you while the police are not watching",
				"Run away after I release you",
				"Tell your friends that rebels helped you today!"
			],1],
			[TYPE_JUMP_TO,"#end"]
		]
	}],
	["release_finished",{
		[
			[TYPE_SENTENCE,[
				"Thanks man!",
				"Thank you!",
				"I will never forget that you helped me!"
			],1],
			[TYPE_JUMP_TO,"#end"]
		]
	}]

];

["civilian", _array] call pr0_fnc_dialogue_registerDataSet;
 