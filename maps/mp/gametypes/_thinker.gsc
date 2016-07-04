#include maps\mp\_utility;
#include common_scripts\utility;

createJumpArea(pos, rotation)
{
	jumpArea = spawn("script_model", pos);
	jumpArea setModel("mp_supplydrop_hq");
	jumpArea.angles = rotation;
	if(level.failCODJumper)
		jumpArea thread jumpAreaThink(50);
	level.blockEnt[level.blockEnt.size] = jumpArea;
}

createFlag(pos, rotation)
{
	
	tpFlag = spawn("script_model", pos);
	tpFlag setModel("mp_flag_neutral");
	tpFlag.angles = self.angels;
	level.tpFlagEnt[level.tpFlagEnt.size] = tpFlag;
	
}

jumpAreaThink(radius)
{
	self.disableFor = "";
	self endon("death");
	self endon("disconnect");
	while(1) {
		if(isDefined(level.players)) {
			for(i = 0; i < level.players.size; i++) {
				if(!isDefined(level.players[i].highestPoint) && isAlive(level.players[i]) && !level.players[i] isOnGround()) {
					level.players[i].highestPoint = level.players[i].origin[2];
				}
				
				if(!level.players[i] isOnGround()) {
					level.players[i].highestPoint = level.players[i].origin[2];
					while(!level.players[i] isOnGround())
					{
						if ( level.players[i].origin[2] > level.players[i].highestPoint )
							level.players[i].highestPoint = level.players[i].origin[2];
						wait .05;
					}
					
					falldist = level.players[i].highestPoint - level.players[i].origin[2];
					
					if(distance(self.origin, level.players[i].origin) <= radius + 200 && falldist >= 90 && level.players[i].name != self.disableFor)
					{
						invisObj = spawn("script_model", level.players[i].origin + (0, 0, 45));
						
						angles = level.players[i] getPlayerAngles();
						
						flipLaunch = false;
						if(angles < -45)
							flipLaunch = true;
						
						if(!flipLaunch)
							angles[1] = angles[1] - 90;
						else
							angles[1] = angles[1] + 90;
						
						direction = anglesToForward((0, angles[1], 0));
						finalDir = level.players[i] vector_scal(direction, 1000);
						
						forward = level.players[i] getTagOrigin("tag_eye");
						location = BulletTrace( forward, finalDir, 0, level.players[i])[ "position" ];
						invisObj PhysicsLaunch(invisObj.origin, (0, 0, 1));
						
						height = distance(self.origin, location) / 2;
						
						if(distance(self.origin, location) > 600)
							height = int(distance(self.origin, location) / 3);
						
						if(!flipLaunch) {
							if(angles[1] > 45 && angles[1] < 135)
								invisObj MoveGravity((location[1] - self.origin[1], location[0] + self.origin[0], height), 1.5);
							else
								invisObj MoveGravity((location[1] + self.origin[1], location[0] + self.origin[0], height), 1.5);
						} else {
							if(angles[1] > 45 && angles[1] < 110)
								invisObj MoveGravity((location[0] - self.origin[0], location[1] + self.origin[1], height), 1.5);
							else
								invisObj MoveGravity((location[0] - self.origin[0], location[1] - self.origin[1], height), 1.5);
						}
						invisObj thread doFlyingTogether(level.players[i]);
						invisObj thread doEnd();
						self thread doubleJumpFix(level.players[i].name);
					}
				}
			}
		}
		wait 0.05;
	}
}

doubleJumpFix(name)
{
	self.disableFor = name;
	wait 2;
	if(self.disableFor == name) {
		self.disableFor = "";
	}
}

doEnd()
{
	wait 1.5;
	self.end = true;
}

doFlyingTogether(player)
{
	self.end = false;
	while(1) {
		if(isAlive(player) && !self.end && self.origin[2] > (player.groundLevel - 3)) {
			player setOrigin(self.origin);
			wait 0.01;
		} else {
			break;
		}
	}
}

vector_scal(vec, scale)
{
        vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
        return vec;
}

init()
{
	for(;;)
	{
		level waittill ( "connecting", player );

		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	self endon( "disconnect" );

	for(;;)
	{
		self waittill( "spawned_player" );

		self thread init_serverfaceanim();
	}
}

init_serverfaceanim()
{	
	self.do_face_anims = true;

	if( !IsDefined( level.face_event_handler ) )
	{
		level.face_event_handler = SpawnStruct();
		level.face_event_handler.events = [];
		level.face_event_handler.events["death"] = 							"face_death";
		level.face_event_handler.events["grenade danger"] = 		"face_alert";
		level.face_event_handler.events["bulletwhizby"] = 			"face_alert";
		level.face_event_handler.events["projectile_impact"] = 	"face_alert";
		level.face_event_handler.events["explode"] = 						"face_alert";
		level.face_event_handler.events["alert"] = 							"face_alert";
		level.face_event_handler.events["shoot"] = 							"face_shoot_single";
		level.face_event_handler.events["melee"] = 							"face_melee";
		level.face_event_handler.events["damage"] = 						"face_pain";
		
		level thread wait_for_face_event();
	}
}

wait_for_face_event()
{
	while( true )
	{
		level waittill( "face", face_notify, ent );
		
		if( IsDefined( ent ) && IsDefined( ent.do_face_anims ) && ent.do_face_anims )
		{
			if( IsDefined( level.face_event_handler.events[face_notify] ) )
			{
				ent SendFaceEvent( level.face_event_handler.events[face_notify] );
			}
		}
	}
}

