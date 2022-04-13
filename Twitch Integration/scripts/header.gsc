#include scripts\codescripts\struct;

#include scripts\shared\_burnplayer;
#include scripts\shared\callbacks_shared;
#include scripts\shared\clientfield_shared;
#include scripts\shared\math_shared;
#include scripts\shared\system_shared;
#include scripts\shared\util_shared;
#include scripts\shared\hud_util_shared;
#include scripts\shared\hud_message_shared;
#include scripts\shared\hud_shared;
#include scripts\shared\array_shared;
#include scripts\shared\flag_shared;
#include scripts\shared\scene_shared;
#include scripts\shared\ai\zombie_utility;
#include scripts\shared\ai\systems\blackboard;
#include scripts\shared\ai\systems\gib;
#include scripts\shared\vehicle_shared;
#include scripts\shared\vehicle_ai_shared;
#include scripts\shared\scoreevents_shared;
#include scripts\shared\aat_shared;
#include scripts\shared\exploder_shared;
#include scripts\shared\flagsys_shared;
#include scripts\shared\laststand_shared;
#include scripts\shared\lui_shared;
#include scripts\shared\visionset_mgr_shared;

#include scripts\zm\_util;
#include scripts\zm\_zm_equipment;
#include scripts\zm\_zm_laststand;
#include scripts\zm\_zm_unitrigger;
#include scripts\zm\_zm_utility;
#include scripts\zm\_zm_score;
#include scripts\zm\_zm_stats;
#include scripts\zm\_zm_spawner;
#include scripts\zm\_zm_zonemgr;
#include scripts\zm\_zm_powerups;
#include scripts\zm\_zm_perks;
#include scripts\zm\_zm_weapons;
#include scripts\zm\_zm_bgb;
#include scripts\zm\_zm_hero_weapon;
#include scripts\zm\_zm_clone;
#include scripts\zm\aats\_zm_aat_turned;

#namespace serious;

autoexec __init__sytem__()
{
	compiler::detour();
	system::register("serious", ::__init__, undefined, undefined);
}

__init__()
{
	callback::on_start_gametype(::init);
	callback::on_connect(::on_player_connect);
	callback::on_spawned(::on_player_spawned);
}