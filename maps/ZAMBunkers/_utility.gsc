#include maps\mp\gametypes\_hud_util;

cadesPlaced() {
	self endon("death");
	self endon("disconnect");
	for(;;) {
		if ( isDefined( self.cadesPlaces ) ) {
			self.cadesPlaces destroyElem();
			self.cadesPlaces = undefined;
		}
	 
		self.cadesPlaces = createFontString( "objective", 1 );
		self.cadesPlaces setPoint( "TOP", "TOP", 0, 0 );
		self.cadesPlaces.sort = 1001;
		self.cadesPlaces setText("Items placed: ^=" + self.createdBlocks.size);

		if ( isDefined( self.currSettings ) ) {
			self.currSettings destroyElem();
			self.currSettings = undefined;
		}
	 
		self.currSettings = createFontString( "objective", 1 );
		self.currSettings setPoint( "BOTTOM", "BOTTOM", 0, 0 );
		self.currSettings.sort = 1001;
		self.currSettings setText("^5Settings: ^7Spawning: ^=" + self.spawning + "^7, Spacing: ^=" + self.spacing + "^7, Model: ^=" + self.barricadeModel);
		wait .2;
	}
}

ZAMBunkerMakerVersion() {
	self endon("disconnect");
	self endon("death");

	if ( isDefined( self.bunkerMakerVersion ) ) {
		self.bunkerMakerVersion destroyElem();
		self.bunkerMakerVersion = undefined;
	}

	self.bunkerMakerVersion = self createFontString("big", 1.1);
	self.bunkerMakerVersion.glowalpha = 1;
	self.bunkerMakerVersion.glowcolor = (0,0,1);
	self.bunkerMakerVersion setPoint("BOTTOMLEFT", "BOTTOMLEFT", 10, -340);
	self.bunkerMakerVersion.sort = 1001;
	self.bunkerMakerVersion.foreground = false;
	self.bunkerMakerVersion setText("^=ZAMBunkermaker v1.0");
}


helpHUD() {
	self endon("disconnect");
	self endon("death");

	if ( isDefined( self.space ) ) {
		self.space destroyElem();
		self.space = undefined;
	}

	self.space = self createFontString("default", 1);
	self.space setPoint("TOPRIGHT", "TOPRIGHT", -5, 20);
	self.space setText("^5Placement: ^7" + self.spacing);

	if ( isDefined( self.posy ) ) {
		self.posy destroyElem();
		self.posy = undefined;
	}
	
	self.posy = self createFontString("default", 1); 
	self.posy setPoint("TOPRIGHT", "TOPRIGHT", -5, 40);
	self.posy setText("^=[{+actionslot 4}] ^7- ^5Increase Pitch: ^7" + self.positiony);
	
	if ( isDefined( self.posx ) ) {
		self.posx destroyElem();
		self.posx = undefined;
	}

	self.posx = self createFontString("default", 1);
	self.posx setPoint("TOPRIGHT", "TOPRIGHT", -5, 60);
	self.posx setText("^=[{+actionslot 1}] ^7- ^5Increase Yaw: ^7" + self.positionx);
	
	if ( isDefined( self.posz ) ) {
		self.posz destroyElem();
		self.posz = undefined;
	}

	self.posz = self createFontString("default", 1);
	self.posz setPoint("TOPRIGHT", "TOPRIGHT", -5, 80);
	self.posz setText("^=[{+actionslot 3}] ^7- ^5Increase Roll: ^7" + self.positionz);
	
	if ( isDefined( self.spawnB ) ) {
		self.spawnB destroyElem();
		self.spawnB = undefined;
	}

	if ( isDefined( self.spawnB ) ) {
		self.spawnB destroyElem();
		self.spawnB = undefined;
	}

	self.spawnB = self createFontString("default", 1);
	self.spawnB setPoint("TOPRIGHT", "TOPRIGHT", -5, 100);
	self.spawnB setText("^=[{+activate}] ^7- Spawn Block");

	if ( isDefined( self.delB ) ) {
		self.delB destroyElem();
		self.delB = undefined;
	}

	self.delB = self createFontString("default", 1);
	self.delB setPoint("TOPRIGHT", "TOPRIGHT", -5, 120);
	self.delB setText("^=[{+actionslot 2}] ^7- Delete Last Block");

	if ( isDefined( self.speed ) ) {
		self.speed destroyElem();
		self.speed = undefined;
	}

	self.speed = self createFontString("default", 1);
	self.speed setPoint("TOPRIGHT", "TOPRIGHT", -5, 140);
	self.speed setText("^=[{+frag}] ^7- Change Speed");

	if ( isDefined( self.settings ) ) {
		self.settings destroyElem();
		self.settings = undefined;
	}

	self.settings = self createFontString("default", 1);
	self.settings setPoint("TOPRIGHT", "TOPRIGHT", -5, 160);
	self.settings setText("^=[{+smoke}] ^7- Open Settings");
}


buttonWatcher() {
	self endon("disconnect");
	self endon("death");
	self.letGo["use"] = true;
	
	if(!self isHost())
		return;

	while(1) {

		if(self FragButtonPressed()) {
			if(level.Speed == 0) {
				self thread doNotPressed("frag");
				setDvar( "g_speed", 10 );  
				level.Speed = 1;
				self iPrintLnBold("^5g_speed:^7 10");
				wait .5;
			} else if (level.Speed == 1) {
				self thread doNotPressed("frag");
				setDvar( "g_speed", 190 );  
				level.Speed = 0;
				self iPrintLnBold("^5g_speed:^7 190");
				wait .5;
			} 	
		}
										
		if(self ActionSlotFourButtonPressed()) {		
			if(self.positiony == 360) {
				self.positiony = 0;
			} else {
				self.positiony = self.positiony+self.pitchIncrement;
			}
	
			self.posy setText("^=[{+actionslot 4}] ^7- ^5Increase Pitch: ^7" + self.positiony);
		}

		if(self ActionSlotOneButtonPressed()) {
			if(self.positionx == 360) {
				self.positionx = 0;
			} else {
				self.positionx = self.positionx+self.yawIncrement;
			}

			self.posx setText("^=[{+actionslot 1}] ^7- ^5Increase Yaw: ^7" + self.positionx);
		}
				
		if(self ActionSlotThreeButtonPressed()) {
			if(self.positionz == 360) {
				self.positionz = 0;
			} else {
				self.positionz = self.positionz + self.rollIncrement;
			}

			self.posz setText("^=[{+actionslot 3}] ^7- ^5Increase Roll: ^7" + self.positionz);
		}
	
		if(self useButtonPressed() && self.letGo["use"] && level.bunkerList.size < 350) {
			self doNotPressed("use");
			pitch = self.positiony;
			yaw = self.positionz;
			roll = self.positionx;

			angle = (pitch, yaw, roll);

			if(self.spacing == "Normal - Spread Out") {
				origin = self.origin + (0, 0, 10);
			} else {
				origin = self.origin;
			}

			if(self.barricadeModelName == "mp_flag_neutral") {
				origin = self.origin - (0, 0, 5);
			}

			size = level.bunkerList.size;
			self.createdBlocks[self.createdBlocks.size] = size;
			level.bunkerList[size] = createBlock(origin, angle);
			self thread createJumpArea(level.bunkerList[size].location, level.bunkerList[size].angle);
		} else if(level.bunkerList.size > 350) {
			self iprintlnbold("Reached Maximum");
		}

		if(self ActionSlotTwoButtonPressed()) {
			if(self.createdBlocks.size <= 0) {
				self iPrintLnBold("No blocks to delete!");
			} else {
				size = self.createdBlocks.size - 1;
				if(level.blockEnt[self.createdBlocks[size]].model == "mp_flag_neutral") {
					maps\mp\gametypes\_objpoints::deleteObjPoint(maps\mp\gametypes\_objpoints::getObjPointByIndex( level.objPointNames.size - 1 ));
					
					self notify("flag_remove_" + level.numFlags);
					
					level.numFlags--;
				}

				level.blockEnt[self.createdBlocks[size]] delete();
				level.blockEnt[self.createdBlocks[size]] = undefined;
				level.bunkerList[self.createdBlocks[size]].location = undefined;
				level.bunkerList[self.createdBlocks[size]].angle = undefined;
				level.bunkerList[self.createdBlocks[size]] = undefined;
				self.createdBlocks[size] = undefined;
			}
		}

		wait 0.05;
	}
}

createBlock(origin, angle) {
	block = spawnstruct();
	block.location = origin;
	block.angle = angle;
	block.model = self.barricadeModelName;
	return block;
}

createJumpArea(pos, rotation) {	
	jumpArea = spawn("script_model", pos);
	jumpArea setModel(self.barricadeModelName);
	jumpArea.angles = rotation;
	level.blockEnt[level.blockEnt.size] = jumpArea;

	if(self.barricadeModelName == "mp_flag_neutral") {
		level.numFlags++;
		if( level.numFlags % 2 == 0 ) {
			self.exitNode = pos;
			iprintlnbold("Teleportation added. Start: " + self.startNode + ", Exit: " + self.exitNode);
			jumpArea flagIcon(self.startNode, self.exitNode);
			jumpArea.enterLocation = self.startNode;
			jumpArea.exitLocation = self.exitNode; 
			
			size = self.createdBlocks.size - 1;
			level.bunkerList[self.createdBlocks[size]].enterLocation = jumpArea.enterLocation;
			level.bunkerList[self.createdBlocks[size]].exitLocation = jumpArea.exitLocation;
			level.bunkerList[self.createdBlocks[size]-1].enterLocation = jumpArea.enterLocation;
			level.bunkerList[self.createdBlocks[size]-1].exitLocation = jumpArea.exitLocation;
			
			wait 0.01;
        	self thread ElevatorThink(self.startNode, self.exitNode, rotation);
			
		} else {
			self.startNode = pos;
			iprintlnbold("Next up: Add an exit node. " + level.numFlags/2);
		}
	}
}


ElevatorThink(enter, exit, angle) {
    self endon("game_ended");
    self endon("flag_remove_" + level.numFlags);
    self endon("flag_remove_" + level.numFlags+1);
    while (1) {
        for (i = 0; i < level.players.size; i++) {
            if (DistanceSquared(enter, level.players[i].origin) <= Power(50, 2)) {
                level.players[i] SetOrigin(exit);
            }
        }
        wait .25;
    }
}

Power(number, power) {
    returnnumber = 1;
    for (i = 0; i < power; i++) {
        returnnumber *= number;
    }
    return returnnumber;
}

flagIcon(enter, exit) {
    locationObjID = maps\mp\gametypes\_gameobjects::getNextObjID();
    objective_add( locationObjID, "invisible", enter );
    nextObjPoint = maps\mp\gametypes\_objpoints::createTeamObjpoint( "zam_teleporter_start_" + level.numFlags, enter + (0, 0, 120), "all", "compass_waypoint_arrow_green" );
    nextObjPoint setWayPoint( true, "compass_waypoint_arrow_green" );
    objective_position( locationObjID, enter );
    objective_icon( locationObjID, "compass_waypoint_arrow_green" );
    objective_state( locationObjID, "active" );

    locationObjID = maps\mp\gametypes\_gameobjects::getNextObjID();
    objective_add( locationObjID, "invisible", exit );
    nextObjPoint = maps\mp\gametypes\_objpoints::createTeamObjpoint( "zam_teleporter_exit_" + level.numFlags, exit + (0, 0, 120), "all", "compass_waypoint_arrow_red" );
    nextObjPoint setWayPoint( true, "compass_waypoint_arrow_red" );
    objective_position( locationObjID, exit );
    objective_icon( locationObjID, "compass_waypoint_arrow_red" );
    objective_state( locationObjID, "active" );
}

doNotPressed(button) {
	switch(button) {
		case "use":
			if(self useButtonPressed()) {
				self.letGo[button] = false;
				while(1) {
					if(!self useButtonPressed()) {
							self.letGo[button] = true;
							break;
					}
					wait 0.1;
				}
			}
			break;
		case "frag":
			if(self fragButtonPressed()) {
				self.letGo[button] = false;
				while(1) {
					if(!self fragButtonPressed()) {
							self.letGo[button] = true;
							break;
					}
					wait 0.1;
				}
			}
			break;
		case "secoff":
			if(self secondaryOffhandButtonPressed()) {
				self.letGo[button] = false;
				while(1) {
					if(!self secondaryOffhandButtonPressed()) {
							self.letGo[button] = true;
							break;
					}
					wait 0.1;
				}
			}
			break;
		default:
			break;
	}
}

mapNametoReadable(mapName) {
    switch(mapName) {
        case "mp_array":
            mapName = "Array";
            break;
        case "mp_cracked":
            mapName = "Cracked";
            break;
        case "mp_crisis":
            mapName = "Crisis";
            break;
        case "mp_firingrange":
            mapName = "Firing Range";
            break;
        case "mp_duga":
            mapName = "Grid";
            break;
        case "mp_hanoi":
            mapName = "Hanoi";
            break;
        case "mp_cairo":
            mapName = "Havana";
            break;
        case "mp_havoc":
            mapName = "Jungle";
            break;
        case "mp_cosmodrome":
            mapName = "Launch";
            break;
        case "mp_nuked":
            mapName = "Nuketown";
            break;
        case "mp_radiation":
            mapName = "Radiation";
            break;
        case "mp_mountain":
            mapName = "Summit";
            break;
        case "mp_villa":
            mapName = "Villa";
            break;
        case "mp_russianbase":
            mapName = "WMD";
            break;
        case "mp_berlinwall2":
            mapName = "Berlin Wall";
            break;
        case "mp_discovery":
            mapName = "Discovery";
            break;
        case "mp_kowloon":
            mapName = "Kowloon";
            break;
        case "mp_stadium":
            mapName = "Stadium";
            break;
        case "mp_gridlock":
            mapName = "Convoy";
            break;
        case "mp_hotel":
            mapName = "Hotel";
            break;
        case "mp_zoo":
            mapName = "Zoo";
            break;
        case "mp_outskirts":
            mapName = "Stockpile";
            break;
        case "mp_drivein":
            mapName = "Drive In";
            break;
        case "mp_silo":
            mapName = "Silo";
            break;
        case "mp_area51":
            mapName = "Hangar 18";
            break;
        case "mp_golfcourse":
            mapName = "Hazard";
            break;
        default:
            mapName = mapName;
            break;
    }

    return mapName;
}
