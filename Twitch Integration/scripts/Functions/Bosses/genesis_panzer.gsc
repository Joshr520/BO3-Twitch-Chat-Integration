spawn_genesis_panzer()
{
	s_loc = function_830cdf99();
	if(!isdefined(s_loc))
	{
		return;
	}
    if(isdefined(s_loc.script_string) && s_loc.script_string == "exterior")
    {
        var_33504256 = spawn_mechz(s_loc, 1);
    }
    else
    {
        var_33504256 = spawn_mechz(s_loc, 0);
    }
	if(!isdefined(var_33504256.maxhealth))
	{
		var_33504256.maxhealth = var_33504256.health;
	}
	var_33504256.var_953b581c = 1;
	return var_33504256;
}

spawn_mechz(s_location, flyin)
{
	if(!isdefined(flyin))
	{
		flyin = 0;
	}
	if(isdefined(level.mechz_spawners[0]))
	{
		if(isdefined(level.var_7f2a926d))
		{
			[[level.var_7f2a926d]]();
		}
		level.mechz_spawners[0].script_forcespawn = 1;
		ai = zombie_utility::spawn_zombie(level.mechz_spawners[0], "mechz", s_location);
		if(isdefined(ai))
		{
			ai DisableAimAssist();
			ai thread function_ef1ba7e5();
			ai thread function_949a3fdf();
			ai.actor_damage_func = ::mechzDamageCallback;
			ai.damage_scoring_function = ::function_b03abc02;
			ai.mechz_melee_knockdown_function = ::function_55483494;
			ai.health = level.mechz_health;
			ai.faceplate_health = level.MECHZ_FACEPLATE_HEALTH;
			ai.powercap_cover_health = level.MECHZ_POWERCAP_COVER_HEALTH;
			ai.powercap_health = level.MECHZ_POWERCAP_HEALTH;
			ai.left_knee_armor_health = level.var_2cbc5b59;
			ai.right_knee_armor_health = level.var_2cbc5b59;
			ai.left_shoulder_armor_health = level.var_2cbc5b59;
			ai.right_shoulder_armor_health = level.var_2cbc5b59;
			ai.heroweapon_kill_power = 10;
			e_player = zm_utility::get_closest_player(s_location.origin);
			v_dir = e_player.origin - s_location.origin;
			v_dir = VectorNormalize(v_dir);
			v_angles = VectorToAngles(v_dir);
			var_89f898ad = zm_utility::flat_angle(v_angles);
			var_6ea4ef96 = s_location;
			queryResult = PositionQuery_Source_Navigation(var_6ea4ef96.origin, 0, 32, 20, 4);
			if(queryResult.data.size)
			{
				v_ground_position = Array::random(queryResult.data).origin;
			}
			if(!isdefined(v_ground_position))
			{
				trace = bullettrace(var_6ea4ef96.origin, var_6ea4ef96.origin + VectorScale((0, 0, -1), 256), 0, s_location);
				v_ground_position = trace["position"];
			}
			var_1750e965 = v_ground_position;
			if(isdefined(level.var_e1e49cc1))
			{
				ai thread [[level.var_e1e49cc1]]();
			}
			ai ForceTeleport(var_1750e965, var_89f898ad);
			if(flyin === 1)
			{
				ai thread function_d07fd448();
				ai thread scene::Play("cin_zm_castle_mechz_entrance", ai);
				ai thread function_c441eaba(var_1750e965);
				ai thread function_bbdc1f34(var_1750e965);
			}
			else if(isdefined(level.var_7d2a391d))
			{
				ai thread [[level.var_7d2a391d]]();
			}
			ai.b_flyin_done = 1;
			ai thread function_bb048b27();
			ai.ignore_round_robbin_death = 1;
			return ai;
		}
	}
	return undefined;
}