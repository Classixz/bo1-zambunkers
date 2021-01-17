#include maps\ZAMBunkers\_utility;

init() {
	game["HunterMod"] = "ShopMenu";
	precacheMenu(game["HunterMod"]);
    precacheShader( "compass_waypoint_arrow_green" );
    precacheShader( "compass_waypoint_arrow_red" );
    setDvar("g_TeamName_Allies", "^1Classixz ^2Bunker ^=Mod ^4For^6 ZAM");
    setDvar("g_TeamName_Axis", " ");
    setDvar("scr_game_forceradar", 1 ); 
    setDvar("scr_tdm_timelimit", 0 ); 
    setdvar("scr_disable_cac", 1);
    setDvar("scr_disable_weapondrop", 1);
    setdvar("g_allowvote", 0);
    setdvar("g_allow_teamchange", 0); 
    setDvar("scr_showperksonspawn", 0); 
    setDvar("scr_game_killstreaks", 1); 
    setDvar("sv_hostname", "^1Z^2A^4M^7 Bunker Mod");
    setDvar("sv_cheats", 1);

    level.blockEnt = [];
    level.createdBlocks = [];
    level.bunkerList = [];
    level.ShopColor1 = "^1"; //Button to press
    level.ShopColor2 = "^7"; //Text saying what it is
    level.Speed = 0;
    level.numFlags = 0;
}


onPlayerConnect() {

}

onPlayerSpawned() {

    self.positiony = 0;
    self.positionx = 0;
    self.positionz = 0;
    self.createdBlocks = [];
    self.spacing = "Normal - Spread Out";
    self.spawning = "Under";
    self.barricadeModel = "Barricade";
    self.barricadeModelName = "mp_supplydrop_hq";

    self.pitchIncrement = 1;
    self.yawIncrement = 1;
    self.rollIncrement = 1;

    self takeAllWeapons();
    self thread cadesPlaced();
    self ZAMBunkerMakerVersion();
    self helpHUD();
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
    self.health = 200;

    self thread maps\ZAMBunkers\_shop::bunkerSettings();
    self thread buttonWatcher();

}