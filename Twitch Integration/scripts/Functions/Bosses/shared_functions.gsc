show_hit_marker()  // self = player
{
	if(isdefined(self) && isdefined(self.hud_damagefeedback))
	{
		self.hud_damagefeedback SetShader("damage_feedback", 24, 48);
		self.hud_damagefeedback.alpha = 1;
		self.hud_damagefeedback FadeOverTime(1);
		self.hud_damagefeedback.alpha = 0;
	}	
}

function_d41418b8()
{
	a_zombies = GetAIArchetypeArray("zombie");
	a_filtered_zombies = Array::filter(a_zombies, 0, ::function_b804eb62);
	return a_filtered_zombies;
}

function_f4defbc2()
{
	if(isdefined(self))
	{
		ai_zombie = self;
		var_ac4641b = function_4aeed0a5("napalm");
		if(!isdefined(level.var_bd64e31e) || var_ac4641b < level.var_bd64e31e)
		{
			if(!isdefined(ai_zombie.is_elemental_zombie) || ai_zombie.is_elemental_zombie == 0)
			{
				ai_zombie.is_elemental_zombie = 1;
				ai_zombie.var_9a02a614 = "napalm";
				ai_zombie clientfield::set("arch_actor_fire_fx", 1);
				ai_zombie clientfield::set("napalm_sfx", 1);
				ai_zombie.health = Int(ai_zombie.health * 0.75);
				ai_zombie thread function_e94aef80();
				ai_zombie thread function_d070bfba();
				ai_zombie zombie_utility::set_zombie_run_cycle("sprint");
			}
		}
	}
}

function_e94aef80()
{
	ai_zombie = self;
	ai_zombie waittill("death", attacker);
	if(!isdefined(ai_zombie) || ai_zombie.nuked === 1)
	{
		return;
	}
	ai_zombie clientfield::set("napalm_zombie_death_fx", 1);
	ai_zombie zombie_utility::gib_random_parts();
	GibServerUtils::Annihilate(ai_zombie);
	if(is_true(level.var_36b5dab) || is_true(ai_zombie.var_36b5dab))
	{
		ai_zombie.custom_player_shellshock = ::function_e6cd7e78;
	}
	RadiusDamage(ai_zombie.origin + VectorScale((0, 0, 1), 35), 128, 70, 30, self, "MOD_EXPLOSIVE");
}

function_e6cd7e78(damage, attacker, direction_vec, point, mod)
{
	if(GetDvarString("blurpain") == "on")
	{
		self shellshock("pain_zm", 0.5);
	}
}

function_d070bfba()
{
	self endon("entityshutdown");
	self endon("death");
	while(1)
	{
		self waittill("damage");
		if(RandomInt(100) < 50)
		{
			self clientfield::increment("napalm_damaged_fx");
		}
		wait(0.05);
	}
}

function_4aeed0a5(type)
{
	a_zombies = function_c50e890f(type);
	return a_zombies.size;
}

function_c50e890f(type)
{
	a_zombies = GetAIArchetypeArray("zombie");
	a_filtered_zombies = Array::filter(a_zombies, 0, ::function_361f6caa, type);
	return a_filtered_zombies;
}

function_361f6caa(ai_zombie, type)
{
	return ai_zombie.var_9a02a614 === type;
}

function_b804eb62(ai_zombie)
{
	return ai_zombie.is_elemental_zombie !== 1;
}

sqr(var)
{
    return var * var;
}

is_true(bool)
{
	if(isdefined(bool) && bool) return true;
	else return false;
}

var_default(var, _default) 
{
    if(!isdefined(var)) var = _default;
}

check_point_in_playable_area(origin)
{
	playable_area = GetEntArray("player_volume", "script_noteworthy");
	if(!isdefined(level.check_model))
	{
		level.check_model = spawn("script_model", origin + VectorScale((0, 0, 1), 40));
	}
	else
	{
		level.check_model.origin = origin + VectorScale((0, 0, 1), 40);
	}
	valid_point = 0;
	for(i = 0; i < playable_area.size; i++)
	{
		if(level.check_model istouching(playable_area[i]))
		{
			valid_point = 1;
		}
	}
	return valid_point;
}