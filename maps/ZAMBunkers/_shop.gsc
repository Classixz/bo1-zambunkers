#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\ZAMBunkers\_utility;

bunkerSettings() {
    self endon("death");
	self endon("disconnect");
	self endon("joined_team");
	self endon("joined_spectators");
	level endon("game_ended");
    
	while(!self is_bot()) {
		if( self SecondaryOffhandButtonPressed() ) {
            self maps\ZAMBunkers\_menus::ZAMCloseMenus();
            self generateShop(
                                "ZAM BUNKER MOD SETTINGS", 
                                array("Models", "Placements", "Increments", "Save Map Part"), 
                                array(::models, ::placements, ::increments, ::saveMapPart) 
                            );
    	}        
		wait .01;
	}
}

models(a) {
    self generateShop(
                        "Models", 
                        array("Barricade", "Teleportation Flag", "Collider 512x512", "Collider 256x256", "Collider 128x128", "Collider 64x64"),
                        array(::changeModel, ::changeModel, ::void, ::void, ::void, ::void)  
                    ); 
}

placements(a) {
    self generateShop(
                        "Placement", 
                        array("Normal - Spread Out", "Normal - Close Together", "Generated - Ramp", "Generated - Wall", "Generated - Grid", "Generated - Ramp", "Aim - Crosshair"),
                        array(::spawnTypes, ::spawnTypes, ::spawnTypes, ::spawnTypes, ::spawnTypes, ::spawnTypes, ::spawnTypes)  
                    ); 
}

increments(a) {
    self generateShop(
                        "Increments", 
                        array("Pitch [1 - 5 - 10]", "Yaw [1 - 5 - 10]", "Roll [1 - 5 - 10]", "Reset Pitch to 0", "Reset Yaw to 0", "Reset Roll to 0", "Change +- Direction Pitch", "Change +- Direction Yaw", "Change +- Direction Roll"),
                        array(::changeIncrements, ::changeIncrements, ::changeIncrements, ::changeIncrements, ::changeIncrements, ::changeIncrements, ::void, ::void, ::void)  
                    ); 
}

saveMapPart(a) {

    self thread logFile(level.createdBlocks, "level.bunkerList", "createBlock", level.createdBlocks.size);

    self playSoundToPlayer("mpl_turret_alert", self);
    self iPrintLn("^5Bunker list saved! ^7Open your ^=games_mp.log^7 and send it to Classixz!");
    self maps\ZAMBunkers\_menus::ZAMCloseMenus();
}

logFile(array, arrayString, functionString, startingVar) {
    logFile = "";
    level.count = 0;
    LogPrint("\n\n\n/* ============ [ START OF MAP FOR " + mapNametoReadable(getDvar("mapname")) + " by " + self.name + " ] ============ *//*\n");
    for(level.logIncrement = 0; level.logIncrement < self.createdBlocks.size; level.logIncrement++) {
        level.count++;
        if(level.count == 10) {
            logfile = getFormatedLog(level.logIncrement, logfile);
            LogPrint(logfile);
            logfile = "";
            level.count = 0;
        } else {
            logfile = getFormatedLog(level.logIncrement, logfile);
        }
    }
    LogPrint(logfile);
    LogPrint("\n\n\n*//* ============ [ END OF MAP FOR " + mapNametoReadable(getDvar("mapname")) + " by " + self.name + " ] ============ */\n\n\n");
}

getFormatedLog(i, logfile) {
    if(i == self.createdBlocks.size-1 || level.count == 10) {
        append = "/*";
    }   else {
        append = "";
    }

    if(level.count == 0) {
        append = "*/";
    }

    prepend = "";
    if(i == 0) {
        prepend = "*/";
    }
    if(level.count == 1) {
        prepend = "*/";
    }

    location = level.bunkerList[self.createdBlocks[i]].location;
    angle = level.bunkerList[self.createdBlocks[i]].angle;
    model = level.bunkerList[self.createdBlocks[i]].model;

    if(model == "mp_flag_neutral") {
        enterLocation = level.bunkerList[self.createdBlocks[i]].enterLocation;
        exitLocation = level.bunkerList[self.createdBlocks[i]].exitLocation;
        if(isdefined(exitLocation)) {
        	logfile = logfile + prepend + "Flag("+enterLocation+", " + exitLocation + ");\n" + append;
        	level.logIncrement++;
		} else {
			self iprintlnbold("flag error, make sure you have and exit node!");
		}
    } else {
        logfile = logfile + prepend + "Bunker(" + i + ", " + location + ", " + angle + ", \"" + model + "\");\n" + append;
    }
    return logfile;
}

changeModel(item) {
    self.barricadeModel = item;
    switch(item) {
        case "Barricade":
            self.barricadeModelName = "collision_geo_512x512x512";
            break;
        case "Teleportation Flag":
            self.barricadeModelName = "mp_flag_neutral";
            break;
    }
    self maps\ZAMBunkers\_menus::ZAMCloseMenus();
}

changeIncrements(item) {
    switch(item) {
        case "Pitch [1 - 5 - 10]":
            if(self.pitchIncrement == 1) {
                self.pitchIncrement = 5;
            } else if(self.pitchIncrement == 5) {
                self.pitchIncrement = 10;
            } else {
                self.pitchIncrement = 1;
            } 
            break;
        case "Yaw [1 - 5 - 10]":
            if(self.yawIncrement == 1) {
                self.yawIncrement = 5;
            } else if(self.yawIncrement == 5) {
                self.yawIncrement = 10;
            } else {
                self.yawIncrement = 1;
            } 
            break;
        case "Roll [1 - 5 - 10]":
            if(self.yawIncrement == 1) {
                self.yawIncrement = 5;
            } else if(self.yawIncrement == 5) {
                self.yawIncrement = 10;
            } else {
                self.yawIncrement = 1;
            } 
            break;
        case "Reset Pitch to 0":
            self.positiony = 0;
            self.posy setText("^=[{+actionslot 4}] ^7- ^5Increase Pitch: ^7" + self.positiony);
            break;
        case "Reset Yaw to 0":
            self.positionx = 0;
            self.posx setText("^=[{+actionslot 1}] ^7- ^5Increase Yaw: ^7" + self.positionx);
            break;
        case "Reset Roll to 0":
            self.positionz = 0;
            self.posz setText("^=[{+actionslot 3}] ^7- ^5Increase Roll: ^7" + self.positionz);
            break;
    }
    self maps\ZAMBunkers\_menus::ZAMCloseMenus();
}

spawnTypes(item) {
    self.spacing = item;
    self.space setText("^5Placement: ^7" + self.spacing);
    self iprintln("Placement is now: " + item);
    self maps\ZAMBunkers\_menus::ZAMCloseMenus();
}


void(a) {
    self maps\ZAMBunkers\_menus::ZAMCloseMenus();
    self iprintlnbold("^2ACTION TODO: func not mapped");
}

generateShop(title, items, functions) {
    self.inMenu = title;
   
    esc = "^1ESC ^7Exit";

    self.shopItems = [];
    for(i = 0; i < items.size; i++) {
        self.shopItems[i] = spawnstruct();
        self.shopItems[i].item = items[i];
    }

    for(i = 0; i < functions.size; i++) {
        self.shopItems[i].function = functions[i];
    }

    //Undef the rest of the available buttons
    for(i = functions.size; i < 10; i++) {
        self.shopItems[i] = spawnstruct();
        self.shopItems[i].function = ::void;
    }

    //Generate the shoprows
    shopRows = [];
    for(i = 0; i < items.size; i++) {
        shopRows[i] = spawnstruct();
        shopRows[i].row = "ShopMenu_item" + ( i + 1 );
        shopRows[i].item = level.ShopColor1 + "" + (i+1) + ". " + level.ShopColor2 + "" + self.shopItems[i].item;
    }

    //Since setClientDvars cannot recive an array, this should get the job done.
    if(shopRows.size > 0) {
        switch(shopRows.size) {
            case 1:
                self setClientDvars( "ShopMenu_item1", shopRows[0].item, "ShopMenu_item2", " ", "ShopMenu_item3", " ", "ShopMenu_item4", " ", "ShopMenu_item5", " ", "ShopMenu_item6", " ", "ShopMenu_item7", " ", "ShopMenu_item8", " ",  "ShopMenu_item9", " ", "ShopMenu_item0", " ", "ShopMenu_title", title, "ESC_BUTTON", esc );
                break;
            case 2:
                self setClientDvars( "ShopMenu_item1", shopRows[0].item, "ShopMenu_item2", shopRows[1].item, "ShopMenu_item3", " ", "ShopMenu_item4", " ", "ShopMenu_item5", " ", "ShopMenu_item6", " ", "ShopMenu_item7", " ", "ShopMenu_item8", " ",  "ShopMenu_item9", " ", "ShopMenu_item0", " ", "ShopMenu_title", title, "ESC_BUTTON", esc );
                break;
            case 3:
                self setClientDvars( "ShopMenu_item1", shopRows[0].item, "ShopMenu_item2", shopRows[1].item, "ShopMenu_item3", shopRows[2].item, "ShopMenu_item4", " ", "ShopMenu_item5", " ", "ShopMenu_item6", " ", "ShopMenu_item7", " ", "ShopMenu_item8", " ",  "ShopMenu_item9", " ", "ShopMenu_item0", " ", "ShopMenu_title", title, "ESC_BUTTON", esc );
                break;
            case 4:
                self setClientDvars( "ShopMenu_item1", shopRows[0].item, "ShopMenu_item2", shopRows[1].item, "ShopMenu_item3", shopRows[2].item, "ShopMenu_item4", shopRows[3].item, "ShopMenu_item5", " ", "ShopMenu_item6", " ", "ShopMenu_item7", " ", "ShopMenu_item8", " ",  "ShopMenu_item9", " ", "ShopMenu_item0", " ", "ShopMenu_title", title, "ESC_BUTTON", esc );
                break;
            case 5:
                self setClientDvars( "ShopMenu_item1", shopRows[0].item, "ShopMenu_item2", shopRows[1].item, "ShopMenu_item3", shopRows[2].item, "ShopMenu_item4", shopRows[3].item, "ShopMenu_item5", shopRows[4].item, "ShopMenu_item6", " ", "ShopMenu_item7", " ", "ShopMenu_item8", " ",  "ShopMenu_item9", " ", "ShopMenu_item0", " ", "ShopMenu_title", title, "ESC_BUTTON", esc );
                break;
            case 6:
                self setClientDvars( "ShopMenu_item1", shopRows[0].item, "ShopMenu_item2", shopRows[1].item, "ShopMenu_item3", shopRows[2].item, "ShopMenu_item4", shopRows[3].item, "ShopMenu_item5", shopRows[4].item, "ShopMenu_item6", shopRows[5].item, "ShopMenu_item7", " ", "ShopMenu_item8", " ",  "ShopMenu_item9", " ", "ShopMenu_item0", " ", "ShopMenu_title", title, "ESC_BUTTON", esc );
                break;
            case 7:
                self setClientDvars( "ShopMenu_item1", shopRows[0].item, "ShopMenu_item2", shopRows[1].item, "ShopMenu_item3", shopRows[2].item, "ShopMenu_item4", shopRows[3].item, "ShopMenu_item5", shopRows[4].item, "ShopMenu_item6", shopRows[5].item, "ShopMenu_item7", shopRows[6].item, "ShopMenu_item8", " ",  "ShopMenu_item9", " ", "ShopMenu_item0", " ", "ShopMenu_title", title, "ESC_BUTTON", esc );
                break;
            case 8:
                self setClientDvars( "ShopMenu_item1", shopRows[0].item, "ShopMenu_item2", shopRows[1].item, "ShopMenu_item3", shopRows[2].item, "ShopMenu_item4", shopRows[3].item, "ShopMenu_item5", shopRows[4].item, "ShopMenu_item6", shopRows[5].item, "ShopMenu_item7", shopRows[6].item, "ShopMenu_item8", shopRows[7].item,  "ShopMenu_item9", " ", "ShopMenu_item0", " ", "ShopMenu_title", title, "ESC_BUTTON", esc );
                break;
            case 9:
                self setClientDvars( "ShopMenu_item1", shopRows[0].item, "ShopMenu_item2", shopRows[1].item, "ShopMenu_item3", shopRows[2].item, "ShopMenu_item4", shopRows[3].item, "ShopMenu_item5", shopRows[4].item, "ShopMenu_item6", shopRows[5].item, "ShopMenu_item7", shopRows[6].item, "ShopMenu_item8", shopRows[7].item,  "ShopMenu_item9", shopRows[8].item, "ShopMenu_item0", " ", "ShopMenu_title", title, "ESC_BUTTON", esc );
                break;
            case 10:
                self setClientDvars( "ShopMenu_item1", shopRows[0].item, "ShopMenu_item2", shopRows[1].item, "ShopMenu_item3", shopRows[2].item, "ShopMenu_item4", shopRows[3].item, "ShopMenu_item5", shopRows[4].item, "ShopMenu_item6", shopRows[5].item, "ShopMenu_item7", shopRows[6].item, "ShopMenu_item8", shopRows[7].item,  "ShopMenu_item9", shopRows[8].item, "ShopMenu_item0", shopRows[9].item, "ShopMenu_title", title, "ESC_BUTTON", esc );
                break;
            default:
                assertex("Unexpected number of elements in summary array.");
        }
                 
        self openMenu( game[ "HunterMod" ] );
        
        self waittill("shopmenuresp"); //We don't want to render the shop more than once, wait for a response before rendering again.
    }
}
