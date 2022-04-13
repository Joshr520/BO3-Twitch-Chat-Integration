spawn_stalingrad_valkyrie(n_to_spawn)
{
	if(!isdefined(n_to_spawn))
	{
		n_to_spawn = 1;
	}
	n_spawned = 0;
	while(n_spawned < n_to_spawn)
	{
		if(isdefined(level.var_809d579e))
		{
			s_spawn_loc = [[level.var_809d579e]](level.var_fda4b3f3);
		}
		else
		{
			s_spawn_loc = function_f9c9e7e0();
		}
		if(!isdefined(s_spawn_loc))
		{
			return 0;
		}
		ai = function_fded8158(level.var_fda4b3f3[0]);
		if(isdefined(ai))
		{
			ai thread function_b27530eb(s_spawn_loc.origin);
			n_spawned++;
		}
		function_20c64325();
	}
	return 1;
}

function_f9c9e7e0()
{
	var_3f5c6aea = [];
	s_spawn_loc = undefined;
	foreach(s_zone in level.zones)
	{
		if(s_zone.is_enabled && isdefined(s_zone.a_loc_types["sentinel_location"]) && s_zone.a_loc_types["sentinel_location"].size)
		{
			foreach(s_loc in s_zone.a_loc_types["sentinel_location"])
			{
				foreach(player in level.activePlayers)
				{
					n_dist_sq = DistanceSquared(player.origin, s_loc.origin);
					if(n_dist_sq > 65536 && n_dist_sq < 2250000)
					{
						if(!isdefined(var_3f5c6aea))
						{
							var_3f5c6aea = [];
						}
						else if(!IsArray(var_3f5c6aea))
						{
							var_3f5c6aea = Array(var_3f5c6aea);
						}
						var_3f5c6aea[var_3f5c6aea.size] = s_loc;
						break;
					}
				}
			}
		}
	}
	s_spawn_loc = Array::random(var_3f5c6aea);
	if(!isdefined(s_spawn_loc))
	{
		s_spawn_loc = Array::random(level.zm_loc_types["sentinel_location"]);
	}
	return s_spawn_loc;
}

function_fded8158(spawner, s_spot)
{
	var_663b2442 = zombie_utility::spawn_zombie(level.var_fda4b3f3[0], "sentinel", s_spot);
	if(isdefined(var_663b2442))
	{
		var_663b2442.check_point_in_enabled_zone = ::check_point_in_playable_area;
	}
	return var_663b2442;
}

function_20c64325()
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

function_b27530eb(v_pos)
{
	self endon("death");
	self sentinel_Intro();
	self vehicle::toggle_sounds(0);
	var_92968756 = v_pos + VectorScale((0, 0, 1), 30);
	self.origin = v_pos + VectorScale((0, 0, 1), 5000);
	self.angles = (0, randomIntRange(0, 360), 0);
	e_origin = spawn("script_origin", self.origin);
	e_origin.angles = self.angles;
	self LinkTo(e_origin);
	e_origin moveto(var_92968756, 3);
	e_origin playsound("zmb_sentinel_intro_spawn");
	e_origin util::delay(3, undefined, ::function_e6bf0279);
	self clientfield::set("sentinel_spawn_fx", 1);
	wait(3);
	self clientfield::set("sentinel_spawn_fx", 0);
	wait(1);
	self vehicle::toggle_sounds(1);
	self.origin = var_92968756;
	self Unlink();
	e_origin delete();
	self flag::set("completed_spawning");
	wait(0.2);
	self sentinel_IntroCompleted();
}

function_e6bf0279()
{
	self playsound("zmb_sentinel_intro_land");
}

sentinel_Intro()
{	
	sentinel_NavigationStandStill();	
	self.playing_intro_anim = true;
	self ASMRequestSubstate("intro@default");
}

sentinel_IntroCompleted()
{	
	self.playing_intro_anim = false;
	if(!self vehicle_ai::is_instate("scripted"))
	{
		self thread sentinel_NavigateTheWorld();
	}
}

sentinel_NavigationStandStill()
{
	self endon("change_state");
	self endon("death");
	self notify("abort_navigation");
	self notify("near_goal");
	wait 0.05;
	if(GetDvarInt("sentinel_NavigationStandStill_new", 0) > 0)
	{
		self ClearVehGoalPos();
		self SetVehVelocity((0, 0, 0));
		self.vehAirCraftCollisionEnabled = true;	
		return;	
	}
	if(GetDvarInt("sentinel_ClearVehGoalPos", 1) == 1)
	{
		self ClearVehGoalPos();
	}
	if(GetDvarInt("sentinel_PathVariableOffsetClear", 1) == 1)
	{
		self PathVariableOffsetClear();
	}
	if(GetDvarInt("sentinel_PathFixedOffsetClear", 1) == 1)
	{
		self PathFixedOffsetClear();
	}
	if(GetDvarInt("sentinel_ClearSpeed", 1) == 1)
	{
		self SetSpeed(0);
		self SetVehVelocity((0, 0, 0));
		self SetPhysAcceleration((0, 0, 0));
		self SetAngularVelocity((0, 0, 0));
	}
	self.vehAirCraftCollisionEnabled = true;
}

function sentinel_NavigateTheWorld()
{
	self endon("change_state");
	self endon("death");
	self endon("abort_navigation");
	self notify("sentinel_NavigateTheWorld");
	self endon("sentinel_NavigateTheWorld");
	lastTimeChangePosition = 0;
	self.shouldGotoNewPosition = false;
	self.last_failsafe_count = 0;
	Sentinel_Move_Speed = GetDvarInt("Sentinel_Move_Speed", 25);
	Sentinel_Evade_Speed = GetDvarInt("Sentinel_Evade_Speed", 40);
	self SetSpeed(Sentinel_Move_Speed);
	self ASMRequestSubstate("locomotion@movement");
	self.current_pathto_pos = undefined;
	self.next_near_player_check = 0;
	b_use_path_finding = true;
	while(true)
	{
		current_pathto_pos = undefined;
		b_in_tactical_position = false;
		if(is_true(self.playing_intro_anim))
		{
			wait 0.1;
		}
		else if(self.goalforced)
		{
			returnData = [];
			returnData["origin"] = self GetClosestPointOnNavVolume(self.goalpos, 100);
			returnData["centerOnNav"] = IsPointInNavVolume(self.origin, "navvolume_small");
			current_pathto_pos = returnData["origin"];
		}
		else if(isdefined(self.forced_pos))
		{
			returnData = [];
			returnData["origin"] = self GetClosestPointOnNavVolume(self.forced_pos, 100);
			returnData["centerOnNav"] = IsPointInNavVolume(self.origin, "navvolume_small");
			current_pathto_pos = returnData["origin"];
		}
		else if(sentinel_ShouldChangeSentinelPosition())
		{
			if(is_true(self.evading_player))
			{
				self.evading_player = false;
				self SetSpeed(Sentinel_Evade_Speed);
			}
			else
			{
				self SetSpeed(Sentinel_Move_Speed);
			}
			returnData = sentinel_GetNextMovePositionTactical(self.should_buff_zombies);
			current_pathto_pos = returnData["origin"];
			self.lastJukeTime = GetTime();
			self.nextJukeTime = GetTime() + 1000 + RandomInt(4000);
			b_in_tactical_position = true;
		}
		else if(GetTime() > self.next_near_player_check && sentinel_IsNearAnotherPlayer(self.origin, 100))
		{
			self.evading_player = true;
			self.next_near_player_check = GetTime() + 1000;
			self.nextJukeTime = 0;
			self notify("near_goal");
		}
		is_on_nav_volume = IsPointInNavVolume(self.origin, "navvolume_small");	
		if(isdefined(current_pathto_pos))
		{
			if(isdefined(self.stuckTime) && is_true(is_on_nav_volume))
			{
				self.stuckTime = undefined;
			}
			if(self SetVehGoalPos(current_pathto_pos, true, b_use_path_finding))
			{
				b_use_path_finding = true;
				self.b_in_tactical_position = b_in_tactical_position;
				self thread sentinel_PathUpdateInterrupt();
				self vehicle_ai::waittill_pathing_done(5);
				current_pathto_pos = undefined;
			}
			else if(is_true(is_on_nav_volume))
			{
				self sentinel_KillMyself();	
				self.last_failsafe_time = undefined;
			}
		}
		if(!is_true(is_on_nav_volume))
		{
			if(!isdefined(self.last_failsafe_time))
			{
				self.last_failsafe_time = GetTime();
			}
			if((GetTime() - self.last_failsafe_time) >= 3000)
			{
				self.last_failsafe_count = 0;
			}
			else
			{
				self.last_failsafe_count++;
			}
			self.last_failsafe_time = GetTime();
			if(self.last_failsafe_count > 25)
			{
				new_sentinel_pos = self GetClosestPointOnNavVolume(self.origin, 120);
				if(isdefined(new_sentinel_pos))
				{
					dvar_sentinel_getback_to_volume_epsilon = GetDvarInt("dvar_sentinel_getback_to_volume_epsilon", 5);
					if(Distance(self.origin, new_sentinel_pos) < dvar_sentinel_getback_to_volume_epsilon)
					{
						self.origin = new_sentinel_pos;
					}
					else
					{
						self.vehAirCraftCollisionEnabled = false;	
						if(self SetVehGoalPos(new_sentinel_pos, true, false))
						{
							self thread sentinel_PathUpdateInterrupt();
							self vehicle_ai::waittill_pathing_done(5);
							current_pathto_pos = undefined;
						}
						self.vehAirCraftCollisionEnabled = true;
					}
				}
				else if(self.last_failsafe_count > 100)
				{
					self sentinel_KillMyself();
				}
			}
        }
		if(!is_true(is_on_nav_volume))
		{
			if(!isdefined(self.stuckTime))
			{
				self.stuckTime = GetTime();
			}
			if(GetTime() - self.stuckTime > 15000)
			{
				self sentinel_KillMyself();
			}
		}
		wait 0.1;
	}
}

sentinel_KillMyself()
{
	self DoDamage(self.health + 100, self.origin);
}

sentinel_PathUpdateInterrupt()
{
	self endon("death");
	self endon("change_state");
	self endon("near_goal");
	self endon("reached_end_node");
	self notify("sentinel_PathUpdateInterrupt");
	self endon("sentinel_PathUpdateInterrupt");
	skip_sentinel_PathUpdateInterrupt = GetDvarInt("skip_sentinel_PathUpdateInterrupt", 1);
	if(skip_sentinel_PathUpdateInterrupt == 1)
	{
		return;
	}
	wait 1;
	while(1)
	{
		if(isdefined(self.current_pathto_pos))
		{
			if(distance2dSquared(self.origin, self.goalpos) < sqr(self.goalradius))
			{		
				wait 0.2;
				self notify("near_goal");
			}
		}
		wait 0.2;
	}
}

sentinel_ShouldChangeSentinelPosition()
{
	if(GetTime() > self.nextJukeTime)
	{
		return true;
	}
	if(isdefined(self.sentinel_droneEnemy))
	{
		if(isdefined(self.lastJukeTime))
		{
			if((GetTime() - self.lastJukeTime) > 3000)
			{
				speed = self GetSpeed();
				if(speed < 1)
				{
					if(!sentinel_IsInsideEngagementDistance(self.origin, self.sentinel_droneEnemy.origin + (0, 0, 48), true))
					{
						return true;
					}
				}
			}
		}
	}
	return false;
}

sentinel_IsInsideEngagementDistance(origin, position, b_accept_negative_height)
{
	if(! (Distance2DSquared(position, origin) > sqr(sentinel_GetEngagementDistMin()) &&
	       Distance2DSquared(position, origin) < sqr(sentinel_GetEngagementDistMax())))
	{
		return false;
	}
	if(is_true(b_accept_negative_height))
	{
		return (abs(origin[2] - position[2]) >= sentinel_GetEngagementHeightMin()) && (abs(origin[2] - position[2]) <= sentinel_GetEngagementHeightMax());
	}
	else
	{	
		return ((position[2] - origin[2]) >= sentinel_GetEngagementHeightMin()) && ((position[2] - origin[2]) <= sentinel_GetEngagementHeightMax());
	}
}

sentinel_GetEngagementDistMin()
{
	if(sentinel_IsEnemyInNarrowPlace())
	{
		return self.settings.engagementDistMin * 0.2;
	}
	else if(is_true(self.in_compact_mode))
	{
		return self.settings.engagementDistMin * 0.5;
	}
	return self.settings.engagementDistMin;
}

sentinel_GetEngagementDistMax()
{
	if(sentinel_IsEnemyInNarrowPlace())
	{
		return self.settings.engagementDistMax * 0.3;
	}
	else if(is_true(self.in_compact_mode))
	{
		return self.settings.engagementDistMax * 0.85;
    }
	return self.settings.engagementDistMax;
}

sentinel_GetEngagementHeightMin()
{
	if(!isdefined(self.sentinel_droneEnemy))
	{
		return self.settings.engagementHeightMin * 3;
	}	
	return self.settings.engagementHeightMin;
}

sentinel_GetEngagementHeightMax()
{
	if(is_true(self.in_compact_mode))
	{
		return self.settings.engagementHeightMax * 0.8;
	}
	return self.settings.engagementHeightMax;
}

sentinel_IsEnemyInNarrowPlace()
{
	if(!isdefined(self.sentinel_droneEnemy))
	{
		return false;
	}
	if(!isdefined(self.v_narrow_volume))
	{
		self.v_narrow_volume = GetEnt("sentinel_narrow_nav", "targetname");
	}
	if(isdefined(self.v_narrow_volume) && isdefined(self.sentinel_droneEnemy))
	{
		if(self.sentinel_droneEnemy IsTouching(self.v_narrow_volume))
		{
			return true;
		}
	}
	return false;
}

sentinel_IsEnemyIndoors()
{
	if(!isdefined(self.v_compact_mode))
	{
		v_compact_mode = GetEnt("sentinel_compact", "targetname");
	}
	if(isdefined(v_compact_mode))
	{
		if(self.sentinel_droneEnemy IsTouching(v_compact_mode))
		{
			return true;
		}
	}
	return false;
}

function sentinel_GetNextMovePositionTactical(b_do_not_chase_enemy) // has self.sentinel_droneEnemy
{
	self endon("change_state");
	self endon("death");
	if(isdefined(self.sentinel_droneEnemy))
	{
		selfDistToTarget = Distance2D(self.origin, self.sentinel_droneEnemy.origin);
	}
	else
	{
		selfDistToTarget = 0;
    }
	goodDist = 0.5 * (sentinel_GetEngagementDistMin() + sentinel_GetEngagementDistMax());
	closeDist = 1.2 * goodDist;
	farDist = 3 * goodDist;
	queryMultiplier = MapFloat(closeDist, farDist, 1, 3, selfDistToTarget);
	preferedHeightRange = 0.5 * (sentinel_GetEngagementHeightMax() + sentinel_GetEngagementHeightMin());
	randomness = 20;
	SENTINEL_DRONE_TOO_CLOSE_TO_SELF_DIST_EX = GetDvarInt("SENTINEL_DRONE_TOO_CLOSE_TO_SELF_DIST_EX", 70);
	SENTINEL_DRONE_MOVE_DIST_MAX_EX = GetDvarInt("SENTINEL_DRONE_MOVE_DIST_MAX_EX", 600);
	SENTINEL_DRONE_MOVE_SPACING = GetDvarInt("SENTINEL_DRONE_MOVE_SPACING", 25);
	SENTINEL_DRONE_RADIUS_EX = GetDvarInt("SENTINEL_DRONE_RADIUS_EX", 35);
	SENTINEL_DRONE_HIGHT_EX = GetDvarInt("SENTINEL_DRONE_HIGHT_EX", int(preferedHeightRange));
	spacing_multiplier = 1.5;
	query_min_dist = self.settings.engagementDistMin;
	query_max_dist = SENTINEL_DRONE_MOVE_DIST_MAX_EX;
	if(!is_true(b_do_not_chase_enemy) && isdefined(self.sentinel_droneEnemy) && (GetTime() > self.targetPlayerTime))
	{
		charge_at_position = self.sentinel_droneEnemy.origin + (0, 0, 48);
		if(!IsPointInNavVolume(charge_at_position, "navvolume_small"))
		{
			closest_point_on_nav_volume = GetDvarInt("closest_point_on_nav_volume", 120);
			charge_at_position = self GetClosestPointOnNavVolume(charge_at_position, closest_point_on_nav_volume);
		}
		if(!isdefined(charge_at_position))
		{
			queryResult = PositionQuery_Source_Navigation(self.origin, SENTINEL_DRONE_TOO_CLOSE_TO_SELF_DIST_EX, SENTINEL_DRONE_MOVE_DIST_MAX_EX * queryMultiplier, SENTINEL_DRONE_HIGHT_EX * queryMultiplier, SENTINEL_DRONE_MOVE_SPACING, "navvolume_small", SENTINEL_DRONE_MOVE_SPACING * spacing_multiplier);
		}
		else
		{
			if(sentinel_IsEnemyInNarrowPlace())
			{
				spacing_multiplier = 1;
				SENTINEL_DRONE_MOVE_SPACING = 15;
				query_min_dist = self.settings.engagementDistMin * GetDvarFloat("sentinel_query_min_dist", 0.2);
				query_max_dist = query_max_dist * 0.5;
			}
			else if(is_true(self.in_compact_mode) || sentinel_IsEnemyIndoors())
			{
				spacing_multiplier = 1;
				SENTINEL_DRONE_MOVE_SPACING = 15;
				query_min_dist = self.settings.engagementDistMin * GetDvarFloat("sentinel_query_min_dist", 0.5);
			}
			
			queryResult = PositionQuery_Source_Navigation(charge_at_position, query_min_dist, query_max_dist * queryMultiplier, SENTINEL_DRONE_HIGHT_EX * queryMultiplier, SENTINEL_DRONE_MOVE_SPACING, "navvolume_small", SENTINEL_DRONE_MOVE_SPACING * spacing_multiplier);
		}
	}
	else
	{
		queryResult = PositionQuery_Source_Navigation(self.origin, SENTINEL_DRONE_TOO_CLOSE_TO_SELF_DIST_EX, SENTINEL_DRONE_MOVE_DIST_MAX_EX * queryMultiplier, SENTINEL_DRONE_HIGHT_EX * queryMultiplier, SENTINEL_DRONE_MOVE_SPACING, "navvolume_small", SENTINEL_DRONE_MOVE_SPACING * spacing_multiplier);
	}
	PositionQuery_Filter_DistanceToGoal(queryResult, self);
	vehicle_ai::PositionQuery_Filter_OutOfGoalAnchor(queryResult);
	if(isdefined(self.sentinel_droneEnemy))
	{
		if(RandomInt(100) > 15)
		{
			self vehicle_ai::PositionQuery_Filter_EngagementDist(queryResult, self.sentinel_droneEnemy, sentinel_GetEngagementDistMin(), sentinel_GetEngagementDistMax());
		}
		goalHeight = self.sentinel_droneEnemy.origin[2] + 0.5 * (sentinel_GetEngagementHeightMin() + sentinel_GetEngagementHeightMax());	
		enemy_origin = self.sentinel_droneEnemy.origin + (0, 0, 48);
	}
	else
	{
		goalHeight = self.origin[2] + 0.5 * (sentinel_GetEngagementHeightMin() + sentinel_GetEngagementHeightMax());	
		enemy_origin = self.origin;
	}
	best_point = undefined;
	best_score = undefined;
	trace_count = 0;
	foreach (point in queryResult.data)
	{
		if(sentinel_IsInsideEngagementDistance(enemy_origin, point.origin))
		{
			add_point_score(point, "insideEngagementDistance", 25);
		}
		add_point_score(point, "random", randomFloatRange(0, randomness));

		if(isdefined(point.distAwayFromEngagementArea))
		{
			add_point_score(point, "engagementDist", point.distAwayFromEngagementArea);
		}
		is_near_another_sentinel = Sentinel_IsNearAnotherSentinel(point.origin, 200); //@ToDo move to variable
		if(is_true(is_near_another_sentinel))
		{
			add_point_score(point, "NearAnotherSentinel", -200); //@ToDo move to variable
		}
		is_overlap_another_sentinel = Sentinel_IsNearAnotherSentinel(point.origin, 100); //@ToDo move to variable
		if(is_true(is_overlap_another_sentinel))
		{
			add_point_score(point, "OverlapAnotherSentinel", -2000); //@ToDo move to variable
		}
		is_near_another_player = sentinel_IsNearAnotherPlayer(point.origin, 150); //@ToDo move to variable
		if(is_true(is_near_another_player))
		{
			add_point_score(point, "NearAnotherPlayer", -200); //@ToDo move to variable
		}
		distFromPreferredHeight = abs(point.origin[2] - goalHeight);
		if(distFromPreferredHeight > preferedHeightRange)
		{
			heightScore = (distFromPreferredHeight - preferedHeightRange) * 3;//  MapFloat(0, 500, 0, 1000, distFromPreferredHeight);
			add_point_score(point, "height", heightScore);
        }
		if(!isdefined(best_score))
		{
			best_score = point.score;
			best_point = point;
			if(isdefined(self.sentinel_droneEnemy))
			{
				best_point.visibile = int(BulletTracePassed(point.origin, enemy_origin, false, self, self.sentinel_droneEnemy));
			}
			else
			{
				best_point.visibile = int(BulletTracePassed(point.origin, enemy_origin, false, self));
			}
		}
		else
		{
			if(point.score > best_score)
			{
				if(isdefined(self.sentinel_droneEnemy))
				{
					point.visibile = int(BulletTracePassed(point.origin, enemy_origin, false, self, self.sentinel_droneEnemy));
				}
				else
				{
					point.visibile = int(BulletTracePassed(point.origin, enemy_origin, false, self));
				}
				if(point.visibile >= best_point.visibile)
				{
					best_score = point.score;
					best_point = point;
				}
			}	
		}
		
	}
	if(isdefined(best_point))
	{
		if(best_point.score < -1000)
		{
			best_point = undefined;
		}
	}
	self vehicle_ai::PositionQuery_DebugScores(queryResult);
	returnData = [];
	returnData[ "origin" ] = ((isdefined(best_point)) ? best_point.origin : undefined);
	returnData[ "centerOnNav" ] = queryResult.centerOnNav;
	return returnData;
}

sentinel_IsNearAnotherSentinel(point, min_distance)
{
	if(!isdefined(level.a_sentinel_drones))
	{
		return false;
	}
	for(i = 0; i < level.a_sentinel_drones.size; i++)
	{
		if(!isdefined(level.a_sentinel_drones[i]))
		{
			continue;
		}
		if(level.a_sentinel_drones[i] == self) continue;
		min_distance_sq = min_distance * min_distance;
		distance_sq = DistanceSquared(level.a_sentinel_drones[i].origin, point);
		if(distance_sq < min_distance_sq)
		{
			return true;
		}
	}
	return false;
}

sentinel_IsNearAnotherPlayer(origin, min_distance)
{
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		if(!is_target_valid(players[i]))
		{
			continue;
        }
		min_distance_sq = min_distance * min_distance;
		distance_sq = DistanceSquared(origin, players[i].origin + (0, 0, 48));
		if(distance_sq < min_distance_sq)
		{
			return true;
		}
    }
	return false;
}

add_point_score(pointStruct, name, point_score)
{
	if(!isdefined(pointStruct._scoreDebug))
	{
		pointStruct._scoreDebug = [];
	}
	pointStruct._scoreDebug[name] = point_score;
	pointStruct.score += point_score;
}

is_target_valid(target)
{
	if(!isdefined(target)) 
	{
		return false; 
	}
	if(!IsAlive(target))
	{
		return false; 
	} 
	if(IsPlayer(target) && target.sessionstate == "spectator")
	{
		return false; 
    }
	if(IsPlayer(target) && target.sessionstate == "intermission")
	{
		return false; 
	}
	if(is_true(target.ignoreme))
	{
		return false;
	}
	if(target IsNoTarget())
	{
		return false;
	}
	if(is_true(target.is_elemental_zombie))
	{
		return false;
	}
	if(isdefined(level.is_valid_player_for_sentinel_drone))
	{
		if(![[level.is_valid_player_for_sentinel_drone]](target))
		{
			return false;
		}
	}
	if(is_true(self.should_buff_zombies) && IsPlayer(target))
	{
		if(isdefined(get_sentinel_nearest_zombie()))
		{
			return false;
		}
	}
	return true; 
}

get_sentinel_nearest_zombie(b_ignore_elemental = true, b_outside_playable_area = true, radius = 2000)
{
	if(isdefined(self.sentinel_GetNearestZombie))
	{
		ai_zombie = [[self.sentinel_GetNearestZombie]](self.origin, b_ignore_elemental, b_outside_playable_area, radius);
		return ai_zombie;
	}
	return undefined;
}