#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
 
init()
{
        level thread maps\mp\gametypes\_hud::init();
        level.failCODJumper = false;
        
        header = level createServerFontString("default", 1);
        header setPoint("MIDDLEBOTTOM", "MIDDLEBOTTOM", 0, 0);
        header setText(" ");
        
        if(!isDefined(level.bunkerList)) {
                level.tpFlagList = [];
                level.bunkerList = [];
                level.blockEnt = [];
                level.tpFlagEnt = [];
        }
		level.minigunList = [];
		level.bunkerList = [];         
        level thread _settings::ZAMBunkerSettings();
		if(level.workMode == 0) {
        level thread maps\mp\gametypes\_blocks::doMaps();
        level thread maps\mp\gametypes\_blocks::createBlocks();
		}
        level.Speed = 0;
        level.scoreInfo = [];
        level.xpScale = GetDvarInt( #"scr_xpscale" );
        level.codPointsXpScale = GetDvarFloat( #"scr_codpointsxpscale" );
        level.codPointsMatchScale = GetDvarFloat( #"scr_codpointsmatchscale" );
        level.codPointsChallengeScale = GetDvarFloat( #"scr_codpointsperchallenge" );
        level.rankXpCap = GetDvarInt( #"scr_rankXpCap" );
        level.codPointsCap = GetDvarInt( #"scr_codPointsCap" ); 
 
        level.rankTable = [];
 
        precacheShader("white");
 
        precacheString( &"RANK_PLAYER_WAS_PROMOTED_N" );
        precacheString( &"RANK_PLAYER_WAS_PROMOTED" );
        precacheString( &"RANK_PROMOTED" );
        precacheString( &"MP_PLUS" );
        precacheString( &"RANK_ROMANI" );
        precacheString( &"RANK_ROMANII" );
 
		setDvar("g_TeamName_Allies", "^1Classixz ^2Bunker ^=Mod ^4For^6 ZAM");
		setDvar("g_TeamName_Axis", " ");
		setDvar("scr_game_forceradar", 1 ); 
		setDvar("scr_tdm_timelimit", 666 ); 
		setdvar("scr_disable_cac", 1);
		setDvar("scr_disable_weapondrop", 1);
		setdvar("g_allowvote", 0);
	 	setdvar("g_allow_teamchange", 0); 
		setDvar("scr_showperksonspawn", 0); 
		setDvar("scr_game_killstreaks", 1); 

        if ( level.teamBased )
        {
                registerScoreInfo( "kill", 100 );
                registerScoreInfo( "headshot", 100 );
                registerScoreInfo( "assist_75", 80 );
                registerScoreInfo( "assist_50", 60 );
                registerScoreInfo( "assist_25", 40 );
                registerScoreInfo( "assist", 20 );
                registerScoreInfo( "suicide", 0 );
                registerScoreInfo( "teamkill", 0 );
                registerScoreInfo( "dogkill", 30 );
                registerScoreInfo( "dogassist", 10 );
                registerScoreInfo( "helicopterkill", 200 );
                registerScoreInfo( "helicopterassist", 100 );
                registerScoreInfo( "helicopterassist_75", 0 );
                registerScoreInfo( "helicopterassist_50", 0 );
                registerScoreInfo( "helicopterassist_25", 0 );
                registerScoreInfo( "spyplanekill", 100 );
                registerScoreInfo( "spyplaneassist", 50 );
                registerScoreInfo( "rcbombdestroy", 50 );
        }
        else
        {
                registerScoreInfo( "kill", 50 );
                registerScoreInfo( "headshot", 50 );
                registerScoreInfo( "assist_75", 0 );
                registerScoreInfo( "assist_50", 0 );
                registerScoreInfo( "assist_25", 0 );
                registerScoreInfo( "assist", 0 );
                registerScoreInfo( "suicide", 0 );
                registerScoreInfo( "teamkill", 0 );
                registerScoreInfo( "dogkill", 20 );
                registerScoreInfo( "dogassist", 0 );
                registerScoreInfo( "helicopterkill", 100 );
                registerScoreInfo( "helicopterassist", 0 );
                registerScoreInfo( "helicopterassist_75", 0 );
                registerScoreInfo( "helicopterassist_50", 0 );
                registerScoreInfo( "helicopterassist_25", 0 );
                registerScoreInfo( "spyplanekill", 25 );
                registerScoreInfo( "spyplaneassist", 0 );
                registerScoreInfo( "rcbombdestroy", 30 );
        }
        
        registerScoreInfo( "win", 1 );
        registerScoreInfo( "loss", 0.5 );
        registerScoreInfo( "tie", 0.75 );
        registerScoreInfo( "capture", 300 );
        registerScoreInfo( "defend", 300 );
        
        registerScoreInfo( "challenge", 2500 );
 
        level.maxRank = int(tableLookup( "mp/rankTable.csv", 0, "maxrank", 1 ));
        level.maxPrestige = int(tableLookup( "mp/rankIconTable.csv", 0, "maxprestige", 1 ));
        
        pId = 0;
        rId = 0;
        for ( pId = 0; pId <= level.maxPrestige; pId++ )
        {
                for ( rId = 0; rId <= level.maxRank; rId++ )
                        precacheShader( tableLookup( "mp/rankIconTable.csv", 0, rId, pId+1 ) );
        }
 
        rankId = 0;
        rankName = tableLookup( "mp/ranktable.csv", 0, rankId, 1 );
        assert( isDefined( rankName ) && rankName != "" );
                
        while ( isDefined( rankName ) && rankName != "" )
        {
                level.rankTable[rankId][1] = tableLookup( "mp/ranktable.csv", 0, rankId, 1 );
                level.rankTable[rankId][2] = tableLookup( "mp/ranktable.csv", 0, rankId, 2 );
                level.rankTable[rankId][3] = tableLookup( "mp/ranktable.csv", 0, rankId, 3 );
                level.rankTable[rankId][7] = tableLookup( "mp/ranktable.csv", 0, rankId, 7 );
                level.rankTable[rankId][14] = tableLookup( "mp/ranktable.csv", 0, rankId, 14 );
 
                precacheString( tableLookupIString( "mp/ranktable.csv", 0, rankId, 16 ) );
 
                rankId++;
                rankName = tableLookup( "mp/ranktable.csv", 0, rankId, 1 );             
        }
 
        level.numStatsMilestoneTiers = 4;
        level.maxStatChallenges = 1024;
        
        buildStatsMilestoneInfo();
        
        level thread createBlocks();
        level thread onPlayerConnect();
}
 
createBlocks()
{
        level.crateTypes["turret_drop_mp"] = [];
        level.crateTypes["tow_turret_drop_mp"] = [];
        level thread maps\mp\_turret_killstreak::init();
        if(level.bunkerList.size > 0) {
                for(i = 0; i < level.bunkerList.size; i++) {
                        if(isDefined(level.bunkerList[i]))
                                level thread maps\mp\gametypes\_thinker::createJumpArea(level.bunkerList[i].location, level.bunkerList[i].angle);
                }
        }
        level.predoneBunkers = level.bunkerList.size;
        if(level.tpFlagList.size > 0) {
                for(i = 0; i < level.tpFlagList.size; i++) {
                        if(isDefined(level.tpFlagList[i]))
                                level thread maps\mp\gametypes\_thinker::createFlag(level.tpFlagList[i].location, level.tpFlagList[i].angle);
                }
        }
        level.predonetpFlag = level.tpFlagList.size;
}
 
getRankXPCapped( inRankXp )
{
        if ( ( isDefined( level.rankXpCap ) ) && level.rankXpCap && ( level.rankXpCap <= inRankXp ) )
        {
                return level.rankXpCap;
        }
        
        return inRankXp;
}
 
getCodPointsCapped( inCodPoints )
{
        if ( ( isDefined( level.codPointsCap ) ) && level.codPointsCap && ( level.codPointsCap <= inCodPoints ) )
        {
                return level.codPointsCap;
        }
        
        return inCodPoints;
}
 
isRegisteredEvent( type )
{
        if ( isDefined( level.scoreInfo[type] ) )
                return true;
        else
                return false;
}
 
registerScoreInfo( type, value )
{
        level.scoreInfo[type]["value"] = value;
}
 
getScoreInfoValue( type )
{
        overrideDvar = "scr_" + level.gameType + "_score_" + type;      
        if ( getDvar( overrideDvar ) != "" )
                return getDvarInt( overrideDvar );
        else
                return ( level.scoreInfo[type]["value"] );
}
 
getScoreInfoLabel( type )
{
        return ( level.scoreInfo[type]["label"] );
}
 
getRankInfoMinXP( rankId )
{
        return int(level.rankTable[rankId][2]);
}
 
getRankInfoXPAmt( rankId )
{
        return int(level.rankTable[rankId][3]);
}
 
getRankInfoMaxXp( rankId )
{
        return int(level.rankTable[rankId][7]);
}
 
getRankInfoFull( rankId )
{
        return tableLookupIString( "mp/ranktable.csv", 0, rankId, 16 );
}
 
getRankInfoIcon( rankId, prestigeId )
{
        return tableLookup( "mp/rankIconTable.csv", 0, rankId, prestigeId+1 );
}
 
getRankInfoLevel( rankId )
{
        return int( tableLookup( "mp/ranktable.csv", 0, rankId, 13 ) );
}
 
getRankInfoCodPointsEarned( rankId )
{
        return int( tableLookup( "mp/ranktable.csv", 0, rankId, 17 ) );
}
 
shouldKickByRank()
{
        if ( self IsHost() )
        {
                return false;
        }
        
        if (level.rankCap > 0 && self.pers["rank"] > level.rankCap)
        {
                return true;
        }
        
        if ( ( level.rankCap > 0 ) && ( level.minPrestige == 0 ) && ( self.pers["plevel"] > 0 ) )
        {
                return true;
        }
        
        if ( level.minPrestige > self.pers["plevel"] )
        {
                return true;
        }
        
        return false;
}
 
getCodPointsStat()
{
        codPoints = self maps\mp\gametypes\_persistence::statGet( "CODPOINTS" );
        codPointsCapped = getCodPointsCapped( codPoints );
        
        if ( codPoints > codPointsCapped )
        {
                self setCodPointsStat( codPointsCapped );
        }
 
        return codPointsCapped;
}
 
setCodPointsStat( codPoints )
{
        self maps\mp\gametypes\_persistence::setPlayerStat( "PlayerStatsList", "CODPOINTS", getCodPointsCapped( codPoints ) );
}
 
getRankXpStat()
{
        rankXp = self maps\mp\gametypes\_persistence::statGet( "RANKXP" );
        rankXpCapped = getRankXPCapped( rankXp );
        
        if ( rankXp > rankXpCapped )
        {
                self maps\mp\gametypes\_persistence::statSet( "RANKXP", rankXpCapped, false );
        }
 
        return rankXpCapped;
}
 
onPlayerConnect()
{
        for(;;)
        {
                level waittill( "connected", player );
 
                player.pers["rankxp"] = player getRankXpStat();
                player.pers["codpoints"] = player getCodPointsStat();
                player.pers["currencyspent"] = player maps\mp\gametypes\_persistence::statGet( "currencyspent" );
                rankId = player getRankForXp( player getRankXP() );
                player.pers["rank"] = rankId;
                player.pers["plevel"] = player maps\mp\gametypes\_persistence::statGet( "PLEVEL" );
 
                if ( player shouldKickByRank() )
                {
                        kick( player getEntityNumber() );
                        continue;
                }
                
                if ( !isDefined( player.pers["participation"] ) || !( (level.gameType == "twar") && (0 < game["roundsplayed"]) && (0 < player.pers["participation"]) ) )
                        player.pers["participation"] = 0;
 
                player.rankUpdateTotal = 0;
                
                player.cur_rankNum = rankId;
                assertex( isdefined(player.cur_rankNum), "rank: "+ rankId + " does not have an index, check mp/ranktable.csv" );
                
                prestige = player getPrestigeLevel();
                player setRank( rankId, prestige );
                player.pers["prestige"] = prestige;
                
                
                if ( !isDefined( player.pers["summary"] ) )
                {
                        player.pers["summary"] = [];
                        player.pers["summary"]["xp"] = 0;
                        player.pers["summary"]["score"] = 0;
                        player.pers["summary"]["challenge"] = 0;
                        player.pers["summary"]["match"] = 0;
                        player.pers["summary"]["misc"] = 0;
                        player.pers["summary"]["codpoints"] = 0;
                }
                player setclientdvar( "ui_lobbypopup", "" );
                
                if ( level.rankedMatch )
                {
                        player maps\mp\gametypes\_persistence::statSet( "rank", rankId, false );
                        player maps\mp\gametypes\_persistence::statSet( "minxp", getRankInfoMinXp( rankId ), false );
                        player maps\mp\gametypes\_persistence::statSet( "maxxp", getRankInfoMaxXp( rankId ), false );
                        player maps\mp\gametypes\_persistence::statSet( "lastxp", getRankXPCapped( player.pers["rankxp"] ), false );                            
                }
                
                player.explosiveKills[0] = 0;
                player.xpGains = [];
                player.createdBlocks = [];
                player.createdtpFlag = [];
                
                player.spacing = "Spread Out";
                player.spawning = "Under";
                
                player.positiony = 0;
                player.positionx = 0;
                player.positionz = 0;
                
                player.blockAngles = (0, 0, 0);
                player.allowBlock = true;
                
                player thread onPlayerSpawned();
                player thread onJoinedTS();
                
                if(player isHost()) {
                        player thread dumpList();
                }
                player thread createHUD();
        }
}
 
createHUD()
{
        self waittill("spawned_player");
        if(self isHost())
                self iPrintLn("^=Message ^7>^7 Press ^5[{+smoke}] ^7to save the bunkers inside main/games_mp.log");
        self.space = self createFontString("default", 1);
        self.space setPoint("TOPRIGHT", "TOPRIGHT", -5, 0);
        self.space setText("^=[{+melee}] ^7+ ^=[{+gostand}] ^7- ^5Spacing: ^7" + self.spacing);
       
        self.posy = self createFontString("default", 1); 
        self.posy setPoint("TOPRIGHT", "TOPRIGHT", -5, 20);
        self.posy setText("^=[{+actionslot 4}] ^7- ^5Pitch: ^7" + self.positiony);
        
        
        self.posx = self createFontString("default", 1);
        self.posx setPoint("TOPRIGHT", "TOPRIGHT", -5, 40);
        self.posx setText("^=[{+actionslot 1}] ^7- ^5Yaw: ^7" + self.positionx);
       
        self.posz = self createFontString("default", 1);
        self.posz setPoint("TOPRIGHT", "TOPRIGHT", -5, 60);
        self.posz setText("^=[{+actionslot 3}] ^7- ^5Roll: ^7" + self.positionz);
        
        spawnB = self createFontString("default", 1);
        spawnB setPoint("TOPRIGHT", "TOPRIGHT", -5, 80);
        spawnB setText("^=[{+activate}] ^7- Spawn Block");
        
        delB = self createFontString("default", 1);
        delB setPoint("TOPRIGHT", "TOPRIGHT", -5, 100);
        delB setText("^=[{+actionslot 2}] ^7- Delete Last Block");
        
        save = self createFontString("default", 1);
        save setPoint("TOPRIGHT", "TOPRIGHT", -5, 120);
        save setText("^=[{+smoke}] ^7- Save blocks");
        
        speed = self createFontString("default", 1);
        speed setPoint("TOPRIGHT", "TOPRIGHT", -5, 140);
        speed setText("^=[{+frag}] ^7- Change Speed");
        
        
        count = 0;
        
        self endon("disconnect");
        while(1) {
                if(self jumpButtonPressed() && self meleeButtonPressed()) {
                 /*       if(self.spawning == "Under")
                                self.spawning = "Crosshair";
                        else
                                self.spawning = "Under";
                        self.spawn setText("^3[{+gostand}] ^7and ^3[{+melee}] ^7- ^2Spawn Area: ^7" + self.spawning);*/
                }
                if(count >= 300) {
                        if(self isHost())
                                self iPrintLn("^=Message ^7>^7 Press ^5[{+smoke}] ^7to save the bunkers inside main/games_mp.log");

                        count = 0;
                }
                wait 0.1;
                count++;
        }
}
 
onJoinedTS()
{
        self endon("disconnect");
 
        for(;;)
        {
                self waittill_any("joined_spectators", "joined_team");
                self thread removeRankHUD();
        }
}
showZAMText()
{
		self endon("disconnect");
		self endon("cheats");
		self.zamT destroy();
		self.zamT = self createFontString("big", 1.1);
		self.zamT.glowalpha = 1;
		self.zamT.glowcolor = (0,0,1);
		self.zamT setPoint("BOTTOMLEFT", "BOTTOMLEFT", 10, -340);
		self.zamT.sort = 1001;
		self.zamT.foreground = false;
		self.zamT setText("^=ZAMBunkermaker v0.4");
}

showCoords()
{
	self endon("death");
	self endon("disconnect");
	for(;;)
	{
	 
		self.points destroy();
		self.points = createFontString( "objective", 1 );
		self.points setPoint( "TOP", "TOP", 0, 0 );
		self.points.sort = 1001;
		self.points setText("Cades placed: ^="+self.createdBlocks.size+"^7");
		ClientPrint( self, self.origin + " " + self getPlayerAngles());
		wait .5;
	}
}
onPlayerSpawned()
{
        self endon("disconnect");
 
        for(;;)
        {
                self waittill("spawned_player");
                self.groundLevel = self.origin[2];
                setDvar("bg_fallDamageMinHeight", "10000");
				setDvar("sv_cheats", "1");
                self thread defaultCode();
				self thread showCoords();
				self thread showZAMText();
                if(!isDefined(self.pers["isBot"]) || self.pers["isBot"] == false) {
                        self thread spawnCP();
                }
  
  self takeAllWeapons();
                
  self [[level.allies]]();
   	self GiveWeapon( "camera_spike_mp" );
	self maps\mp\gametypes\_class::setWeaponAmmoOverall( "camera_spike_mp", 1 );
	self SetActionSlot( 1, "weapon", "camera_spike_mp" );	
	self switchtoweapon("camera_spike_mp");	
	self giveWeapon("mpl_grip_dualclip_mp", 0, self calcWeaponOptions( 15, 0, 0, 0, 0 ) );
	self switchToWeapon("mpl_grip_dualclip_mp");
	self giveWeapon( "asp_mp" );	
	self giveWeapon( "knife_mp" );	
	self giveMaxAmmo( "mpl_grip_dualclip_mp" );;
	           
	self setPerk("specialty_sprintrecovery"); 
	self setPerk("specialty_fallheight");
	self setperk("specialty_unlimitedsprint");
	self setPerk("specialty_fastmantle"); 
	self SetMoveSpeedScale(1.15);
                
                
                
        }
}

 
dumpList()
{
        self endon("disconnect");
        while(1) {
                if(self isHost()) {
                        if(self SecondaryOffHandButtonPressed()) {        
                                self thread logFile(level.bunkerList, "level.bunkerList", "createBlock", level.predoneBunkers);
                                wait 0.1;
                                self thread logFile(level.tpFlagList, "level.tpFlagList", "createtpFlag", level.predonetpFlag);
                                self playSoundToPlayer("mpl_turret_alert", self);
                                self iPrintLn("^5Bunker list saved! ^7Open your ^=games_mp.log^7 and send it to Classixz!");
                        }
                }
                if(self ActionSlotTwoButtonPressed())
                {
                        if(self.createdBlocks.size <= 0) {
                                self iPrintLnBold("No blocks to delete!");
                        } else {
                                size = self.createdBlocks.size - 1;
                                level.blockEnt[self.createdBlocks[size]] delete();
                                level.blockEnt[self.createdBlocks[size]] = undefined;
                                level.bunkerList[self.createdBlocks[size]].location = undefined;
                                level.bunkerList[self.createdBlocks[size]].angle = undefined;
                                level.bunkerList[self.createdBlocks[size]] = undefined;
                                self.createdBlocks[size] = undefined;
                        }
                }
                if(self FragButtonPressed() && self isHost())
             		 {
             		 if(level.Speed == 0)
             		 {
             		 	self thread doNotPressed("frag");
             		 	setDvar( "g_speed", 10 );  
             		 	level.Speed = 1;
             		 		self iPrintLnBold("^5g_speed:^7 10");
             		 		wait .5;
             		 }
             		 else if (level.Speed == 1)
             		 {
             		 	self thread doNotPressed("frag");
             		 	setDvar( "g_speed", 190 );  
             		 	level.Speed = 0;
             		 	self iPrintLnBold("^5g_speed:^7 190");
             		 	wait .5;
             		 }
             		 	
             		 }
             		 
             		 
                if(self ActionSlotFourButtonPressed())
             		 {
             		 	
	if(self.positiony == 0)
		self.positiony = 10;
		
	else if(self.positiony == 10)
		self.positiony = 20;
		
	else if(self.positiony == 20)
		self.positiony = 30;
	
	else if(self.positiony == 30)
		self.positiony = 40;
		
	else if(self.positiony == 40)
		self.positiony = 50;
		
	else if(self.positiony == 50)
		self.positiony = 60;
		
	else if(self.positiony == 60)
		self.positiony = 70;
		
	else if(self.positiony == 70)
		self.positiony = 80;
		
	else if(self.positiony == 80)
		self.positiony = 90;

	else if(self.positiony == 90)
		self.positiony = 100;
		
	else if(self.positiony == 100)
		self.positiony = 110;

	else if(self.positiony == 110)
		self.positiony = 120;
		
	else if(self.positiony == 120)
		self.positiony = 130;
	
	else if(self.positiony == 130)
		self.positiony = 140;
		
	else if(self.positiony == 140)
		self.positiony = 150;
		
	else if(self.positiony == 150)
		self.positiony = 160;
		
	else if(self.positiony == 160)
		self.positiony = 170;
		
	else if(self.positiony == 170)
		self.positiony = 180;
		
	else if(self.positiony == 180)
		self.positiony = 190;

	else if(self.positiony == 190)
		self.positiony = 200;
		
	else if(self.positiony == 200)
		self.positiony = 210;
		
	else if(self.positiony == 210)
		self.positiony = 220;
		
	else if(self.positiony == 220)
		self.positiony = 230;
	
	else if(self.positiony == 230)
		self.positiony = 240;
		
	else if(self.positiony == 240)
		self.positiony = 250;
		
	else if(self.positiony == 250)
		self.positiony = 260;
		
	else if(self.positiony == 260)
		self.positiony = 270;
		
	else if(self.positiony == 270)
		self.positiony = 280;
		
	else if(self.positiony == 280)
		self.positiony = 290;

	else if(self.positiony == 290)
		self.positiony = 300;
		
	else if(self.positiony == 300)
		self.positiony = 310;
		
	else if(self.positiony == 310)
		self.positiony = 320;
		
	else if(self.positiony == 320)
		self.positiony = 330;
	
	else if(self.positiony == 330)
		self.positiony = 340;
		
	else if(self.positiony == 340)
		self.positiony = 350;
		
	else if(self.positiony == 350)
		self.positiony = 360;
		
	else if(self.positiony == 360)
		self.positiony = 0;

        self.posy setText("^=[{+actionslot 4}] ^7- ^5Pitch: ^7" + self.positiony);
                 }

                 if(self ActionSlotOneButtonPressed())
                 {
             		 	
	if(self.positionx == 0)
		self.positionx = 10;
		
	else if(self.positionx == 10)
		self.positionx = 20;
		
	else if(self.positionx == 20)
		self.positionx = 30;
	
	else if(self.positionx == 30)
		self.positionx = 40;
		
	else if(self.positionx == 40)
		self.positionx = 50;
		
	else if(self.positionx == 50)
		self.positionx = 60;
		
	else if(self.positionx == 60)
		self.positionx = 70;
		
	else if(self.positionx == 70)
		self.positionx = 80;
		
	else if(self.positionx == 80)
		self.positionx = 90;

	else if(self.positionx == 90)
		self.positionx = 100;
		
	else if(self.positionx == 100)
		self.positionx = 110;

	else if(self.positionx == 110)
		self.positionx = 120;
		
	else if(self.positionx == 120)
		self.positionx = 130;
	
	else if(self.positionx == 130)
		self.positionx = 140;
		
	else if(self.positionx == 140)
		self.positionx = 150;
		
	else if(self.positionx == 150)
		self.positionx = 160;
		
	else if(self.positionx == 160)
		self.positionx = 170;
		
	else if(self.positionx == 170)
		self.positionx = 180;
		
	else if(self.positionx == 180)
		self.positionx = 190;

	else if(self.positionx == 190)
		self.positionx = 200;
		
	else if(self.positionx == 200)
		self.positionx = 210;
		
	else if(self.positionx == 210)
		self.positionx = 220;
		
	else if(self.positionx == 220)
		self.positionx = 230;
	
	else if(self.positionx == 230)
		self.positionx = 240;
		
	else if(self.positionx == 240)
		self.positionx = 250;
		
	else if(self.positionx == 250)
		self.positionx = 260;
		
	else if(self.positionx == 260)
		self.positionx = 270;
		
	else if(self.positionx == 270)
		self.positionx = 280;
		
	else if(self.positionx == 280)
		self.positionx = 290;

	else if(self.positionx == 290)
		self.positionx = 300;
		
	else if(self.positionx == 300)
		self.positionx = 310;
		
	else if(self.positionx == 310)
		self.positionx = 320;
		
	else if(self.positionx == 320)
		self.positionx = 330;
	
	else if(self.positionx == 330)
		self.positionx = 340;
		
	else if(self.positionx == 340)
		self.positionx = 350;
		
	else if(self.positionx == 350)
		self.positionx = 360;
		
	else if(self.positionx == 360)
		self.positionx = 0;
		
		self.posx setText("^=[{+actionslot 1}] ^7- ^5Yaw: ^7" + self.positionx);
                 }
                        
                 if(self ActionSlotThreeButtonPressed()) 
                 {
	
	
	if(self.positionz == 0)
		self.positionz = 10;
		
	else if(self.positionz == 10)
		self.positionz = 20;
		
	else if(self.positionz == 20)
		self.positionz = 30;
	
	else if(self.positionz == 30)
		self.positionz = 40;
		
	else if(self.positionz == 40)
		self.positionz = 50;
		
	else if(self.positionz == 50)
		self.positionz = 60;
		
	else if(self.positionz == 60)
		self.positionz = 70;
		
	else if(self.positionz == 70)
		self.positionz = 80;
		
	else if(self.positionz == 80)
		self.positionz = 90;

	else if(self.positionz == 90)
		self.positionz = 100;
		
	else if(self.positionz == 100)
		self.positionz = 110;

	else if(self.positionz == 110)
		self.positionz = 120;
		
	else if(self.positionz == 120)
		self.positionz = 130;
	
	else if(self.positionz == 130)
		self.positionz = 140;
		
	else if(self.positionz == 140)
		self.positionz = 150;
		
	else if(self.positionz == 150)
		self.positionz = 160;
		
	else if(self.positionz == 160)
		self.positionz = 170;
		
	else if(self.positionz == 170)
		self.positionz = 180;
		
	else if(self.positionz == 180)
		self.positionz = 190;

	else if(self.positionz == 190)
		self.positionz = 200;
		
	else if(self.positionz == 200)
		self.positionz = 210;
		
	else if(self.positionz == 210)
		self.positionz = 220;
		
	else if(self.positionz == 220)
		self.positionz = 230;
	
	else if(self.positionz == 230)
		self.positionz = 240;
		
	else if(self.positionz == 240)
		self.positionz = 250;
		
	else if(self.positionz == 250)
		self.positionz = 260;
		
	else if(self.positionz == 260)
		self.positionz = 270;
		
	else if(self.positionz == 270)
		self.positionz = 280;
		
	else if(self.positionz == 280)
		self.positionz = 290;

	else if(self.positionz == 290)
		self.positionz = 300;
		
	else if(self.positionz == 300)
		self.positionz = 310;
		
	else if(self.positionz == 310)
		self.positionz = 320;
		
	else if(self.positionz == 320)
		self.positionz = 330;
	
	else if(self.positionz == 330)
		self.positionz = 340;
		
	else if(self.positionz == 340)
		self.positionz = 350;
		
	else if(self.positionz == 350)
		self.positionz = 360;
		
	else if(self.positionz == 360)
		self.positionz = 0;
	
	
	self.posz setText("^=[{+actionslot 3}] ^7- ^5Roll: ^7" + self.positionz);
                 }
                        
                if(self jumpButtonPressed() && self MeleeButtonPressed()) {
                        if(self.spacing == "Close Together")
                                self.spacing = "Spread Out";
                        else
                                self.spacing = "Close Together";
                        self.space setText("^=[{+melee}] ^7+ ^=[{+gostand}] ^7- ^5Spacing: ^7" + self.spacing);
                }
                wait 0.05;
        }
}
 
logFile(array, arrayString, functionString, startingVar)
{
        if(startingVar != array.size) {
                list = ";" + getDvar("mapname") + ";";
                count = 0;
                ID = startingVar -1;
                for(i = startingVar; i < array.size; i++) {
                        if(isDefined(array[i])) {
                                ID++;
                                count++;
                                if(count == 10) {
                                        list = list + arrayString + "[" + ID + "] = " + functionString + "(" + array[i].location + ", " + array[i].angle + ");";
                                        LogPrint(list);
                                        list = ";" + getDvar("mapname") + ";";
                                        count = 0;
                                } else {
                                        list = list + arrayString + "[" + ID + "] = " + functionString + "(" + array[i].location + ", " + array[i].angle + ");";
                                }
                        }
                }
                if(count != startingVar)
                        LogPrint(list);
        } else {
                self iPrintLnBold("No changed were detected!");
        }
}

spawnFlag()
{
        self.letGo["frag"] = true;
        self endon("death");
        self endon("disconnect");
        while(1) {
                if(self useButtonPressed() && self meleeButtonPressed() && level.tpFlagList.size <= 31 && self IsHost()) {
                        self thread doNotPressed("frag");
                        size = level.tpFlagList.size;
                        angles = (0, self.angles[1], 0);
                        level.tpFlagList[size] = createtpFlag(self.origin, angles);
												level thread maps\mp\gametypes\_thinker::createFlag(level.tpFlagList[size].location, level.tpFlagList[size].angle);
                        self.createdtpFlag[self.createdtpFlag.size] = size;
                } else if(self fragButtonPressed() && self.letGo["frag"] && level.tpFlagList.size > 31 && self IsHost()) {
                        self thread doNotPressed("frag");
                        self iPrintLnBold("There are too many flags!");
                }
                
                if(self ActionSlotTwoButtonPressed() && self meleeButtonPressed() && self.letGo["secoff"]) {
                        self thread doNotPressed("secoff");
                        if(self.createdtpFlag.size <= 0) {
                                self iPrintLnBold("No flags to delete!");
                        } else {
                                size = self.createdtpFlag.size - 1;
                                level.tpFlagEnt[self.createdtpFlag[size]] delete();
                                level.tpFlagEnt[self.createdtpFlag[size]] = undefined;
                                level.tpFlagList[self.createdtpFlag[size]].location = undefined;
                                level.tpFlagList[self.createdtpFlag[size]].angle = undefined;
                                level.tpFlagList[self.createdtpFlag[size]] = undefined;
                                self.createdtpFlag[size] = undefined;
                        }
                }
                wait 0.1;
        }
}

spawnCP()
{
        self.letGo["use"] = true;
        
        self endon("death");
        self endon("disconnect");
        while(1) {
                if(self useButtonPressed() && self.letGo["use"] && self.allowBlock && self IsHost()) {
                        self doNotPressed("use");
                        
                        pitch = self.positiony;
                        yaw = self.positionz;
                        roll = self.positionx;
                        
                        
                        angle = (pitch,yaw,roll);
                        
                        if(self.spacing == "Spread Out")
                                origin = self.origin + (0, 0, 10);
                        else
                                origin = self.origin;
                        if(self.spawning == "Crosshair")
                                origin = self getAim();
                        if(distance(origin, self.origin) > 1000) {
                                self iPrintLnBold("Too far away!");
                        } else {
                                size = level.bunkerList.size;
                                self.createdBlocks[self.createdBlocks.size] = size;
                                level.bunkerList[size] = createBlock(origin, angle);
                                self thread maps\mp\gametypes\_thinker::createJumpArea(level.bunkerList[size].location, level.bunkerList[size].angle);
                        }
                }
                wait 0.1;
        }
}
 
createBlock(origin, angle)
{
	 
        block = spawnstruct();
        block.location = origin;
        block.angle = angle;
        return block;
}
 
createtpFlag(origin, angle)
{
        tpFlag = spawnstruct();
        tpFlag.location = origin;
        tpFlag.angle = angle;
        return tpFlag;
}
 
getAim()
{
    forward = self getTagOrigin("tag_eye");
        end = self vector_Scal(anglestoforward(self getPlayerAngles()),1000000);
        Crosshair = BulletTrace( forward, end, 0, self )[ "position" ];
        return Crosshair;
}
 
vector_scal(vec, scale)
{
        vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
        return vec;
}
 
doNotPressed(button)
{
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
 
defaultCode()
{
        if(!isdefined(self.hud_rankscroreupdate))
        {
                self.hud_rankscroreupdate = NewScoreHudElem(self);
                self.hud_rankscroreupdate.horzAlign = "center";
                self.hud_rankscroreupdate.vertAlign = "middle";
                self.hud_rankscroreupdate.alignX = "center";
                self.hud_rankscroreupdate.alignY = "middle";
                self.hud_rankscroreupdate.x = 0;
                if( self IsSplitscreen() )
                        self.hud_rankscroreupdate.y = -15;
                else
                        self.hud_rankscroreupdate.y = -60;
                self.hud_rankscroreupdate.font = "default";
                self.hud_rankscroreupdate.fontscale = 2.0;
                self.hud_rankscroreupdate.archived = false;
                self.hud_rankscroreupdate.color = (0.5,0.5,0.5);
                self.hud_rankscroreupdate.alpha = 0;
                self.hud_rankscroreupdate maps\mp\gametypes\_hud::fontPulseInit();
                self.hud_rankscroreupdate.overrridewhenindemo = true;
        }
}
 
incCodPoints( amount )
{
        if( !isRankEnabled() )
                return;
 
        if( level.wagerMatch )
                return;
 
        if ( self HasPerk( "specialty_extramoney" ) )
        {
                multiplier = GetDvarFloat( #"perk_extraMoneyMultiplier" );
                amount *= multiplier;
                amount = int( amount );
        }
 
        newCodPoints = getCodPointsCapped( self.pers["codpoints"] + amount );
        if ( newCodPoints > self.pers["codpoints"] )
        {
                self.pers["summary"]["codpoints"] += ( newCodPoints - self.pers["codpoints"] );
        }
        self.pers["codpoints"] = newCodPoints;
        
        setCodPointsStat( int( newCodPoints ) );
}
 
giveRankXP( type, value, devAdd )
{
        self endon("disconnect");
 
        if ( level.teamBased && (!level.playerCount["allies"] || !level.playerCount["axis"]) && !isDefined( devAdd ) )
                return;
        else if ( !level.teamBased && (level.playerCount["allies"] + level.playerCount["axis"] < 2) && !isDefined( devAdd ) )
                return;
 
        if( !isRankEnabled() )
                return;         
 
        if( level.wagerMatch || !level.onlineGame || ( GetDvarInt( #"xblive_privatematch" ) && !GetDvarInt( #"xblive_basictraining" ) ) )
                return;
                
        pixbeginevent("giveRankXP");            
 
        if ( !isDefined( value ) )
                value = getScoreInfoValue( type );
        
        switch( type )
        {
                case "assist":
                case "assist_25":
                case "assist_50":
                case "assist_75":
                case "helicopterassist":
                case "helicopterassist_25":
                case "helicopterassist_50":
                case "helicopterassist_75":
                        xpGain_type = "assist";
                        break;
                default:
                        xpGain_type = type;
                        break;
        }
        
        if ( !isDefined( self.xpGains[xpGain_type] ) )
                self.xpGains[xpGain_type] = 0;
 
        if( level.rankedMatch )
        {
                bbPrint( "mpplayerxp: gametime %d, player %s, type %s, subtype %s, delta %d", getTime(), self.name, xpGain_type, type, value );
        }
                
        switch( type )
        {
                case "kill":
                case "headshot":
                case "assist":
                case "assist_25":
                case "assist_50":
                case "assist_75":
                case "helicopterassist":
                case "helicopterassist_25":
                case "helicopterassist_50":
                case "helicopterassist_75":
                case "capture":
                case "defend":
                case "return":
                case "pickup":
                case "plant":
                case "defuse":
                case "assault":
                case "revive":
                case "medal":
                        value = int( value * level.xpScale );
                        break;
                default:
                        if ( level.xpScale == 0 )
                                value = 0;
                        break;
        }
 
        self.xpGains[xpGain_type] += value;
                
        xpIncrease = self incRankXP( value );
 
        if ( level.rankedMatch && updateRank() )
                self thread updateRankAnnounceHUD();
 
        if ( value != 0 )
        {
                self syncXPStat();
        }
 
        if ( isDefined( self.enableText ) && self.enableText && !level.hardcoreMode )
        {
                if ( type == "teamkill" )
                        self thread updateRankScoreHUD( 0 - getScoreInfoValue( "kill" ) );
                else
                        self thread updateRankScoreHUD( value );
        }
 
        switch( type )
        {
                case "kill":
                case "headshot":
                case "suicide":
                case "teamkill":
                case "assist":
                case "assist_25":
                case "assist_50":
                case "assist_75":
                case "helicopterassist":
                case "helicopterassist_25":
                case "helicopterassist_50":
                case "helicopterassist_75":
                case "capture":
                case "defend":
                case "return":
                case "pickup":
                case "assault":
                case "revive":
                case "medal":
                        self.pers["summary"]["score"] += value;
                        incCodPoints( roundUp( value * level.codPointsXPScale ) );
                        break;
 
                case "win":
                case "loss":
                case "tie":
                        self.pers["summary"]["match"] += value;
                        incCodPoints( roundUp( value * level.codPointsMatchScale ) );
                        break;
 
                case "challenge":
                        self.pers["summary"]["challenge"] += value;
                        incCodPoints( roundUp( value * level.codPointsChallengeScale ) );
                        break;
                        
                default:
                        self.pers["summary"]["misc"] += value;
                        self.pers["summary"]["match"] += value;
                        incCodPoints( roundUp( value * level.codPointsMatchScale ) );
                        break;
        }
        
        self.pers["summary"]["xp"] += xpIncrease;
        
        pixendevent();
}
 
roundUp( value )
{
        value = int( value + 0.5 );
        return value;
}
 
updateRank()
{
        newRankId = self getRank();
        if ( newRankId == self.pers["rank"] )
                return false;
 
        oldRank = self.pers["rank"];
        rankId = self.pers["rank"];
        self.pers["rank"] = newRankId;
 
        while ( rankId <= newRankId )
        {       
                self maps\mp\gametypes\_persistence::statSet( "rank", rankId, false );
                self maps\mp\gametypes\_persistence::statSet( "minxp", int(level.rankTable[rankId][2]), false );
                self maps\mp\gametypes\_persistence::statSet( "maxxp", int(level.rankTable[rankId][7]), false );
                
                self.setPromotion = true;
                if ( level.rankedMatch && level.gameEnded && !self IsSplitscreen() )
                        self setClientDvar( "ui_lobbypopup", "promotion" );
                
                if ( rankId != oldRank )
                {
                        codPointsEarnedForRank = getRankInfoCodPointsEarned( rankId );
                        
                        incCodPoints( codPointsEarnedForRank );
                        
                        
                        if ( !IsDefined( self.pers["rankcp"] ) )
                        {
                                self.pers["rankcp"] = 0;
                        }
                        
                        self.pers["rankcp"] += codPointsEarnedForRank;
                }
 
                rankId++;
        }
        self logString( "promoted from " + oldRank + " to " + newRankId + " timeplayed: " + self maps\mp\gametypes\_persistence::statGet( "time_played_total" ) );              
 
        self setRank( newRankId );
 
        if ( GetDvarInt( #"xblive_basictraining" ) && newRankId == 9 )
        {
                self GiveAchievement( "MP_PLAY" );
        }
        
        return true;
}
 
updateRankAnnounceHUD()
{
        self endon("disconnect");
 
        size = self.rankNotifyQueue.size;
        self.rankNotifyQueue[size] = spawnstruct();
        
        display_rank_column = 14;
        self.rankNotifyQueue[size].rank = int( level.rankTable[ self.pers["rank"] ][ display_rank_column ] );
        self.rankNotifyQueue[size].prestige = self.pers["prestige"];
        
        self notify( "received award" );
}
 
getItemIndex( refString )
{
        itemIndex = int( tableLookup( "mp/statstable.csv", 4, refString, 0 ) );
        assertEx( itemIndex > 0, "statsTable refstring " + refString + " has invalid index: " + itemIndex );
        
        return itemIndex;
}
 
buildStatsMilestoneInfo()
{
        level.statsMilestoneInfo = [];
        
        for ( tierNum = 1; tierNum <= level.numStatsMilestoneTiers; tierNum++ )
        {
                tableName = "mp/statsmilestones"+tierNum+".csv";
                
                moveToNextTable = false;
 
                for( idx = 0; idx < level.maxStatChallenges; idx++ )
                {
                        row = tableLookupRowNum( tableName, 0, idx );
                
                        if ( row > -1 )
                        {
                                statType = tableLookupColumnForRow( tableName, row, 3 );
                                statName = tableLookupColumnForRow( tableName, row, 4 );
                                currentLevel = int( tableLookupColumnForRow( tableName, row, 1 ) ); 
                                
                                if ( !isDefined( level.statsMilestoneInfo[statType] ) )
                                {
                                        level.statsMilestoneInfo[statType] = [];
                                }
                                
                                if ( !isDefined( level.statsMilestoneInfo[statType][statName] ) )
                                {
                                        level.statsMilestoneInfo[statType][statName] = [];
                                }
 
                                level.statsMilestoneInfo[statType][statName][currentLevel] = [];
                                level.statsMilestoneInfo[statType][statName][currentLevel]["index"] = idx;
                                level.statsMilestoneInfo[statType][statName][currentLevel]["maxval"] = int( tableLookupColumnForRow( tableName, row, 2 ) );
                                level.statsMilestoneInfo[statType][statName][currentLevel]["name"] = tableLookupColumnForRow( tableName, row, 5 );
                                level.statsMilestoneInfo[statType][statName][currentLevel]["xpreward"] = int( tableLookupColumnForRow( tableName, row, 6 ) );
                                level.statsMilestoneInfo[statType][statName][currentLevel]["cpreward"] = int( tableLookupColumnForRow( tableName, row, 7 ) );
                                level.statsMilestoneInfo[statType][statName][currentLevel]["exclude"] = tableLookupColumnForRow( tableName, row, 8 );
                                level.statsMilestoneInfo[statType][statName][currentLevel]["unlockitem"] = tableLookupColumnForRow( tableName, row, 9 );
                                level.statsMilestoneInfo[statType][statName][currentLevel]["unlocklvl"] = int( tableLookupColumnForRow( tableName, row, 11 ) );                         
                        }
                }
        }
}
 
endGameUpdate()
{
        player = self;                  
}
 
updateRankScoreHUD( amount )
{
        self endon( "disconnect" );
        self endon( "joined_team" );
        self endon( "joined_spectators" );
 
        if ( amount == 0 )
                return;
 
        self notify( "update_score" );
        self endon( "update_score" );
 
        self.rankUpdateTotal += amount;
 
        wait ( 0.05 );
 
        if( isDefined( self.hud_rankscroreupdate ) )
        {                       
                if ( self.rankUpdateTotal < 0 )
                {
                        self.hud_rankscroreupdate.label = &"";
                        self.hud_rankscroreupdate.color = (0.73,0.19,0.19);
                }
                else
                {
                        self.hud_rankscroreupdate.label = &"MP_PLUS";
                        self.hud_rankscroreupdate.color = (1,1,0.5);
                }
 
                self.hud_rankscroreupdate setValue(self.rankUpdateTotal);
 
                self.hud_rankscroreupdate.alpha = 0.85;
                self.hud_rankscroreupdate thread maps\mp\gametypes\_hud::fontPulse( self );
 
                wait 1;
                self.hud_rankscroreupdate fadeOverTime( 0.75 );
                self.hud_rankscroreupdate.alpha = 0;
                
                self.rankUpdateTotal = 0;
        }
}
 
removeRankHUD()
{
        if(isDefined(self.hud_rankscroreupdate))
                self.hud_rankscroreupdate.alpha = 0;
}
 
getRank()
{       
        rankXp = getRankXPCapped( self.pers["rankxp"] );
        rankId = self.pers["rank"];
        
        if ( rankXp < (getRankInfoMinXP( rankId ) + getRankInfoXPAmt( rankId )) )
                return rankId;
        else
                return self getRankForXp( rankXp );
}
 
getRankForXp( xpVal )
{
        rankId = 0;
        rankName = level.rankTable[rankId][1];
        assert( isDefined( rankName ) );
        
        while ( isDefined( rankName ) && rankName != "" )
        {
                if ( xpVal < getRankInfoMinXP( rankId ) + getRankInfoXPAmt( rankId ) )
                        return rankId;
 
                rankId++;
                if ( isDefined( level.rankTable[rankId] ) )
                        rankName = level.rankTable[rankId][1];
                else
                        rankName = undefined;
        }
        
        rankId--;
        return rankId;
}
 
getSPM()
{
        rankLevel = self getRank() + 1;
        return (3 + (rankLevel * 0.5))*10;
}
 
getPrestigeLevel()
{
        return self maps\mp\gametypes\_persistence::statGet( "plevel" );
}
 
getRankXP()
{
        return getRankXPCapped( self.pers["rankxp"] );
}
 
incRankXP( amount )
{
        if ( !level.rankedMatch )
                return 0;
        
        xp = self getRankXP();
        newXp = getRankXPCapped( xp + amount );
 
        if ( self.pers["rank"] == level.maxRank && newXp >= getRankInfoMaxXP( level.maxRank ) )
                newXp = getRankInfoMaxXP( level.maxRank );
                
        xpIncrease = getRankXPCapped( newXp ) - self.pers["rankxp"];
        
        if ( xpIncrease < 0 )
        {
                xpIncrease = 0;
        }
 
        self.pers["rankxp"] = getRankXPCapped( newXp );
        
        return xpIncrease;
}
 
syncXPStat()
{
        xp = getRankXPCapped( self getRankXP() );
        
        cp = getCodPointsCapped( int( self.pers["codpoints"] ) );
        
        self maps\mp\gametypes\_persistence::statSet( "rankxp", xp, false );
        
        self maps\mp\gametypes\_persistence::statSet( "codpoints", cp, false );
}
