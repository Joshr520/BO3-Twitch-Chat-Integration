spawn_stalingrad_mangler()
{
	n_to_spawn = RandomIntRange(1, 4);
    thread spawn_stalingrad_valkyrie(4 - n_to_spawn);
	n_spawned = 0;
	while(n_spawned < n_to_spawn)
	{
		players = GetPlayers();
		var_19764360 = get_favorite_enemy();
		if(level.zm_loc_types["raz_location"].size > 0)
		{
			s_spawn_loc = Array::random(level.zm_loc_types["raz_location"]);
		}
        else if(isdefined(level.var_a3559c05))
		{
			s_spawn_loc = [[level.var_a3559c05]](level.var_6bca5baa, var_19764360);
		}
		if(!isdefined(s_spawn_loc))
		{
			return 0;
		}
		ai = function_665a13cd(level.var_6bca5baa[0]);
		if(isdefined(ai))
		{
			ai ForceTeleport(s_spawn_loc.origin, s_spawn_loc.angles);
			ai.script_string = s_spawn_loc.script_string;
			ai.find_flesh_struct_string = ai.script_string;
			if(isdefined(var_19764360))
			{
				ai.favoriteenemy = var_19764360;
				ai.favoriteenemy.hunted_by++;
			}
			n_spawned++;
			playsoundatposition("zmb_raz_spawn", s_spawn_loc.origin);
		}
		function_a74c2884();
	}
	return 1;
}

get_favorite_enemy()
{
	var_bc3f44bf = GetPlayers();
	e_least_hunted = undefined;
	foreach(e_target in var_bc3f44bf)
	{
		if(!isdefined(e_target.hunted_by))
		{
			e_target.hunted_by = 0;
		}
		if(!zm_utility::is_player_valid(e_target))
		{
			continue;
		}
		if(isdefined(level.var_3fded92e) && ![[level.var_3fded92e]](e_target))
		{
			continue;
		}
		if(!isdefined(e_least_hunted))
		{
			e_least_hunted = e_target;
			continue;
		}
		if(e_target.hunted_by < e_least_hunted.hunted_by)
		{
			e_least_hunted = e_target;
		}
	}
	return e_least_hunted;
}

function_665a13cd(spawner, s_spot)
{
	var_a09c80cd = zombie_utility::spawn_zombie(level.var_6bca5baa[0], "raz", s_spot);
	if(isdefined(var_a09c80cd))
	{
		var_a09c80cd.check_point_in_enabled_zone = ::check_point_in_playable_area;
		var_a09c80cd thread zombie_utility::round_spawn_failsafe();
		var_a09c80cd thread function_b8671cc0(s_spot);
	}
	return var_a09c80cd;
}

function_b8671cc0(s_spot)
{
	if(isdefined(level.var_71ab2462))
	{
		self thread [[level.var_71ab2462]](s_spot);
	}
	if(isdefined(level.var_ae95a175))
	{
		self thread [[level.var_ae95a175]]();
	}
}

function_a74c2884()
{
	switch(level.players.size)
	{
		case 1:
		{
			n_default_wait = 2.25;
			break;
		}
		case 2:
		{
			n_default_wait = 1.75;
			break;
		}
		case 3:
		{
			n_default_wait = 1.25;
			break;
		}
		default:
		{
			n_default_wait = 0.75;
			break;
		}
	}
	wait(n_default_wait);
}