removeAllWeapons this;
removeAllItems this;
removeAllAssignedItems this;
removeUniform this;
removeVest this;
removeBackpack this;
removeHeadgear this;
removeGoggles this;

_RandomHeadgear = selectRandom ["FGN_AAF_Boonie_Type07","rhsusf_opscore_mar_ut_pelt"];
this addHeadgear _RandomHeadgear;
_RandomGoggles = selectRandom ["FGN_AAF_Shemag_tan","FGN_AAF_Shemag","rhs_scarf","rhsusf_oakley_goggles_blk","",""];
this addGoggles _RandomGoggles;
this forceaddUniform "rhs_uniform_gorka_1_a";
this addVest "FGN_AAF_CIRAS_MM";
this addBackpack "B_Messenger_Coyote_F";

this addWeapon "rhs_weap_sr25";
this addPrimaryWeaponItem "rhsusf_acc_SR25S";
this addPrimaryWeaponItem "rhsusf_acc_M8541";
this addPrimaryWeaponItem "rhsusf_acc_M952V";
this addPrimaryWeaponItem "rhsusf_20Rnd_762x51_SR25_m118_special_Mag";
this addPrimaryWeaponItem "rhsusf_acc_harris_bipod";
this addWeapon "rhsusf_weap_glock17g4";
this addHandgunItem "rhsusf_acc_omega9k";
this addHandgunItem "acc_flashlight_pistol";
this addHandgunItem "rhsusf_mag_17Rnd_9x19_JHP";
this addWeapon "Binocular";

this addItemToUniform "FirstAidKit";
for "_i" from 1 to 2 do {this addItemToUniform "rhsusf_mag_17Rnd_9x19_JHP";};
this addItemToUniform "I_IR_Grenade";
for "_i" from 1 to 6 do {this addItemToVest "rhsusf_20Rnd_762x51_SR25_m118_special_Mag";};
for "_i" from 1 to 2 do {this addItemToVest "rhs_mag_mk3a2";};
this addItemToBackpack "rhsusf_acc_premier_anpvs27";
for "_i" from 1 to 2 do {this addItemToBackpack "rhsusf_20Rnd_762x51_SR25_m62_Mag";};
for "_i" from 1 to 2 do {this addItemToBackpack "rhsusf_20Rnd_762x51_SR25_m993_Mag";};
this addItemToBackpack "rhs_grenade_m15_mag";
this addItemToBackpack "rhs_grenade_anm8_mag";
for "_i" from 1 to 2 do {this addItemToBackpack "rhs_grenade_mkiiia1_mag";};
this linkItem "ItemWatch";
this linkItem "ItemRadio";
this linkItem "NVGoggles_OPFOR";