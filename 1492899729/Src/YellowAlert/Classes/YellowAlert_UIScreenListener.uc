// This is an Unreal Script
class YellowAlert_UIScreenListener extends UIScreenListener Config(YellowAlert);

var config bool EnableAItoAIActivation;
var config bool AllowBonusReflexActions;
var config bool DisableFirstTurn;

var config float REFLEX_ACTION_CHANCE_YELLOW;
var config float REFLEX_ACTION_CHANCE_GREEN;
var config float REFLEX_ACTION_CHANCE_REDUCTION;
const DefensiveReflexAction = 'DefensiveReflexActionPoint_LW';
const NoReflexActionUnitValue = 'NoReflexAction_LW';

// Transient helper vars for alien reflex actions. These are not persisted.
var transient int LastReflexGroupId;          // ObjectID of the last group member we processed
var transient int NumSuccessfulReflexActions; // The number of successful reflex actions we've added for the current pod

event OnInit(UIScreen screen)
{
	//local XComGameState_Player PlayerState;
	local Object ThisObj;
	ThisObj = self;
	
	`XEVENTMGR.RegisterForEvent(ThisObj, 'AbilityActivated', OnAbilityActivated, ELD_OnStateSubmitted);
	`XEVENTMGR.RegisterForEvent(ThisObj, 'AlertDataTriggerAlertAbility', OnAlertDataTriggerAlertAbility, ELD_OnStateSubmitted);
	`XEVENTMGR.RegisterForEvent(ThisObj, 'OnEnvironmentalDamage', OnExplosion, ELD_OnStateSubmitted);
	`XEVENTMGR.RegisterForEvent(ThisObj, 'SpawnReinforcementsComplete', OnSpawnReinforcementsComplete, ELD_OnStateSubmitted);
	`XEVENTMGR.RegisterForEvent(ThisObj, 'ScamperBegin', RefundActionPoint, ELD_OnStateSubmitted);
}

event OnRemoved(UIScreen screen)
{
	local Object ThisObj;
	ThisObj = self;
	`XEVENTMGR.UnRegisterFromEvent(ThisObj, 'AlertDataTriggerAlertAbility');
	`XEVENTMGR.UnRegisterFromEvent(ThisObj, 'AbilityActivated');
	`XEVENTMGR.UnRegisterFromEvent(ThisObj, 'OnEnvironmentalDamage');
	`XEVENTMGR.UnRegisterFromEvent(ThisObj, 'SpawnReinforcementsComplete');
	`XEVENTMGR.UnRegisterFromEvent(ThisObj, 'ScamperBegin');
}

defaultProperties
{
    ScreenClass = UITacticalHUD
}

//Create Seesexplosion alerts (truly it is produced by sound but I am using the default eAC_SeesExplosion) 
function EventListenerReturn OnExplosion(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameStateHistory History;
	local XComGameState_EnvironmentDamage DamageGameState;
	local Vector DamageLocation;
	local TTile DamageTileLocation;
	local Name DamageType;
	local XComGameState NewGameState;
	local AlertAbilityInfo AlertInfo;
	local XComGameState_Unit kUnitState;
	local XComGameState_AIUnitData NewUnitAIState, kAIData;
	local array<StateObjectReference> AliensInRange; // LWS Added
	local bool CleanupAIData; // LWS Added
	local int Radius;

	DamageGameState = XComGameState_EnvironmentDamage(EventData);
	Radius = DamageGameState.DamageRadius;
	DamageType = DamageGameState.DamageTypeTemplateName;
	//projectiles are grenade launchers - these need to have a radius
	if((DamageType == 'Explosion' || DamageType == 'DefaultProjectile') && DamageGameState.DamageRadius>0)
	{
		`Log("OnExplosion: Damage type is "@DamageType@" and radius is"@Radius);
	}
	else
	{
	return ELR_NoInterrupt;
	}

	DamageLocation = DamageGameState.HitLocation;
	DamageTileLocation = `XWORLD.GetTileCoordinatesFromPosition(DamageLocation);
	Radius = 28 + (Radius/96);//standard grenades are 30, larger explosions create a larger radius
	`Log("OnExplosion: Damage tile location found at " $DamageTileLocation.X$","@DamageTileLocation.Y$","@DamageTileLocation.Z);	 

	History = `XCOMHISTORY;
	
	// Kick off mass alert to location.
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState( "Explosion Alert" );

	AlertInfo.AlertTileLocation = DamageTileLocation;
	AlertInfo.AlertRadius = Radius;
	AlertInfo.AlertUnitSourceID = DamageGameState.DamageCause.ObjectID;
	AlertInfo.AnalyzingHistoryIndex = History.GetCurrentHistoryIndex( ); //NewGameState.HistoryIndex; <- this value is -1.

	// Gather the units in sound range of this explosion.
	class'HelpersYellowAlert'.static.GetAlienUnitsInRange(DamageTileLocation, Radius, AliensInRange);

	foreach History.IterateByClassType( class'XComGameState_AIUnitData', kAIData )
	{
		kUnitState = XComGameState_Unit( History.GetGameStateForObjectID( kAIData.m_iUnitObjectID ) );
		if (kUnitState != None && kUnitState.IsAlive( ))
		{
			// LWS Add: Skip units outside of sound range
			if (AliensInRange.Find('ObjectID', kUnitState.ObjectID) < 0)
				continue;
			CleanupAIData = false;
			// LWS: Check to see if we already have ai data for this unit in this game state (alert may already have been propagated to
			// group members).
			NewUnitAIState = XComGameState_AIUnitData(NewGameState.GetGameStateForObjectID(kAIData.ObjectID));
			if (NewUnitAIState == none)
			{
				NewUnitAIState = XComGameState_AIUnitData( NewGameState.CreateStateObject( kAIData.Class, kAIData.ObjectID ) );
				// LWS: This unit will need cleanup if we fail to add the alert.
				CleanupAIData = true;
			}
			if( NewUnitAIState.AddAlertData( kAIData.m_iUnitObjectID, eAC_SeesExplosion, AlertInfo, NewGameState ) )
			{
				NewGameState.AddStateObject(NewUnitAIState);
			}
			else
			{
				// LWS Add: Don't cleanup this AI unit data unless we created it.
				if (CleanupAIData)
				{
					NewGameState.PurgeGameStateForObjectID(NewUnitAIState.ObjectID);
				}
			}
		}
	}

	if( NewGameState.GetNumGameStateObjects() > 0 )
	{
		`GAMERULES.SubmitGameState(NewGameState);
	}
	else
	{
		History.CleanupPendingGameState(NewGameState);
	}
	return ELR_NoInterrupt;
}

// Gutted version of the function from XComGameState_Unit that includes a small Long War fix.
// This will cause sound alerts to pick for aliens when hear shots coming from other aliens
// Because GetAlienUnitsInRange instead of GetEnemiesInRange
// Runs in addition to the default method since there is no harm in notifying units twice about sounds
function EventListenerReturn OnAbilityActivated(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_Ability ActivatedAbilityState;
	local XComGameStateContext_Ability ActivatedAbilityStateContext;
	local XComGameState_Unit SourceUnitState, EnemyInSoundRangeUnitState;
	local XComGameState_Item WeaponState;
	local int SoundRange;
	local TTile SoundTileLocation;
	local Vector SoundLocation;
	local array<StateObjectReference> Enemies;
	local StateObjectReference EnemyRef;
	local XComGameStateHistory History;
	local XComGameState_Unit ThisUnitState;

	ActivatedAbilityStateContext = XComGameStateContext_Ability(GameState.GetContext());

	// do not process concealment breaks or AI alerts during interrupt processing
	if( ActivatedAbilityStateContext.InterruptionStatus == eInterruptionStatus_Interrupt )
	{
		return ELR_NoInterrupt;
	}

	History = `XCOMHISTORY;
	ThisUnitState = XComGameState_Unit(EventSource);
	ActivatedAbilityState = XComGameState_Ability(EventData);

	if( ActivatedAbilityState.DoesAbilityCauseSound() )
	{
		if( ActivatedAbilityStateContext != None && ActivatedAbilityStateContext.InputContext.ItemObject.ObjectID > 0 )
		{
			SourceUnitState = XComGameState_Unit(History.GetGameStateForObjectID(ActivatedAbilityStateContext.InputContext.SourceObject.ObjectID));
			WeaponState = XComGameState_Item(GameState.GetGameStateForObjectID(ActivatedAbilityStateContext.InputContext.ItemObject.ObjectID));

            // LWS Mods: If this weapon originates sound at the target and there is source ammo involved, use that sound range. This is needed
            // for grenade launchers, which have a weapon range of 0, but the ammo is what we want to use for the sound range. Thrown grenades
            // have no source ammo (the grenade is the weapon, there is no launcher) so we will use the weapon state in the else.
			//Grenade launchers are now picked up as SeesExplosion Alerts
            if (!WeaponState.SoundOriginatesFromOwnerLocation() && ActivatedAbilityState.GetSourceAmmo() != none)
            {
                SoundRange = ActivatedAbilityState.GetSourceAmmo().GetItemSoundRange();
            }
            else
            {
                SoundRange = WeaponState.GetItemSoundRange();
            }

			if( SoundRange > 0 )
			{
				// Modify sound range for this shot / grenade
				//SoundRange += SoundModifierMin + `SYNC_FRAND() * (SoundModifierMax - SoundModifierMin);

				if( !WeaponState.SoundOriginatesFromOwnerLocation() && ActivatedAbilityStateContext.InputContext.TargetLocations.Length > 0 )
				{
					SoundLocation = ActivatedAbilityStateContext.InputContext.TargetLocations[0];
					SoundTileLocation = `XWORLD.GetTileCoordinatesFromPosition(SoundLocation);
				}
				else
				{
					ThisUnitState.GetKeystoneVisibilityLocation(SoundTileLocation);
				}

				// LWS added: Gather the units in sound range of this weapon.
				class'HelpersYellowAlert'.static.GetAlienUnitsInRange(SoundTileLocation, SoundRange, Enemies);

				`Log("Yellow Alert Weapon sound @ Tile("$SoundTileLocation.X$","@SoundTileLocation.Y$","@SoundTileLocation.Z$") - Found"@Enemies.Length@"enemies in range ("$SoundRange$" meters)");
				foreach Enemies(EnemyRef)
				{
					EnemyInSoundRangeUnitState = XComGameState_Unit(History.GetGameStateForObjectID(EnemyRef.ObjectID));

					// if not targeted, provide sound information
					if( EnemyInSoundRangeUnitState.ObjectID != ActivatedAbilityStateContext.InputContext.PrimaryTarget.ObjectID )
					{
						// this unit just overheard the sound
						ThisUnitState.UnitAGainsKnowledgeOfUnitB(EnemyInSoundRangeUnitState, SourceUnitState, GameState, eAC_DetectedSound, false);
					}
				}
			}
		}
	}

	return ELR_NoInterrupt;
}

// Check incoming red and yellow alerts for AI to AI damage outside of Xcom's vision
function EventListenerReturn OnAlertDataTriggerAlertAbility(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_Unit AlertedUnit, DamagingUnit;
	local XComGameState_AIGroup AIGroupState;
	local XComGameState_AIUnitData AIGameState;
	local int AIUnitDataID, AlertDataIndex, DamagingUnitID, DamagingUnitGroupID;
	local EAlertCause AlertCause;
	local XComGameStateHistory History;
	local ETeam DamagingUnitTeam, AlertedUnitTeam;

	if(!EnableAItoAIActivation)//check config if activation is true then continue
		{
		return ELR_NoInterrupt; 
		}
	History = `XCOMHISTORY;

	AlertedUnit = XComGameState_Unit(EventSource);
	AlertedUnitTeam = AlertedUnit.GetTeam();
	
	if( AlertedUnit.IsAlive() )
	{
		AIUnitDataID = AlertedUnit.GetAIUnitDataID();
		if( AIUnitDataID == INDEX_NONE )
		{
			return ELR_NoInterrupt; // This may be a mind-controlled soldier. If so, we don't need to update their alert data.
		}
		AIGameState = XComGameState_AIUnitData(GameState.GetGameStateForObjectID(AIUnitDataID));
		`assert(AIGameState != none);

		AlertCause = eAC_None;

		if( AIGameState.RedAlertCause == eAC_TakingFire || AIGameState.RedAlertCause == eAC_TookDamage ||
			(class'HelpersYellowAlert'.static.AISeesAIEnabled() && AIGameState.RedAlertCause == eAC_SeesSpottedUnit) )//optional config for SeesSpottedUnit AI red alerts
		{
			AlertCause = AIGameState.RedAlertCause;
			`Log("Yellow Alert Gameplay: detected Red Alert caused by "@AlertCause@" to unit #"@AlertedUnit.ObjectID);
		}
		else
		{
			return ELR_NoInterrupt; //if red alert cause is None then return
		}

		AIGroupState = AlertedUnit.GetGroupMembership();
		if(AIGroupState != None && !AIGroupState.bProcessedScamper && AlertedUnit.bTriggerRevealAI) //if valid group has not processed scamper and unit is able to scamper continue
		{
			if( AIUnitDataID > 0 )
			{
				// figure out what unit caused this red alert
				for (AlertDataIndex = AIGameState.GetAlertCount()-1; AlertDataIndex >= 0; AlertDataIndex--) //start with newest alert first
				{
					if (AIGameState.GetAlertData(AlertDataIndex).AlertCause == AlertCause )//match alert history with the red alert cause
					{
						DamagingUnitID = AIGameState.GetAlertData(AlertDataIndex).AlertSourceUnitID;
						DamagingUnit = XComGameState_Unit(History.GetGameStateForObjectID(DamagingUnitID));
						DamagingUnitTeam = DamagingUnit.GetTeam();
						DamagingUnitGroupID = DamagingUnit.GetGroupMembership().ObjectID;
						`Log("Yellow Alert Gameplay: found AI to AI "@AlertCause@" Alert from team: "@DamagingUnitTeam@", unit #"@DamagingUnitID@" to team: "@AlertedUnitTeam@", unit #"@AlertedUnit.ObjectID);
						if(DamagingUnitTeam != eTeam_XCom) //only processing ai to ai damages here
						{  
							`Log("Yellow Alert Gameplay: Activating Ai group on team "@AlertedUnitTeam@", group #"@AIGroupState.ObjectID@" caused by AI team "@DamagingUnitTeam@", group #"@DamagingUnitGroupID);
							AIGroupState.InitiateReflexMoveActivate(DamagingUnit, AIGameState.GetAlertData(AlertDataIndex).AlertCause);
						}
						break; //source unit found, end loop
					}
				}
			}
			
		}
	}

	return ELR_NoInterrupt;
}

// A RNF pod has spawned. Mark the units with a special marker to indicate they shouldn't be eligible for
// reflex actions this turn.
function EventListenerReturn OnSpawnReinforcementsComplete(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_Unit Unit;
	local XComGameState NewGameState;
	local XComGameState_AIReinforcementSpawner Spawner;
	local int i;
	
	if(!AllowBonusReflexActions)
	{
		 return ELR_NoInterrupt;
	}

	Spawner = XComGameState_AIReinforcementSpawner(EventSource);
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Prevent RNF units from getting yellow action refund");
	for (i = 0; i < Spawner.SpawnedUnitIDs.Length; ++i)
	{
		Unit = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', Spawner.SpawnedUnitIDs[i]));
		NewGameState.AddStateObject(Unit);
		Unit.SetUnitFloatValue(NoReflexActionUnitValue, 1, eCleanup_BeginTurn);
	}

	`TACTICALRULES.SubmitGameState(NewGameState);

	return ELR_NoInterrupt;
}

function EventListenerReturn RefundActionPoint(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_AIGroup GroupState;
	local array<int> LivingMembers;
	local XComGameState_Unit LeaderState, Member, PreviousUnit;
	local XGAIPlayer AIPlayer;
	local XComGameState_AIPlayerData AIData;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameStateHistory History;
	local TTile TurnStartLocation, CurrentLocation;
	local int j, DistanceMoved;
	local bool IsYellow;
    local float Chance, Roll;
	local UnitValue Value;
	local XComGameState_Player PlayerState;

		// Note: We don't currently support reflex actions on XCOM's turn. Doing so requires
	// adjustments to how scampers are processed so the units would use their extra action
	// point. Also note that giving units a reflex action point while it's not their turn
	// can break stun animations unless those action points are used: see X2Effect_Stunned
	// where action points are only removed if it's the units turn, and the effect actions
	// (including the stunned idle anim override) are only visualized if the unit has no
	// action points left. If the unit has stray reflex actions they haven't used they
	// will stand back up and perform the normal idle animation (although they are still
	// stunned and won't act).
	if(!AllowBonusReflexActions)
	{
		 return ELR_NoInterrupt;
	}

	GroupState = XComGameState_AIGroup(EventSource);
	History = `XCOMHISTORY;
	GroupState.GetLivingMembers(LivingMembers);
	LeaderState = XComGameState_Unit(History.GetGameStateForObjectID(LivingMembers[0]));
	`Log(GetFuncName() $ ": Processing reflex move for Leader " $ LeaderState.GetMyTemplateName());
	PlayerState = XComGameState_Player(History.GetGameStateForObjectID(LeaderState.ControllingPlayer.ObjectID));
	
	if (DisableFirstTurn && PlayerState.PlayerTurnCount == 0)
	{
		`Log(GetFuncName() $ ": First turn reflex reactions are disabled: aborting");
		return ELR_NoInterrupt;
	}

    if (LeaderState.ControllingPlayer != `TACTICALRULES.GetCachedUnitActionPlayerRef())
    {
        `Log(GetFuncName() $ ": Not the alien turn: aborting");
        return ELR_NoInterrupt;
    }

    if (GroupState == none)
    {
        `Log(GetFuncName() $ ": Can't find group: aborting");
        return ELR_NoInterrupt;
    }

    if (LeaderState.GetCurrentStat(eStat_AlertLevel) <= 1)
	{
		// This unit isn't in red alert. If a scampering unit is not in red, this generally means they're a reinforcement
		// pod. Skip them.
		`Log(GetFuncName() $ ": Reinforcement unit: aborting");
		return ELR_NoInterrupt;
	}

	// Look for the special 'NoReflexAction' unit value. If present, this unit isn't allowed to take an action.
	// This is typically set on reinforcements on the turn they spawn. But if they spawn out of LoS they are
	// eligible, just like any other yellow unit, on subsequent turns. Both this check and the one above are needed.
	LeaderState.GetUnitValue(NoReflexActionUnitValue, Value);
 	if (Value.fValue == 1)
	{
		if(class'RapidReinforcements_AISpawner'.default.bRapidReinforcements)
		{
			for (j = 0; j < LivingMembers.Length; ++j)
			{
			Member = XComGameState_Unit(History.GetGameStateForObjectID(LivingMembers[j]));
			Member.ActionPoints.RemoveItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);
			`Log(GetFuncName() $ ": Rapid reinforcements is active, Remove scamper action point for unit"$ Member.GetMyTemplateName());
			}
		}
		else
		{
		`Log(GetFuncName() $ ": Unit with no reflex action value: aborting");
		}
		return ELR_NoInterrupt;
	}

	// Walk backwards through history for this unit until we find a state in which this unit wasn't in red
	// alert to see if we entered from yellow or from green.
	PreviousUnit = LeaderState;

	while (PreviousUnit != none && PreviousUnit.GetCurrentStat(eStat_AlertLevel) > 1)
	{
		PreviousUnit = XComGameState_Unit(History.GetPreviousGameStateForObject(PreviousUnit));
	}

    IsYellow = PreviousUnit != none && PreviousUnit.GetCurrentStat(eStat_AlertLevel) == 1;

    // Did our current pod change? If so reset the number of successful reflex actions we've had so far.
    if (GroupState.ObjectID != LastReflexGroupID)
    {
        NumSuccessfulReflexActions = 0;
        LastReflexGroupId = GroupState.ObjectID;
    }

	AIPlayer = XGAIPlayer(XGBattle_SP(`BATTLE).GetAIPlayer());
	AIData = XComGameState_AIPlayerData(`XCOMHISTORY.GetGameStateForObjectID(AIPlayer.GetAIDataID()));
	
	//Yellow alert units only go through this next check, green alerts always get the chance to be rewarded an extra action point
	// Walk backwards through history for the leader in this group to find a standard movement action taken by this unit since last turn
	//if they didn't take a full movement then they will have a chance to get an extra action point, unless of course they are reinforcement units
		
	if(IsYellow)
	{
		foreach History.IterateContextsByClassType( class'XComGameStateContext_Ability', AbilityContext, , true, AIData.m_iLastEndTurnHistoryIndex)
		{
			if( AbilityContext.InputContext.AbilityTemplateName == 'StandardMove' && AbilityContext.InputContext.SourceObject.ObjectID == LeaderState.ObjectID)
			{
				//measure the distance moved this turn to see how far they moved
				//1-6 tiles = one move and 7+ = full move
				//One move will have the chance to get back an action point upon scamper
				TurnStartLocation = LeaderState.TurnStartLocation;
				CurrentLocation = LeaderState.TileLocation;
				DistanceMoved = class'Helpers'.static.DistanceBetweenTiles(TurnStartLocation, CurrentLocation, false) / 96;
				`Log(GetFuncName() $ ": Found a Move this turn for Unit#"@LeaderState.ObjectID@", distance moved: " @DistanceMoved@ " tiles.");
				if(DistanceMoved > 6.5)
				{
					`Log(GetFuncName() $ ": Unit has already used all of it's action points this turn: aborting");
					return ELR_NoInterrupt;
				}
				break;
			}
		}
	}

	for (j = 0; j < LivingMembers.Length; ++j)
	{
		Member = XComGameState_Unit(History.GetGameStateForObjectID(LivingMembers[j]));

		if (Member.IsInjured() || !IsYellow)
		{
			Chance = REFLEX_ACTION_CHANCE_GREEN;
		}
		else 
		{
			Chance = REFLEX_ACTION_CHANCE_YELLOW;
		}

		if (REFLEX_ACTION_CHANCE_REDUCTION > 0 && NumSuccessfulReflexActions > 0)
		{
			`Log(GetFuncName() $ ": Reducing reflex chance due to " $ NumSuccessfulReflexActions $ " successes");
			Chance -= NumSuccessfulReflexActions * REFLEX_ACTION_CHANCE_REDUCTION;
		}
		Roll = `SYNC_FRAND();
		`Log(GetFuncName() $ ": Roll = " @ Roll @ " and chance = " @ Chance );
		if (Roll < Chance)
		{
			`Log(GetFuncName() $ ": Awarding an extra action point to unit"$ Member.GetMyTemplateName());
			// Award the unit a special kind of action point. These are more restricted than standard action points.
			// See the 'OffensiveReflexAbilities' and 'DefensiveReflexAbilities' arrays in LW_Overhaul.ini for the list
			// of abilities that have been modified to allow these action points.
			//
			// Damaged units, and units in green (if enabled) get 'defensive' action points. Others get 'offensive' action points.

			if (Member.IsInjured() || !IsYellow)
			{
				//For now just adding a standard action point until I can figure out how to get the enemy to use the DefensiveReflexActions configured in the .ini
				Member.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);
				//Member.ActionPoints.AddItem(DefensiveReflexAction); //Refund the AI one action point to use after scamper.
			}
			else
			{
				Member.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);  //Refund the AI one action point to use after scamper.
				//Member.ActionPoints.AddItem(DefensiveReflexAction); //Refund the AI one action point to use after scamper.
			}

			++NumSuccessfulReflexActions;
		}
	}
	return ELR_NoInterrupt;
}