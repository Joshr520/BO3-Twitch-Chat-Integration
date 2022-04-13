// zm\zm_ai_margwa
spawn_zod_margwa()
{
    s_location = Array::random(level.zm_loc_types["margwa_location"]);
	if(isdefined(level.var_b398aafa[0]))
	{
		level.var_b398aafa[0].script_forcespawn = 1;
		ai = zombie_utility::spawn_zombie(level.var_b398aafa[0], "margwa", s_location);
		ai DisableAimAssist();
		ai.actor_damage_func = ::margwaDamage;
		ai.canDamage = 0;
		ai.targetname = "margwa";
		ai.holdFire = 1;
		e_player = zm_utility::get_closest_player(s_location.origin);
		v_dir = e_player.origin - s_location.origin;
		v_dir = VectorNormalize(v_dir);
		v_angles = VectorToAngles(v_dir);
		ai ForceTeleport(s_location.origin, v_angles);
		ai function_551e32b4();
		if(isdefined(level.var_7cef68dc))
		{
			ai thread function_8d578a58();
		}
		ai.ignore_round_robbin_death = 1;
		ai thread function_3d56f587();
		return ai;
	}
    return undefined;
}

function_551e32b4()
{
	self.isFrozen = 1;
	self ghost();
	self notsolid();
	self PathMode("dont move");
}

function_3d56f587()
{
	util::wait_network_frame();
	self clientfield::increment("margwa_fx_spawn");
	wait 3;
	self function_26c35525();
	self.canDamage = 1;
	self.needSpawn = 1;
}

function_26c35525()
{
	self.isFrozen = 0;
	self show();
	self solid();
	self PathMode("move allowed");
}

function_8d578a58()
{
	self waittill("death", attacker, mod, weapon);
	//level notify("hash_1a2d33d7");
	[[level.var_7cef68dc]]();
}

// shared\ai\margwa
// uses the bone name to figure out which head was hit
margwaDamage(inflictor, attacker, damage, dFlags, mod, weapon, point, dir, hitLoc, offsetTime, boneIndex, modelIndex)
{
	if(is_true(self.is_kill))
	{
		return damage;
	}

	if(isdefined(attacker) && isdefined(attacker.n_margwa_head_damage_scale))
	{
	   	damage = damage * attacker.n_margwa_head_damage_scale;
	}
	
	if(isdefined(level._margwa_damage_cb))
	{
		n_result = [[level._margwa_damage_cb]](inflictor, attacker, damage, dFlags, mod, weapon, point, dir, hitLoc, offsetTime, boneIndex, modelIndex);
		
		if(isdefined(n_result))
		{
			return n_result;
		}
	}
	
	damageOpen = false;		// mouth was open during damage
	
	if(!is_true(self.canDamage))
	{
		self.health += 1;	// impact fx only work when damage is applied
		return 1;
	}

	if(isDirectHitWeapon(weapon))
	{
		headAlive = [];
		foreach (head in self.head)
		{
			if(head margwaCanDamageHead())
			{
				headAlive[headAlive.size] = head;
			}
		}

		if(headAlive.size > 0)
		{
			max = 100000;
			headClosest = undefined;
			foreach (head in headAlive)
			{
				distSq = DistanceSquared(point, self GetTagOrigin(head.tag));
				if (distSq < max)
				{
					max = distSq;
					headClosest = head;
				}
			}
			if(isdefined(headClosest))
			{
				if (max < 24 * 24)
				{
					if(isdefined(level.margwa_damage_override_callback) && IsFunctionPtr(level.margwa_damage_override_callback))
					{
						damage = attacker [[level.margwa_damage_override_callback]](damage);
					}
					
					headClosest.health -= damage;
					damageOpen = true;
					self clientfield::increment(headClosest.impactCF);
					attacker show_hit_marker();

					if(headClosest.health <= 0)
					{
						if(isdefined(level.margwa_head_kill_weapon_check))
						{
							[[level.margwa_head_kill_weapon_check]](self, weapon);
						}
						
						if(self margwaKillHead(headClosest.model, attacker))
						{
							return self.health;
						}
					}
				}
			}
		}
	}
	
	partName = GetPartName(self.model, boneIndex);
	if(isdefined(partName))
	{
		modelHit = self margwaHeadHit(self, partName);
		if(isdefined(modelHit))
		{
			headInfo = self.head[modelHit];
			if(headInfo margwaCanDamageHead())
			{
				if(isdefined(level.margwa_damage_override_callback) && IsFunctionPtr(level.margwa_damage_override_callback))
				{
					damage = attacker [[level.margwa_damage_override_callback]](damage);
				}
				if(isdefined(attacker))
				{
					attacker notify("margwa_headshot", self);
				}
				headInfo.health -= damage;
				damageOpen = true;
				self clientfield::increment(headInfo.impactCF);
				attacker show_hit_marker();
				if(headInfo.health <= 0)
				{
					if(isdefined(level.margwa_head_kill_weapon_check))
					{
						[[level.margwa_head_kill_weapon_check]](self, weapon);
					}

					if(self margwaKillHead(modelHit, attacker))
					{
						return self.health;
					}
				}
			}
		}
	}
	if(damageOpen)
	{
		return 0;		// custom fx when damaging head
	}
	self.health += 1;	// impact fx only work when damage is applied to ent
	return 1;
}

margwaHeadHit(entity, partName)
{
	switch(partName)
	{
        case "j_chunk_head_bone_le":
        case "j_jaw_lower_1_le":
            return self.head_left_model;
        case "j_chunk_head_bone":
        case "j_jaw_lower_1":
            return self.head_mid_model;
        case "j_chunk_head_bone_ri":
        case "j_jaw_lower_1_ri":
            return self.head_right_model;
	}
	return undefined;
}

margwaKillHead(modelHit, attacker)
{
	headInfo = self.head[modelHit];
	headInfo.health = 0;
	headInfo notify("stop_head_update");
	if(is_true(headInfo.canDamage))
	{
		self margwaCloseHead(headInfo);
		self.headOpen--;
	}
	self margwaUpdateMoveSpeed();
	if(isdefined(self.destroyHeadCB))
	{
		self thread [[self.destroyHeadCB]](modelHit, attacker);
	}
	self clientfield::set("margwa_head_killed", headInfo.killIndex);
	self Detach(headInfo.model);
	self Attach(headInfo.gore);
	self.headAttached--;
	if(self.headAttached <= 0)
	{
		self.e_head_attacker = attacker;
		return true;
	}
	else
	{
		self.headDestroyed = modelHit;
	}
	return false;
}

margwaUpdateMoveSpeed()
{
	if(self.zombie_move_speed == "walk")
	{
		self.zombie_move_speed = "run";
		Blackboard::SetBlackBoardAttribute(self, "_locomotion_speed", "locomotion_speed_run");
	}
	else if(self.zombie_move_speed == "run")
	{
		self.zombie_move_speed = "sprint";
		Blackboard::SetBlackBoardAttribute(self, "_locomotion_speed", "locomotion_speed_sprint");
	}
}

margwaCloseHead(headInfo)
{
	headInfo.canDamage = false;
	self clientfield::set(headInfo.cf, headInfo.closed);
}

margwaCanDamageHead()
{
	if(isdefined(self) && self.health > 0 && is_true(self.canDamage))
	{
		return true;
	}
	return false;
}

isDirectHitWeapon(weapon)
{
	foreach(dhWeapon in level.dhWeapons)
	{
		if(weapon.name == dhWeapon)
		{
			return true;
		}
		if(isdefined(weapon.rootweapon) && isdefined(weapon.rootweapon.name) && weapon.rootweapon.name == dhWeapon)
		{
			return true;
		}
	}
	return false;
}