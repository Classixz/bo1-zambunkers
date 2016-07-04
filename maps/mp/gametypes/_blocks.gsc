createBlocks()
{
    level.crateTypes["turret_drop_mp"] = [];
    level.crateTypes["tow_turret_drop_mp"] = [];
    level thread maps\mp\_turret_killstreak::init();
    if(level.bunkerList.size > 0) {
        for(i = 0; i < level.bunkerList.size; i++) {
            if(isDefined(level.bunkerList[i]))
                level thread createJumpArea(level.bunkerList[i].location, level.bunkerList[i].angle);
        }
    }
    if(level.minigunList.size > 0) {
        for(i = 0; i < level.minigunList.size; i++) {
            if(isDefined(level.minigunList[i]))
                level thread createMinigunTurret(level.minigunList[i].location, level.minigunList[i].angle);
        }
    }
}

createJumpArea(pos, rotation)
{
    jumpArea = spawn("script_model", pos);
    jumpArea setModel("mp_supplydrop_ally");
    jumpArea.angles = rotation;
}

createMinigunTurret(pos, rotation)
{
    miniGun = spawnTurret( "auto_turret", pos, "auto_gun_turret_mp" );
    miniGun setModel(level.auto_turret_settings["sentry"].modelBase);
    miniGun SetTurretType("sentry");
    miniGun.angles = rotation;
}

createBlock(origin, angle)
{
    block = spawnstruct();
    block.location = origin;
    block.angle = angle;
    return block;
}

createMinigun(origin, angle)
{
    minigun = spawnstruct();
    minigun.location = origin;
    minigun.angle = angle;
    return minigun;
}


doMaps()
{
	if(getDvar("mapname") == "mp_array") { /** Array **/
		level thread _mapCodes::Array();
	} else if(getDvar("mapname") == "mp_cairo") { /** Havana **/
		level thread _mapCodes::Havana();
	} else if(getDvar("mapname") == "mp_cosmodrome") { /** Launch **/
		level thread _mapCodes::Launch();
	} else if(getDvar("mapname") == "mp_cracked") { /** Cracked **/
		level thread _mapCodes::Cracked();
	} else if(getDvar("mapname") == "mp_crisis") { /** Crisis **/
		level thread _mapCodes::Crisis();
	} else if(getDvar("mapname") == "mp_duga") { /** Grid **/
		level thread _mapCodes::Grid();
	} else if(getDvar("mapname") == "mp_firingrange") { /** Firing Range **/
		level thread _mapCodes::FiringRange();
	} else if(getDvar("mapname") == "mp_hanoi") { /** Hanoi **/
		level thread _mapCodes::Hanoi();
	} else if(getDvar("mapname") == "mp_havoc") { /** Jungle **/
		level thread _mapCodes::Jungle();
	} else if(getDvar("mapname") == "mp_mountain") { /** Summit **/
		level thread _mapCodes::Summit();
	} else if(getDvar("mapname") == "mp_nuked") { /** NukeTown **/
		level thread _mapCodes::NukeTown();
	} else if(getDvar("mapname") == "mp_radiation") { /** Radiation **/
		level thread _mapCodes::Radiation();
	} else if(getDvar("mapname") == "mp_russianbase") { /** WMD **/
		level thread _mapCodes::WMD();
	} else if(getDvar("mapname") == "mp_villa") { /** Villa **/
		level thread _mapCodes::Villa();
	} else if(getDvar("mapname") == "mp_berlinwall2") { /** Berlin Wall **/
		level thread _mapCodes::BerlinWall();
	} else if(getDvar("mapname") == "mp_discovery") { /** Discovery **/
		level thread _mapCodes::Discovery();
	} else if(getDvar("mapname") == "mp_kowloon") { /** Kowloon **/
		level thread _mapCodes::Kowloon();
	} else if(getDvar("mapname") == "mp_stadium") { /** Stadium **/
		level thread _mapCodes::Stadium();
	} else if(getDvar("mapname") == "mp_gridlock") { /** Convoy **/
		level thread _mapCodes::Convoy();
	} else if(getDvar("mapname") == "mp_hotel") { /** Hotel **/
		level thread _mapCodes::Hotel();
	} else if(getDvar("mapname") == "mp_zoo") { /** Zoo **/
		level thread _mapCodes::Zoo();
	} else if(getDvar("mapname") == "mp_outskirts") { /** Stockpile **/
		level thread _mapCodes::Stockpile();
	} else if(getDvar("mapname") == "mp_drivein") { /** Drive-In **/
		level thread _mapCodes::DriveIn();
	} else if(getDvar("mapname") == "mp_silo") { /** Silo **/
		level thread _mapCodes::Silo();
	} else if(getDvar("mapname") == "mp_area51") { /** Hangar 18 **/
		level thread _mapCodes::Hangar18();
	} else if(getDvar("mapname") == "mp_golfcourse") { /** Hazard **/
		level thread _mapCodes::Hazard();
	}
}