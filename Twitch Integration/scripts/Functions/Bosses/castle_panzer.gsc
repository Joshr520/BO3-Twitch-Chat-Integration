// zm\zm_ai_maechz
spawn_castle_panzer()
{
	flyin = 1;
    if(level.zm_loc_types["mechz_location"].size == 0)
    {
        var_79ed5347 = struct::get_array("mechz_location", "script_noteworthy");
        foreach(var_6000fab5 in var_79ed5347)
        {
            if(var_6000fab5.targetname == "zone_start_spawners")
            {
                s_location = var_6000fab5;
            }
        }
    }
    else
    {
        s_location = Array::random(level.zm_loc_types["mechz_location"]);
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

function_ef1ba7e5()
{
	self waittill("death");
	if(isPlayer(self.attacker))
	{
		event = "death_mechz";
		if(!(isdefined(self.deathpoints_already_given) && self.deathpoints_already_given))
		{
			self.attacker zm_score::player_add_points(event, 1500);
		}
		if(isdefined(level.hero_power_update))
		{
			[[level.hero_power_update]](self.attacker, self);
		}
	}
}

function_949a3fdf()
{
	self waittill("hash_46c1e51d");
	v_origin = self.origin;
	a_ai = GetAISpeciesArray(level.zombie_team);
	a_ai_kill_zombies = ArraySortClosest(a_ai, v_origin, 18, 0, 200);
	foreach(ai_enemy in a_ai_kill_zombies)
	{
		if(isdefined(ai_enemy))
		{
			if(ai_enemy.archetype === "mechz")
			{
				ai_enemy DoDamage(level.mechz_health * 0.25, v_origin);
			}
			else
			{
				ai_enemy DoDamage(ai_enemy.health + 100, v_origin);
			}
		}
		wait(0.05);
	}
}

function_b03abc02(inflictor, attacker, damage, dFlags, mod, weapon, point, dir, hitLoc, offsetTime, boneIndex, modelIndex)
{
	if(isdefined(attacker) && isPlayer(attacker))
	{
		if(zm_spawner::player_using_hi_score_weapon(attacker))
		{
			damage_type = "damage";
		}
		else
		{
			damage_type = "damage_light";
		}
		if(!(isdefined(self.no_damage_points) && self.no_damage_points))
		{
			attacker zm_score::player_add_points(damage_type, mod, hitLoc, self.isdog, self.team, weapon);
		}
	}
}

function_55483494()
{
	a_zombies = GetAIArchetypeArray("zombie");
	foreach(zombie in a_zombies)
	{
		dist_sq = DistanceSquared(self.origin, zombie.origin);
		if(zombie function_10d36217(self) && dist_sq <= 12544)
		{
			self function_3efae612(zombie);
		}
	}
}

function_10d36217(mechz)
{
	origin = self.origin;
	facing_vec = AnglesToForward(mechz.angles);
	enemy_vec = origin - mechz.origin;
	enemy_yaw_vec = (enemy_vec[0], enemy_vec[1], 0);
	facing_yaw_vec = (facing_vec[0], facing_vec[1], 0);
	enemy_yaw_vec = VectorNormalize(enemy_yaw_vec);
	facing_yaw_vec = VectorNormalize(facing_yaw_vec);
	enemy_dot = VectorDot(facing_yaw_vec, enemy_yaw_vec);
	if(enemy_dot < 0.7)
	{
		return 0;
	}
	enemy_angles = VectorToAngles(enemy_vec);
	if(Abs(AngleClamp180(enemy_angles[0])) > 45)
	{
		return 0;
	}
	return 1;
}

function function_3efae612(zombie)
{
	zombie.KNOCKDOWN = 1;
	zombie.knockdown_type = "knockdown_shoved";
	zombie_to_mechz = self.origin - zombie.origin;
	zombie_to_mechz_2d = VectorNormalize((zombie_to_mechz[0], zombie_to_mechz[1], 0));
	zombie_forward = AnglesToForward(zombie.angles);
	zombie_forward_2d = VectorNormalize((zombie_forward[0], zombie_forward[1], 0));
	zombie_right = AnglesToRight(zombie.angles);
	zombie_right_2d = VectorNormalize((zombie_right[0], zombie_right[1], 0));
	dot = VectorDot(zombie_to_mechz_2d, zombie_forward_2d);
	if(dot >= 0.5)
	{
		zombie.knockdown_direction = "front";
		zombie.getup_direction = "getup_back";
	}
	else if(dot < 0.5 && dot > -0.5)
	{
		dot = VectorDot(zombie_to_mechz_2d, zombie_right_2d);
		if(dot > 0)
		{
			zombie.knockdown_direction = "right";
			if(math::cointoss())
			{
				zombie.getup_direction = "getup_back";
			}
			else
			{
				zombie.getup_direction = "getup_belly";
			}
		}
		else
		{
			zombie.knockdown_direction = "left";
			zombie.getup_direction = "getup_belly";
		}
	}
	else
	{
		zombie.knockdown_direction = "back";
		zombie.getup_direction = "getup_belly";
	}
}

function_d07fd448()
{
	self endon("death");
	self.b_flyin_done = 0;
	self.bgbIgnoreFearInHeadlights = 1;
	self util::waittill_any("mechz_flyin_done", "scene_done");
	self.b_flyin_done = 1;
	self.bgbIgnoreFearInHeadlights = 0;
}

function_c441eaba(var_678a2319)
{
	self endon("death");
	var_b54110bd = 2304;
	var_f0dad551 = 9216;
	var_44615973 = 2250000;
	self waittill("hash_f93797a6");
	a_zombies = GetAIArchetypeArray("zombie");
	foreach(e_zombie in a_zombies)
	{
		dist_sq = DistanceSquared(e_zombie.origin, var_678a2319);
		if(dist_sq <= var_b54110bd)
		{
			e_zombie kill();
		}
	}
	a_players = GetPlayers();
	foreach(player in a_players)
	{
		dist_sq = DistanceSquared(player.origin, var_678a2319);
		if(dist_sq <= var_b54110bd)
		{
			player DoDamage(100, var_678a2319, self, self);
		}
		scale = var_44615973 - dist_sq / var_44615973;
		if(scale <= 0 || scale >= 1)
		{
			return;
		}
		earthquake_scale = scale * 0.15;
		Earthquake(earthquake_scale, 0.1, var_678a2319, 1500);
		if(scale >= 0.66)
		{
			player PlayRumbleOnEntity("shotgun_fire");
			continue;
		}
		if(scale >= 0.33)
		{
			player PlayRumbleOnEntity("damage_heavy");
			continue;
		}
		player PlayRumbleOnEntity("reload_small");
	}
	if(isdefined(self.var_1411e129))
	{
		self.var_1411e129 delete();
	}
}

function_bbdc1f34(var_678a2319)
{
	self endon("death");
	self endon("hash_f93797a6");
	self waittill("hash_3d18ed4f");
	var_f0dad551 = 9216;
	while(1)
	{
		a_players = GetPlayers();
		foreach(player in a_players)
		{
			dist_sq = DistanceSquared(player.origin, var_678a2319);
			if(dist_sq <= var_f0dad551)
			{
				if(!isdefined(player.is_burning) && player.is_burning && zombie_utility::is_player_valid(player, 0))
				{
					player function_3389e2f3(self);
				}
			}
		}
		a_zombies = function_d41418b8();
		foreach(e_zombie in a_zombies)
		{
			dist_sq = DistanceSquared(e_zombie.origin, var_678a2319);
			if(dist_sq <= var_f0dad551 && self.var_e05d0be2 !== 1)
			{
				self function_3efae612(e_zombie);
				e_zombie function_f4defbc2();
			}
		}
		wait(0.1);
	}
}

function_3389e2f3(mechz)
{
	if(!isdefined(self.is_burning) && self.is_burning && zombie_utility::is_player_valid(self, 1))
	{
		self.is_burning = 1;
		if(!self hasPerk("specialty_armorvest"))
		{
			self burnplayer::SetPlayerBurning(1.5, 0.5, 30, mechz, undefined);
		}
		else
		{
			self burnplayer::SetPlayerBurning(1.5, 0.5, 20, mechz, undefined);
		}
		wait(1.5);
		self.is_burning = 0;
	}
}

function_bb048b27()
{
	self endon("death");
	while(1)
	{
		wait(randomIntRange(9, 14));
		self playsound("zmb_ai_mechz_vox_ambient");
	}
}

// shared\ai\mechz
function mechzDamageCallback(inflictor, attacker, damage, dFlags, mod, weapon, point, dir, hitLoc, offsetTime, boneIndex, modelIndex)
{
	if(isdefined(self.b_flyin_done) && !is_true(self.b_flyin_done))
	{
		return 0;
	}
	if(isdefined(level.mechz_should_stun_override) && !(is_true(self.stun) || is_true(self.stumble)))
	{
		if(self.stumble_stun_cooldown_time < GetTime() && !is_true(self.berserk))
		{
			self [[level.mechz_should_stun_override]](inflictor, attacker, damage, dFlags, mod, weapon, point, dir, hitLoc, offsetTime, boneIndex, modelIndex);
		}
	}
	if(IsSubStr(weapon.name, "elemental_bow") && isdefined(inflictor) && inflictor.classname === "rocket")
	{
		return 0;
	}
	damage = mechzWeaponDamageModifier(damage, weapon);
	if(isdefined(level.mechz_damage_override))
	{
		damage = [[level.mechz_damage_override]](attacker, damage);
	}
	if(!isdefined(self.next_pain_time) || GetTime() >= self.next_pain_time)
	{
		self thread mechz_play_pain_audio();
		self.next_pain_time = GetTime() + 250 + RandomInt(500); //will wait this long before playing a pain audio again
    }
	if(isdefined(self.damage_scoring_function))
	{
		self [[self.damage_scoring_function]](inflictor, attacker, damage, dFlags, mod, weapon, point, dir, hitLoc, offsetTime, boneIndex, modelIndex);
	}
	if(isdefined(level.mechz_staff_damage_override))
	{
		staffDamage = [[level.mechz_staff_damage_override]](inflictor, attacker, damage, dFlags, mod, weapon, point, dir, hitLoc, offsetTime, boneIndex, modelIndex);
		if(staffDamage > 0)
		{
			n_mechz_damage_percent = 0.5;
			if(!is_true(self.has_faceplate) && n_mechz_damage_percent < 1.0)
			{
				n_mechz_damage_percent = 1.0;
			}
			staffDamage = staffDamage * n_mechz_damage_percent;
			if(is_true(self.has_faceplate))
			{
				self mechz_track_faceplate_damage(staffDamage);
			}
			var_default(self.explosive_dmg_taken, 0);
			self.explosive_dmg_taken += staffDamage;
			if(isdefined(level.mechz_explosive_damage_reaction_callback))
			{
				self [[level.mechz_explosive_damage_reaction_callback]]();
			}
			return staffDamage;
		}
    }
	if(isdefined(level.mechz_explosive_damage_reaction_callback))
	{
		if(isdefined(mod) && mod == "MOD_GRENADE" || mod == "MOD_GRENADE_SPLASH" || mod == "MOD_PROJECTILE" || mod == "MOD_PROJECTILE_SPLASH" || mod == "MOD_EXPLOSIVE")
		{
			n_mechz_damage_percentage = 0.5;
			if(isdefined(attacker) && IsPlayer(attacker) && IsAlive(attacker) && (level.zombie_vars[attacker.team]["zombie_insta_kill"] || is_true(attacker.personal_instakill))) //instakill does normal damage
			{
				n_mechz_damage_percentage = 1.0;
			}
			explosive_damage = damage * n_mechz_damage_percentage;
			var_default(self.explosive_dmg_taken, 0);
			self.explosive_dmg_taken += explosive_damage;
			if(is_true(self.has_faceplate))
			{
				self mechz_track_faceplate_damage(explosive_damage);
			}
			self [[level.mechz_explosive_damage_reaction_callback]]();
			return explosive_damage;
		}
	}
	if(hitLoc == "head")
	{
		attacker show_hit_marker();
		return damage;
	}
	if(hitloc !== "none")
	{
		switch(hitLoc)
		{
            case "torso_upper":
                if(self.has_faceplate == true)
                {
                    faceplate_pos = self GetTagOrigin("j_faceplate");
                    dist_sq = DistanceSquared(faceplate_pos, point);
                    if(dist_sq <= 144)
                    {
                        self mechz_track_faceplate_damage(damage);
                        attacker show_hit_marker();
                    } 
                    headlamp_dist_sq = DistanceSquared(point, self GetTagOrigin("tag_headlamp_FX"));
                    if(headlamp_dist_sq <= 9)
                    {
                        self mechz_turn_off_headlamp(true);
                    }		
                }		
                partName = GetPartName("c_zom_mech_body", boneIndex);
                if(self.powercap_covered === true && (partName === "tag_powersupply" || partName === "tag_powersupply_hit"))
                {
                    self mechz_track_powercap_cover_damage(damage);
                    attacker show_hit_marker();
                    return damage * 0.1;
                }
                else if(self.powercap_covered !== true && self.has_powercap === true && (partName === "tag_powersupply" || partName === "tag_powersupply_hit"))
                {
                    self mechz_track_powercap_damage(damage);
                    attacker show_hit_marker();
                    return damage;
                }
                else if(self.powercap_covered !== true && self.has_powercap !== true && (partName === "tag_powersupply" || partName === "tag_powersupply_hit"))
                {
                    attacker show_hit_marker();
                    return damage * 0.5;
                }
                if(self.has_right_shoulder_armor === true && partName === "j_shoulderarmor_ri")
                {
                    self mechz_track_rshoulder_armor_damage(damage);
                    return damage * 0.1;
                }
                if(self.has_left_shoulder_armor === true && partName === "j_shoulderarmor_le")
                {
                    self mechz_track_lshoulder_armor_damage(damage);
                    return damage * 0.1;
                }
                return damage * 0.1;
                break;
            case "left_leg_lower":
                partName = GetPartName("c_zom_mech_body", boneIndex);
                if(partName === "j_knee_attach_le" && self.has_left_knee_armor === true)
                {
                    self mechz_track_lknee_armor_damage(damage);
                }
                return damage * 0.1;
                break;
            case "right_leg_lower":
                partName = GetPartName("c_zom_mech_body", boneIndex);
                if(partName === "j_knee_attach_ri" && self.has_right_knee_armor === true)
                {
                    self mechz_track_rknee_armor_damage(damage);
                }
                return damage * 0.1;
                break;
            case "left_hand":
            case "left_arm_lower":
            case "left_arm_upper":
                if(isdefined(level.mechz_left_arm_damage_callback))
                {
                    self [[level.mechz_left_arm_damage_callback]]();
                }
                return damage * 0.1;
                break;
            default:
                return damage * 0.1;
                break;
        }
    }
	if(mod == "MOD_PROJECTILE")
	{
		hit_damage = damage * 0.1;
		if(self.has_faceplate !== true)
		{
			head_pos = self GetTagOrigin("tag_eye");
			dist_sq = DistanceSquared(head_pos, point);
			if(dist_sq <= 144)
			{
				attacker show_hit_marker();
				return damage;
			}                           
		}
		if(self.has_faceplate === true)
		{
			faceplate_pos = self GetTagOrigin("j_faceplate");
			dist_sq = DistanceSquared(faceplate_pos, point);
			if(dist_sq <= 144)
			{
				self mechz_track_faceplate_damage(damage);
				attacker show_hit_marker();
			}
			headlamp_dist_sq = DistanceSquared(point, self GetTagOrigin("tag_headlamp_FX"));
			if(headlamp_dist_sq <= 9)
			{
				self mechz_turn_off_headlamp(true);
			}
		}
		power_pos = self GetTagOrigin("tag_powersupply_hit");
		power_dist_sq = DistanceSquared(power_pos, point);
		if(power_dist_sq <= 25)
		{
			if(self.powercap_covered !== true && self.has_powercap !== true)
			{
				attacker show_hit_marker();
				return damage;
			}				
			if(self.powercap_covered !== true && self.has_powercap === true)
			{
				self mechz_track_powercap_damage(damage);
				attacker show_hit_marker();
				return damage;
			}
			if(self.powercap_covered === true)
			{
				self mechz_track_powercap_cover_damage(damage);
				attacker show_hit_marker();
			}
		}
		if(self.has_right_shoulder_armor === true)
		{
			armor_pos = self GetTagOrigin("j_shoulderarmor_ri");
			dist_sq = DistanceSquared(armor_pos, point);
			if(dist_sq <= 64)
			{
				self mechz_track_rshoulder_armor_damage(damage);
			}
		}
		if(self.has_left_shoulder_armor === true)
		{
			armor_pos = self GetTagOrigin("j_shoulderarmor_le");
			dist_sq = DistanceSquared(armor_pos, point);
			if(dist_sq <= 64)
			{
				self mechz_track_lshoulder_armor_damage(damage);
			}
		}	
		if(self.has_right_knee_armor === true)
		{
			armor_pos = self GetTagOrigin("j_knee_attach_ri");
			dist_sq = DistanceSquared(armor_pos, point);
			if(dist_sq <= 36)
			{
				self mechz_track_rknee_armor_damage(damage);
			}
		}
		if(self.has_left_knee_armor === true)
		{
			armor_pos = self GetTagOrigin("j_knee_attach_le");
			dist_sq = DistanceSquared(armor_pos, point);
			
			if(dist_sq <= 36)
			{
				self mechz_track_lknee_armor_damage(damage);
			}
		}
		return hit_damage;
	}
	else if(mod == "MOD_PROJECTILE_SPLASH")
	{
		hit_damage = damage * 0.2;
		i_num_armor_pieces = 0;
		if(isdefined(level.mechz_faceplate_damage_override))
		{
			self [[level.mechz_faceplate_damage_override]](inflictor, attacker, damage, dFlags, mod, weapon, point, dir, hitLoc, offsetTime, boneIndex, modelIndex);
		}
		if(self.has_right_shoulder_armor === true)
		{
			i_num_armor_pieces += 1;
			right_shoulder_index = i_num_armor_pieces;
		}
		if(self.has_left_shoulder_armor === true)
		{
			i_num_armor_pieces += 1;
			left_shoulder_index = i_num_armor_pieces;
		}	
		if(self.has_right_knee_armor === true)
		{
			i_num_armor_pieces += 1;
			right_knee_index = i_num_armor_pieces;
		}		
		if(self.has_left_knee_armor === true)
		{
			i_num_armor_pieces += 1;
			left_knee_index = i_num_armor_pieces;
		}
		if(i_num_armor_pieces > 0)
		{
			if(i_num_armor_pieces <= 1)
			{
				i_random = 0;
			}
			else
			{
				i_random = RandomInt(i_num_armor_pieces - 1);
			}
			i_random += 1;
			if(self.has_right_shoulder_armor === true && right_shoulder_index === i_random)
			{
				self mechz_track_rshoulder_armor_damage(damage);
			}
			if(self.has_left_shoulder_armor === true && left_shoulder_index === i_random)
			{
				self mechz_track_lshoulder_armor_damage(damage);
			}
			if(self.has_right_knee_armor === true && right_knee_index === i_random)
			{
				self mechz_track_rknee_armor_damage(damage);
			}
			if(self.has_left_knee_armor === true && left_knee_index === i_random)
			{
				self mechz_track_lknee_armor_damage(damage);
			}			
		}
		else
		{
			if(self.powercap_covered === true)
			{
				self mechz_track_powercap_cover_damage(damage * 0.5);
			}
			if(self.has_faceplate == true)
			{
				self mechz_track_faceplate_damage(damage * 0.5);
			}	
		}		
		return hit_damage;
	}
	return 0;
}

mechzWeaponDamageModifier(damage, weapon)
{
	if(isdefined(weapon) && isdefined(weapon.name))
	{
		if(isSubStr(weapon.name, "shotgun_fullauto"))
		{
			return damage * 0.5;	
		}
		if(isSubStr(weapon.name, "lmg_cqb"))
		{
			return damage * 0.65;	
		}
		if(isSubStr(weapon.name, "lmg_heavy"))
		{
			return damage * 0.65;	
		}
		if(isSubStr(weapon.name, "shotgun_precision"))
		{
			return damage * 0.65;	
		}
		if(isSubstr(weapon.name, "shotgun_semiauto"))
		{
			return damage * 0.75;	
		}
	}
	return damage;
}

mechz_play_pain_audio()
{
	self playsound("zmb_ai_mechz_destruction");
}

mechz_track_faceplate_damage(damage)
{
	self.faceplate_health = self.faceplate_health - damage;
	if(self.faceplate_health <= 0)
	{
		self hide_part("j_faceplate");
		self clientfield::set("mechz_faceplate_detached", 1);
		self.has_faceplate = false;
		self mechz_turn_off_headlamp();
		self.partDestroyed = true;
		Blackboard::SetBlackBoardAttribute(self, "_mechz_part", "mechz_faceplate");
		self mechzGoBerserk();
		level notify("mechz_faceplate_detached");
	}	
}

mechz_turn_off_headlamp(headlamp_broken)
{
	if(headlamp_broken !== true)
	{
		self clientfield::set("mechz_headlamp_off", 1);
	}
	else
	{
		self clientfield::set("mechz_headlamp_off", 2);
	}
}

mechzGoBerserk()
{
	entity = self;	
	g_time = GetTime();
	entity.berserkEndTime = g_time + 10000;
	if(entity.berserk !== true)
	{
		entity.berserk = true;
		entity thread mechzEndBerserk();
		Blackboard::SetBlackBoardAttribute(entity, "_locomotion_speed", "locomotion_speed_sprint");
	}
}

mechz_track_powercap_cover_damage(damage)
{
	self.powercap_cover_health = self.powercap_cover_health - damage;
	if(self.powercap_cover_health <= 0)
	{
		self hide_part("tag_powersupply");
		self clientfield::set("mechz_powercap_detached", 1);		
		self.powercap_covered = false;
		self.partDestroyed = true;
		Blackboard::SetBlackBoardAttribute(self, "_mechz_part", "mechz_powercore");
	}
}

mechz_track_rshoulder_armor_damage(damage)
{
	self.right_shoulder_armor_health = self.right_shoulder_armor_health - damage;
	if(self.right_shoulder_armor_health <= 0)
	{
		self hide_part("j_shoulderarmor_ri");
		self clientfield::set("mechz_rshoulder_armor_detached", 1);		
		self.has_right_shoulder_armor = false;
	}
}

mechz_track_lshoulder_armor_damage(damage)
{
	self.left_shoulder_armor_health = self.left_shoulder_armor_health - damage;
	if(self.left_shoulder_armor_health <= 0)
	{
		self hide_part("j_shoulderarmor_le");
		self clientfield::set("mechz_lshoulder_armor_detached", 1);		
		self.has_left_shoulder_armor = false;
	}
}

mechz_track_lknee_armor_damage(damage)
{
	self.left_knee_armor_health = self.left_knee_armor_health - damage;
	if(self.left_knee_armor_health <= 0)
	{
		self hide_part("j_knee_attach_le");
		self clientfield::set("mechz_lknee_armor_detached", 1);		
		self.has_left_knee_armor = false;
	}
}

mechz_track_rknee_armor_damage(damage)
{
	self.right_knee_armor_health = self.right_knee_armor_health - damage;
	if(self.right_knee_armor_health <= 0)
	{
		self hide_part("j_knee_attach_ri");
		self clientfield::set("mechz_rknee_armor_detached", 1);		
		self.has_right_knee_armor = false;
	}
}

mechz_track_powercap_damage(damage)
{
	self.powercap_health = self.powercap_health - damage;
	if(self.powercap_health <=0)
	{
		if(IsDefined(level.mechz_powercap_destroyed_callback))
		{
			self [[level.mechz_powercap_destroyed_callback]]();
		}
		self hide_part("tag_gun_spin");
		self hide_part("tag_gun_barrel1");
		self hide_part("tag_gun_barrel2");
		self hide_part("tag_gun_barrel3");
		self hide_part("tag_gun_barrel4");
		self hide_part("tag_gun_barrel5");
		self hide_part("tag_gun_barrel6");
		self clientfield::set("mechz_claw_detached", 1);
		self.has_powercap = false;
		self.gun_attached = false;
		self.partDestroyed = true;
		Blackboard::SetBlackBoardAttribute(self, "_mechz_part", "mechz_gun");
		level notify("mechz_gun_detached");
	}
}

mechZEndBerserk()
{
	self endon("death");
	self endon("disconnect");
	while(self.berserk === true)
	{
		if(GetTime() >= self.berserkEndTime)
		{
			self.berserk = false;
			self.hasTurnedBerserk = false;
			self ASMSetAnimationRate(1.0);
			Blackboard::SetBlackBoardAttribute(self, "_locomotion_speed", "locomotion_speed_run");
		}
		wait 0.25;
	}		
}

hide_part(strTag)
{
	if (self HasPart(strTag))
	{
		self HidePart(strTag);  
	}
}