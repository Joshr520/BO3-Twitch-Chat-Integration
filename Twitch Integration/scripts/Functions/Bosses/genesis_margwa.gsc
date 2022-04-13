spawn_genesis_margwa()
{
	s_loc = function_830cdf99();
	if(!isdefined(s_loc))
	{
		return;
	}
    if(math::cointoss())
    {
        var_33504256 = function_75b161ab(undefined, s_loc);
    }
    else
    {
        var_33504256 = function_26efbc37(undefined, s_loc);
    }
    var_33504256.var_26f9f957 = ::function_26f9f957;
    level.var_95981590 = var_33504256;
    level notify("hash_c484afcb");
    if(isdefined(var_33504256))
    {
        var_33504256.b_ignore_cleanup = 1;
        n_health = level.round_number * 100 + 100;
        var_33504256 margwaSetHeadHealth(n_health);
    }
	if(!isdefined(var_33504256.maxhealth))
	{
		var_33504256.maxhealth = var_33504256.health;
	}
	var_33504256.var_953b581c = 1;
	return var_33504256;
}

function_830cdf99()
{
	var_fffe05f0 = Array::randomize(level.var_95810297);
	var_1fae6c0 = [];
	for(i = 0; i < var_fffe05f0.size; i++)
	{
		s_loc = var_fffe05f0[i];
		str_zone = zm_zonemgr::get_zone_from_position(s_loc.origin, 1);
		if(isdefined(str_zone) && level.zones[str_zone].is_occupied)
		{
			var_1fae6c0[var_1fae6c0.size] = s_loc;
		}
	}
	if(var_1fae6c0.size == 0)
	{
		for(i = 0; i < var_fffe05f0.size; i++)
		{
			s_loc = var_fffe05f0[i];
			str_zone = zm_zonemgr::get_zone_from_position(s_loc.origin, 1);
			if(isdefined(str_zone) && level.zones[str_zone].is_active)
			{
				var_1fae6c0[var_1fae6c0.size] = s_loc;
			}
		}
	}
	else if(var_1fae6c0.size > 0)
	{
		var_1fae6c0 = Array::randomize(var_1fae6c0);
		return var_1fae6c0[0];
	}
	return var_fffe05f0[0];
}

function_75b161ab(spawner, s_location)
{
	if(!isdefined(spawner))
	{
		var_fda751f9 = GetSpawnerArray("zombie_margwa_fire_spawner", "script_noteworthy");
		if(var_fda751f9.size <= 0)
		{
			return;
		}
		spawner = var_fda751f9[0];
	}
	spawner_targetname = "margwa_fire";
	var_f9ebd43e = "fire";
	ai = function_eb5051f4(spawner, spawner_targetname, var_f9ebd43e, s_location);
	return ai;
}

function_26efbc37(spawner, s_location)
{
	if(!isdefined(spawner))
	{
		var_5e8312fd = GetSpawnerArray("zombie_margwa_shadow_spawner", "script_noteworthy");
		if(var_5e8312fd.size <= 0)
		{
			return;
		}
		spawner = var_5e8312fd[0];
	}
	spawner_targetname = "margwa_shadow";
	var_f9ebd43e = "shadow";
	ai = function_eb5051f4(spawner, spawner_targetname, var_f9ebd43e, s_location);
	return ai;
}

margwaSetHeadHealth(health)
{
	self.headHealthMax = health;
	foreach(head in self.head)
	{
		head.health = health;
	}
}

function function_eb5051f4(spawner, targetname, var_f9ebd43e, s_location)
{
	if(isdefined(spawner))
	{
		level.margwa_head_left_model_override = undefined;
		level.margwa_head_mid_model_override = undefined;
		level.margwa_head_right_model_override = undefined;
		level.margwa_gore_left_model_override = undefined;
		level.margwa_gore_mid_model_override = undefined;
		level.margwa_gore_right_model_override = undefined;
		switch(var_f9ebd43e)
		{
			case "fire":
			{
				level.margwa_head_left_model_override = "c_zom_dlc4_margwa_chunks_le_fire";
				level.margwa_head_mid_model_override = "c_zom_dlc4_margwa_chunks_mid_fire";
				level.margwa_head_right_model_override = "c_zom_dlc4_margwa_chunks_ri_fire";
				level.margwa_gore_left_model_override = "c_zom_dlc4_margwa_gore_le_fire";
				level.margwa_gore_mid_model_override = "c_zom_dlc4_margwa_gore_mid_fire";
				level.margwa_gore_right_model_override = "c_zom_dlc4_margwa_gore_ri_fire";
				break;
			}
			case "shadow":
			{
				level.margwa_head_left_model_override = "c_zom_dlc4_margwa_chunks_le_shadow";
				level.margwa_head_mid_model_override = "c_zom_dlc4_margwa_chunks_mid_shadow";
				level.margwa_head_right_model_override = "c_zom_dlc4_margwa_chunks_ri_shadow";
				level.margwa_gore_left_model_override = "c_zom_dlc4_margwa_gore_le_shadow";
				level.margwa_gore_mid_model_override = "c_zom_dlc4_margwa_gore_mid_shadow";
				level.margwa_gore_right_model_override = "c_zom_dlc4_margwa_gore_ri_shadow";
				break;
			}
		}
		spawner.script_forcespawn = 1;
		ai = zombie_utility::spawn_zombie(spawner, targetname, s_location);
		level.margwa_head_left_model_override = undefined;
		level.margwa_head_mid_model_override = undefined;
		level.margwa_head_right_model_override = undefined;
		level.margwa_gore_left_model_override = undefined;
		level.margwa_gore_mid_model_override = undefined;
		level.margwa_gore_right_model_override = undefined;
		if(isdefined(level.var_fd47363))
		{
			level.margwa_head_left_model_override = level.var_fd47363["head_le"];
			level.margwa_head_mid_model_override = level.var_fd47363["head_mid"];
			level.margwa_head_right_model_override = level.var_fd47363["head_ri"];
			level.margwa_gore_left_model_override = level.var_fd47363["gore_le"];
			level.margwa_gore_mid_model_override = level.var_fd47363["gore_mid"];
			level.margwa_gore_right_model_override = level.var_fd47363["gore_ri"];
		}
		ai DisableAimAssist();
		ai.actor_damage_func = ::margwaDamage;
		ai.canDamage = 0;
		ai.targetname = targetname;
		ai.holdFire = 1;
		ai function_c0ff1e9(var_f9ebd43e);
		switch(var_f9ebd43e)
		{
			case "fire":
			{
				ai clientfield::set("margwa_elemental_type", 1);
				break;
			}
			case "electric":
			{
				ai clientfield::set("margwa_elemental_type", 2);
				break;
			}
			case "light":
			{
				ai clientfield::set("margwa_elemental_type", 3);
				break;
			}
			case "shadow":
			{
				ai clientfield::set("margwa_elemental_type", 4);
				break;
			}
		}
		ai.var_7884b12d = self.health;
		ai.team = level.zombie_team;
		ai.canStun = 1;
		ai.thundergun_fling_func = ::function_7292417a;
		ai.thundergun_knockdown_func = ::function_94fd1710;
		ai.var_23340a5d = ::function_7292417a;
		ai.var_e1dbd63 = ::function_94fd1710;
		e_player = zm_utility::get_closest_player(s_location.origin);
		v_dir = e_player.origin - s_location.origin;
		v_dir = VectorNormalize(v_dir);
		v_angles = VectorToAngles(v_dir);
		ai ForceTeleport(s_location.origin, v_angles);
		ai function_551e32b4();
		ai thread function_8d578a58_2();
		ai.ignore_round_robbin_death = 1;
		ai thread function_3d56f587();
		level thread zm_spawner::zombie_death_event(ai);
		return ai;
	}
	return undefined;
}

function_c0ff1e9(var_f9ebd43e)
{
	self.var_f9ebd43e = var_f9ebd43e;
}

function_7292417a(e_player, gib)
{
	self endon("death");
	self function_5ffc5a7b(e_player);
	if(isdefined(self.canStun) && self.canStun)
	{
		self.reactStun = 1;
	}
}

function_94fd1710(e_player, gib)
{
	self endon("death");
	self function_5ffc5a7b(e_player, 1);
	if(isdefined(self.canStun) && self.canStun)
	{
		self.reactStun = 1;
	}
}

function_8d578a58_2()
{
	self waittill("death", attacker, mod, weapon);
	foreach(player in level.players)
	{
		if(player.am_i_valid && (!is_true(level.var_1f6ca9c8)) && (!is_true(self.var_2d5d7413)))
		{
			scoreevents::processScoreEvent("kill_margwa", player, undefined, undefined);
		}
	}
	level notify("hash_1a2d33d7");
	[[level.var_7cef68dc]]();
}

function_5ffc5a7b(e_player, KNOCKDOWN)
{
	if(!isdefined(KNOCKDOWN))
	{
		KNOCKDOWN = 0;
	}
	if(isdefined(self))
	{
		foreach(head in self.head)
		{
			if(head margwaCanDamageHead())
			{
				damage = head.health;
				if(KNOCKDOWN)
				{
					damage = damage * 0.5;
				}
				head.health = head.health - damage;
				if(isdefined(self.var_5ffc5a7b))
				{
					self [[self.var_5ffc5a7b]](e_player);
				}
				if(head.health <= 0)
				{
					if(self margwaKillHead(head.model, e_player))
					{
						self.is_kill = 1;
						self kill(self.origin, e_player, e_player, level.weaponZMThunderGun);
					}
				}
				return;
			}
		}
	}
}

function_26f9f957(modelHit, e_attacker)
{
}