class OldAimRoll extends X2AbilityToHitCalc_StandardAim config(AimRoll);

struct SquadsightModifier
{
	var name EffectName;
	var float PenaltyModifier;
	var bool IsTargetEffect;
};

struct HeightAdvantageModifier
{
	var int ZDiff;
	var float OffenseBonus;
	var float DefenseBonus;
};

var config float SQUADSIGHT_PENALTY_FLOAT;
var config int SQUADSIGHT_PENALTY_MAX;
var array<SquadsightModifier> SQUADSIGHT_MODIFIERS;

var config array<HeightAdvantageModifier> HEIGHT_MODIFIER;

var config bool ENABLE_EU_AIM_ROLLS;
var config bool PRIORITIZE_CRITS_OVER_DODGE;
var config bool HYBRID_CRIT_DODGE;

var config bool OVERWATCH_BYPASS_COVER;
var config array<name> OVERWATCH_ABILITIES;
var config array<name> MOVEMENT_ABILITY;
var config array<name> OPPORTUNIST_EFFECTS;

var config bool CONCEAL_REACTION_CRIT;

var config bool SHOW_CHANCES;
var config bool SHOW_CRIT_AND_DODGE;
var config bool SHOW_ROLLS;
var config bool DIRTY_CINEMATIC;
var config bool SHOW_ONLY_ALLIES;

var config bool UNACTIVATED_CANT_DODGE;
var config bool ONEHUNDREDPERCENT_CANCELSDODGE;

var config bool INDIRECT_FIRE_GUARANTEEHITS;
var config bool GUARANTEEHITS_CANT_DODGE;

var config bool ENABLE_GAMBLER_ROLL;

function InternalRollForAbilityHit(XComGameState_Ability kAbility, AvailableTarget kTarget, bool bIsPrimaryTarget, const out AbilityResultContext ResultContext, out EAbilityHitResult Result, out ArmorMitigationResults ArmorMitigated, out int HitChance)
{
	StaticInternalRollForAbilityHit(self, kAbility, kTarget, bIsPrimaryTarget, ResultContext, Result, ArmorMitigated, HitChance);
	// If EU aim rolls are disabled, roll everything again with old system
	// if (!default.ENABLE_EU_AIM_ROLLS)
	//	super.InternalRollForAbilityHit(kAbility, kTarget, ResultContext, Result, ArmorMitigated, HitChance);
}

static function NotifyEventList(XComGameState_Ability kAbility, AvailableTarget kTarget, array<String> message, optional bool IsXCOM=true)
{
	local HitChanceNotify Notification;
	Notification = new class'HitChanceNotify';
	Notification.StateRef = kAbility.ObjectID;
	Notification.Message = message;
	Notification.IsAlly = IsXCOM;
	Notification.RollTarget = kTarget.PrimaryTarget.ObjectID;
	`XEVENTMGR.TriggerEvent('RequestNotifyOnVisualization', Notification);
}

static function int SyncRandRoll(X2AbilityToHitCalc_StandardAim Aim, int x)
{
	return class'Engine'.static.GetEngine().SyncRand(x, string(Aim.Name)@string(Aim.GetStateName())@string(Aim.GetFuncName()));
}

static function StaticInternalRollForAbilityHit(X2AbilityToHitCalc_StandardAim Aim, XComGameState_Ability kAbility, AvailableTarget kTarget, bool bIsPrimaryTarget, const out AbilityResultContext ResultContext, out EAbilityHitResult Result, out ArmorMitigationResults ArmorMitigated, out int HitChance)
{
	local int i, Current, RandRoll, OriginalHitRoll, ModifiedHitChance;
	local float DodgeChance;
	local EAbilityHitResult DebugResult, ChangeResult;
	local ArmorMitigationResults Armor;
	local XComGameState_Unit TargetState, UnitState;
	local XComGameState_Player PlayerState;
	local XComGameStateHistory History;
	local StateObjectReference EffectRef;
	local XComGameState_Effect EffectState;
	local String AbilityName, TargetName;
	local bool bRolledResultIsAMiss, bModHitRoll;
	local bool HitsAreCrits;
	local bool IsAlien;
	local string LogMsg;
	local array<string> PINotify;
	local ETeam CurrentPlayerTeam;
	local ShotBreakdown m_ShotBreakdown;

	local int RealHitChance, TotalHitChance;
	
	local string DebugRollOutput;

	History = `XCOMHISTORY;

	`log("===" $ GetFuncName() $ "===", true, 'XCom_HitRolls');
	`log("Attacker ID:" @ kAbility.OwnerStateObject.ObjectID, true, 'XCom_HitRolls');
	`log("Target ID:" @ kTarget.PrimaryTarget.ObjectID, true, 'XCom_HitRolls');
	`log("Ability:" @ kAbility.GetMyTemplate().LocFriendlyName @ "(" $ kAbility.GetMyTemplateName() $ ")", true, 'XCom_HitRolls');

	ArmorMitigated = Armor;     //  clear out fields just in case
	HitsAreCrits = Aim.bHitsAreCrits;
	if (`CHEATMGR != none)
	{
		if (`CHEATMGR.bForceCritHits)
			HitsAreCrits = true;

		if (`CHEATMGR.bNoLuck)
		{
			`log("NoLuck cheat forcing a miss.", true, 'XCom_HitRolls');
			Result = eHit_Miss;			
			return;
		}
		if (`CHEATMGR.bDeadEye)
		{
			`log("DeadEye cheat forcing a hit.", true, 'XCom_HitRolls');
			Result = eHit_Success;
			if (HitsAreCrits)
				Result = eHit_Crit;
			return;
		}
	}

	HitChance = Aim.GetHitChance(kAbility, kTarget, m_ShotBreakdown, true);
	Result = eHit_Miss;

	`log("=" $ GetFuncName() $ "=", true, 'XCom_HitRolls');
	`log("Final hit chance:" @ HitChance, true, 'XCom_HitRolls');

	UnitState = XComGameState_Unit(History.GetGameStateForObjectID(kAbility.OwnerStateObject.ObjectID));
	TargetState = XComGameState_Unit(History.GetGameStateForObjectID(kTarget.PrimaryTarget.ObjectID));
	IsAlien = UnitState.GetTeam() != eTeam_XCom;
	// Revert real hit chance manipulated by FinalizeHitChance()
	RealHitChance = Clamp(HitChance, 0, 100);
	// Roll for hit
	if (default.ENABLE_GAMBLER_ROLL)
	{
		RandRoll = class'XComGameState_GamblerRolls'.static.StaticRoll(RealHitChance, false, false, IsAlien);
	}
	else
	{
		RandRoll = SyncRandRoll(Aim, 100);
	}
	OriginalHitRoll = RandRoll;
	DebugResult = EAbilityHitResult(eHit_Success);
	`log("Checking table" @ DebugResult @ "(" $ RealHitChance $ ")...", true, 'XCom_HitRolls');
	`log("Random roll:" @ RandRoll, true, 'XCom_HitRolls');
	DebugRollOutput = "Hit roll:"@RandRoll;
	if (default.ENABLE_EU_AIM_ROLLS)
	{
		TotalHitChance = RealHitChance;
		// EU aim rolls
		if (RandRoll < RealHitChance)
		{
			Result = eHit_Success;
			`log("MATCH!", true, 'XCom_HitRolls');
			// Hits, now roll for crits (Super priority)
			if (default.PRIORITIZE_CRITS_OVER_DODGE) 
			{		
				if (default.ENABLE_GAMBLER_ROLL)
				{
					RandRoll = class'XComGameState_GamblerRolls'.static.StaticRoll(m_ShotBreakdown.ResultTable[eHit_Crit], true, false, IsAlien);
				}
				else
				{
					RandRoll = SyncRandRoll(Aim, 100);
				}
				DebugResult = EAbilityHitResult(eHit_Crit);
				if (default.SHOW_CRIT_AND_DODGE)
				{
					DebugRollOutput = DebugRollOutput@", Crit roll:"@RandRoll;
				}
				`log("Checking table" @ DebugResult @ "(" $ m_ShotBreakdown.ResultTable[eHit_Crit] $ ")...", true, 'XCom_HitRolls');
				`log("Random roll:" @ RandRoll, true, 'XCom_HitRolls');
				if (RandRoll < m_ShotBreakdown.ResultTable[eHit_Crit]) 
				{
					Result = eHit_Crit;
					`log("MATCH!", true, 'XCom_HitRolls');
					if (default.HYBRID_CRIT_DODGE && m_ShotBreakdown.ResultTable[eHit_Graze] > 0)
					{				
						if (default.ENABLE_GAMBLER_ROLL)
						{
							RandRoll = class'XComGameState_GamblerRolls'.static.StaticRoll(m_ShotBreakdown.ResultTable[eHit_Graze] * 100 / RealHitChance, false, true, IsAlien) * 100 / RealHitChance;
						}
						else
						{
							RandRoll = SyncRandRoll(Aim, RealHitChance);
						}
						DebugResult = EAbilityHitResult(eHit_Graze);
						if (default.SHOW_CRIT_AND_DODGE && m_ShotBreakdown.ResultTable[eHit_Graze] > 0)
						{
							DebugRollOutput = DebugRollOutput@", Dodge roll:"@RandRoll;
						}
						`log("Checking table" @ DebugResult @ "(" $ m_ShotBreakdown.ResultTable[eHit_Graze] $ ")...", true, 'XCom_HitRolls');
						`log("Random roll over hit chance:" @ RandRoll, true, 'XCom_HitRolls');
						// Roll dodge over hit chance (Because of a function earlier multiplied dodge chance by actual hit chance)
						if (RandRoll < m_ShotBreakdown.ResultTable[eHit_Graze]) 
						{
							Result = eHit_Success; // Dodge cancels crit and becomes a standard hit.
							`log("MATCH!", true, 'XCom_HitRolls');
						}
					}
				}
				else if (m_ShotBreakdown.ResultTable[eHit_Graze] > 0)
				{		
					if (default.ENABLE_GAMBLER_ROLL)
					{
						RandRoll = class'XComGameState_GamblerRolls'.static.StaticRoll(m_ShotBreakdown.ResultTable[eHit_Graze] * 100 / RealHitChance, false, true, IsAlien) * 100 / RealHitChance;
					}
					else
					{
						RandRoll = SyncRandRoll(Aim, RealHitChance);
					}
					DebugResult = EAbilityHitResult(eHit_Graze);
					if (default.SHOW_CRIT_AND_DODGE && m_ShotBreakdown.ResultTable[eHit_Graze] > 0)
					{
						DebugRollOutput = DebugRollOutput@", Dodge roll:"@RandRoll;
					}
					`log("Checking table" @ DebugResult @ "(" $ m_ShotBreakdown.ResultTable[eHit_Graze] $ ")...", true, 'XCom_HitRolls');
					`log("Random roll over hit chance:" @ RandRoll, true, 'XCom_HitRolls');
					// Roll dodge over hit chance (Because of a function earlier multiplied dodge chance by actual hit chance)
					if (RandRoll < m_ShotBreakdown.ResultTable[eHit_Graze]) 
					{
						Result = eHit_Graze;
						`log("MATCH!", true, 'XCom_HitRolls');
					}
				}
			}
			else
			{				
				if (default.ENABLE_GAMBLER_ROLL && m_ShotBreakdown.ResultTable[eHit_Graze] > 0)
				{
					RandRoll = class'XComGameState_GamblerRolls'.static.StaticRoll(m_ShotBreakdown.ResultTable[eHit_Graze] * 100 / RealHitChance, false, true, IsAlien) * 100 / RealHitChance;
				}
				else
				{
					RandRoll = SyncRandRoll(Aim, RealHitChance);
				}
				DebugResult = EAbilityHitResult(eHit_Graze);
				if (default.SHOW_CRIT_AND_DODGE && m_ShotBreakdown.ResultTable[eHit_Graze] > 0)
				{
					DebugRollOutput = DebugRollOutput@", Dodge roll:"@RandRoll;
				}
				`log("Checking table" @ DebugResult @ "(" $ m_ShotBreakdown.ResultTable[eHit_Graze] $ ")...", true, 'XCom_HitRolls');
				`log("Random roll over hit chance:" @ RandRoll, true, 'XCom_HitRolls');
				// Roll dodge over hit chance (Because of a function earlier multiplied dodge chance by actual hit chance)
				if (RandRoll < m_ShotBreakdown.ResultTable[eHit_Graze]) 
				{
					Result = eHit_Graze;
					`log("MATCH!", true, 'XCom_HitRolls');
					if (default.HYBRID_CRIT_DODGE)
					{	
						if (default.ENABLE_GAMBLER_ROLL)
						{
							RandRoll = class'XComGameState_GamblerRolls'.static.StaticRoll(m_ShotBreakdown.ResultTable[eHit_Crit], true, false, IsAlien);
						}
						else
						{
							RandRoll = SyncRandRoll(Aim, 100);
						}
						DebugResult = EAbilityHitResult(eHit_Crit);
						if (default.SHOW_CRIT_AND_DODGE)
						{
							DebugRollOutput = DebugRollOutput@", Crit roll:"@RandRoll;
						}
						`log("Checking table" @ DebugResult @ "(" $ m_ShotBreakdown.ResultTable[eHit_Crit] $ ")...", true, 'XCom_HitRolls');
						`log("Random roll:" @ RandRoll, true, 'XCom_HitRolls');
						if (RandRoll < m_ShotBreakdown.ResultTable[eHit_Crit]) 
						{
							Result = eHit_Success; // Crit cancels dodge and becomes a standard hit.
							`log("MATCH!", true, 'XCom_HitRolls');
						}
					}

				}
				else
				{		
					if (default.ENABLE_GAMBLER_ROLL)
					{
						RandRoll = class'XComGameState_GamblerRolls'.static.StaticRoll(m_ShotBreakdown.ResultTable[eHit_Crit], true, false, IsAlien);
					}
					else
					{
						RandRoll = SyncRandRoll(Aim, 100);
					}
					DebugResult = EAbilityHitResult(eHit_Crit);
					if (default.SHOW_CRIT_AND_DODGE)
					{
						DebugRollOutput = DebugRollOutput@", Crit roll:"@RandRoll;
					}
					`log("Checking table" @ DebugResult @ "(" $ m_ShotBreakdown.ResultTable[eHit_Crit] $ ")...", true, 'XCom_HitRolls');
					`log("Random roll:" @ RandRoll, true, 'XCom_HitRolls');
					if (RandRoll < m_ShotBreakdown.ResultTable[eHit_Crit]) 
					{
						Result = eHit_Crit;
						`log("MATCH!", true, 'XCom_HitRolls');
					}
				}
			}
		}
	}
	else
	{
		TotalHitChance = m_ShotBreakdown.ResultTable[eHit_Success] + m_ShotBreakdown.ResultTable[eHit_Crit] + m_ShotBreakdown.ResultTable[eHit_Graze];
		TotalHitChance = Clamp(TotalHitChance, 0, 100);
		// Vanilla aim rolls
		Result = eHit_Miss;

		`log("Random roll:" @ RandRoll, true, 'XCom_HitRolls');
		//  GetHitChance fills out m_ShotBreakdown and its ResultTable
		for (i = 0; i < eHit_Miss; ++i)     //  If we don't match a result before miss, then it's a miss.
		{
			Current += m_ShotBreakdown.ResultTable[i];
			DebugResult = EAbilityHitResult(i);
			`log("Checking table" @ DebugResult @ "(" $ Current $ ")...", true, 'XCom_HitRolls');
			if (RandRoll < Current)
			{
				Result = EAbilityHitResult(i);
				`log("MATCH!", true, 'XCom_HitRolls');
				break;
			}
		}
	}

	if (HitsAreCrits && Result == eHit_Success)
		Result = eHit_Crit;

	if (default.GUARANTEEHITS_CANT_DODGE && (Aim.bIndirectFire || Aim.bGuaranteedHit || TargetState == none)) // No target states are supposed to be guarantee hits
	{
		if (Result == eHit_Graze)
			Result = eHit_Success;
	}
	if (default.INDIRECT_FIRE_GUARANTEEHITS && Aim.bIndirectFire)
	{
		if (Result == eHit_Miss) // Countering the unintended effect of graze band for LW2
			Result = eHit_Success;
	}

	if (default.SHOW_CHANCES && !Aim.bIndirectFire && !Aim.bGuaranteedHit && TargetState != none)
	{
		TargetName = TargetState.GetFullName();
		AbilityName = kAbility.GetMyFriendlyName();
		if (AbilityName == "")
		{
			AbilityName = string(kAbility.GetMyTemplateName());
		}
		if (default.ENABLE_EU_AIM_ROLLS)
		{
			DodgeChance = (m_ShotBreakdown.ResultTable[eHit_Graze] * 100.00) / RealHitChance;
			DodgeChance = Clamp(DodgeChance, 0, 100);
			PINotify.AddItem(UnitState.GetFullName()@"uses"@AbilityName@"against"@TargetName@"for"@RealHitChance$"%." 
				@ default.SHOW_CRIT_AND_DODGE ? "Crit:" @ m_ShotBreakdown.ResultTable[eHit_Crit] $ "%, Dodge:"
				@ Round(DodgeChance) $ "%" : "");
		}
		else
		{
			PINotify.AddItem(UnitState.GetFullName()@"uses"@AbilityName@"against"@TargetName@"for"
				@ RealHitChance$"%." $ (RealHitChance != TotalHitChance ? "(" $ TotalHitChance $ "%)"  : "")
				@ default.SHOW_CRIT_AND_DODGE ? "Crit:" @ m_ShotBreakdown.ResultTable[eHit_Crit] $ "%, Dodge:"
				@ m_ShotBreakdown.ResultTable[eHit_Graze] $ "% Roll thresold:"
				@ m_ShotBreakdown.ResultTable[eHit_Success] $ "/" 
				$ m_ShotBreakdown.ResultTable[eHit_Success] + m_ShotBreakdown.ResultTable[eHit_Crit] $ "/" 
				$ TotalHitChance : "");
		}
		if (default.SHOW_ROLLS)
		{
			PINotify.AddItem(DebugRollOutput);	
		}
	}
	
	if (UnitState != none && TargetState != none)
	{
		foreach UnitState.AffectedByEffects(EffectRef)
		{
			EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
			if (EffectState != none)
			{
				if (EffectState.GetX2Effect().ChangeHitResultForAttacker(UnitState, TargetState, kAbility, Result, ChangeResult))
				{
					`log("Effect" @ EffectState.GetX2Effect().FriendlyName @ "changing hit result for attacker:" @ ChangeResult,true,'XCom_HitRolls');
					Result = ChangeResult;
					if (default.SHOW_CHANCES && default.SHOW_ROLLS)
						PINotify.AddItem(UnitState.GetFullName()@"used an effect to change hit result to"@ ChangeResult);
				}
			}
		}
		foreach TargetState.AffectedByEffects(EffectRef)
		{
			EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
			if (EffectState != none)
			{
				if (EffectState.GetX2Effect().ChangeHitResultForTarget(EffectState, UnitState, TargetState, kAbility, bIsPrimaryTarget, Result, ChangeResult))
				{
					`log("Effect" @ EffectState.GetX2Effect().FriendlyName @ "changing hit result for target:" @ ChangeResult, true, 'XCom_HitRolls');
					Result = ChangeResult;
					if (default.SHOW_CHANCES && default.SHOW_ROLLS)
						PINotify.AddItem(TargetState.GetFullName()@"has an effect that changes hit result to"@ ChangeResult);
				}
			}
		}
	}
	
	// Aim Assist (miss streak prevention)
	bRolledResultIsAMiss = class'XComGameStateContext_Ability'.static.IsHitResultMiss(Result);
	
	if( UnitState != None && !Aim.bReactionFire &&
		!Aim.bGuaranteedHit &&
		m_ShotBreakdown.SpecialGuaranteedHit == '')           //  reaction fire shots do not get adjusted for difficulty
	{
		PlayerState = XComGameState_Player(History.GetGameStateForObjectID(UnitState.GetAssociatedPlayerID()));
		CurrentPlayerTeam = PlayerState.GetTeam();

		if( bRolledResultIsAMiss && CurrentPlayerTeam == eTeam_XCom )
		{
			ModifiedHitChance = Aim.GetModifiedHitChanceForCurrentDifficulty(PlayerState, TargetState, HitChance);
			
			if (default.SHOW_CHANCES && ModifiedHitChance != HitChance && !Aim.bIndirectFire && !Aim.bGuaranteedHit && TargetState != none)
			{
				PINotify.AddItem("Aim assist modified hit chance to"@ModifiedHitChance$"%, using previous hit roll.");
			}
			if( ModifiedHitChance != HitChance && OriginalHitRoll < ModifiedHitChance )
			{
				Result = eHit_Success;
				bModHitRoll = true;
				`log("*** AIM ASSIST forcing an XCom MISS to become a HIT!", true, 'XCom_HitRolls');
			}
		}
		else if( !bRolledResultIsAMiss && (CurrentPlayerTeam == eTeam_Alien || CurrentPlayerTeam == eTeam_TheLost) )
		{
			ModifiedHitChance = Aim.GetModifiedHitChanceForCurrentDifficulty(PlayerState, TargetState, HitChance);
			
			if (default.SHOW_CHANCES && ModifiedHitChance != HitChance && !Aim.bIndirectFire && !Aim.bGuaranteedHit && TargetState != none)
			{
				PINotify.AddItem("Aim assist modified hit chance to"@ModifiedHitChance$"%, using previous hit roll.");
			}
			if( ModifiedHitChance != HitChance && OriginalHitRoll >= ModifiedHitChance )
			{
				Result = eHit_Miss;
				bModHitRoll = true;
				`log("*** AIM ASSIST forcing an Alien HIT to become a MISS!", true, 'XCom_HitRolls');
			}
		}
	}

	NotifyEventList(kAbility, kTarget, PINotify, !IsAlien);

	`log("***HIT" @ Result, !bRolledResultIsAMiss, 'XCom_HitRolls');
	`log("***MISS" @ Result, bRolledResultIsAMiss, 'XCom_HitRolls');

	//  add armor mitigation (regardless of hit/miss as some shots deal damage on a miss)	
	if (TargetState != none)
	{
		//  Check for Lightning Reflexes
		if (Aim.bReactionFire && TargetState.bLightningReflexes && !bRolledResultIsAMiss)
		{
			Result = eHit_LightningReflexes;
			`log("Lightning Reflexes triggered! Shot will miss.", true, 'XCom_HitRolls');
		}

		class'X2AbilityArmorHitRolls'.static.RollArmorMitigation(m_ShotBreakdown.ArmorMitigation, ArmorMitigated, TargetState);
	}	

	if (UnitState != none && TargetState != none)
	{
		LogMsg = class'XLocalizedData'.default.StandardAimLogMsg;
		LogMsg = repl(LogMsg, "#Shooter", UnitState.GetName(eNameType_RankFull));
		LogMsg = repl(LogMsg, "#Target", TargetState.GetName(eNameType_RankFull));
		LogMsg = repl(LogMsg, "#Ability", kAbility.GetMyTemplate().LocFriendlyName);
		LogMsg = repl(LogMsg, "#Chance", bModHitRoll ? ModifiedHitChance : HitChance);
		LogMsg = repl(LogMsg, "#Roll", RandRoll);
		LogMsg = repl(LogMsg, "#Result", class'X2TacticalGameRulesetDataStructures'.default.m_aAbilityHitResultStrings[Result]);
		`COMBATLOG(LogMsg);
	}
}

protected function int GetHitChance(XComGameState_Ability kAbility, AvailableTarget kTarget, optional out ShotBreakdown m_ShotBreakdown, optional bool bDebugLog=false)
{
	local XComGameState_Unit UnitState, TargetState;
	local XComGameState_Item SourceWeapon;
	local GameRulesCache_VisibilityInfo VisInfo;
	local array<X2WeaponUpgradeTemplate> WeaponUpgrades;
	local int i, iWeaponMod, iRangeModifier, Tiles, FinalGraze;
	local ShotBreakdown EmptyShotBreakdown;
	local array<ShotModifierInfo> EffectModifiers;
	local StateObjectReference EffectRef;
	local XComGameState_Effect EffectState;
	local XComGameStateHistory History;
	local bool bFlanking, bIgnoreGraze, bSquadsight;
	local string IgnoreGrazeReason;
	local X2AbilityTemplate AbilityTemplate;
	local array<XComGameState_Effect> StatMods;
	local array<float> StatModValues;
	local X2Effect_Persistent PersistentEffect;
	local array<X2Effect_Persistent> UniqueToHitEffects;
	local float FinalAdjust, CoverValue, AngleToCoverModifier, Alpha, GrazeScale;
	local bool bShouldAddAngleToCoverBonus;
	local TTile UnitTileLocation, TargetTileLocation;
	local ECoverType NextTileOverCoverType;
	local int TileDistance;
	local ShotModifierInfo Mod;
	local UnitValue ConcealedValue;

	local XComGameState LastGameState;
	local bool isRunningOverwatch;
	local XComGameStateContext_Ability LastAbilityContext;

	local HeightAdvantageModifier HeightMod, SelectedHeightMod;
	local int MaxHeightDiff;

	local SquadsightModifier SquadSightMod;

	`log("=" $ GetFuncName() $ "=", bDebugLog, 'XCom_HitRolls');

	//  @TODO gameplay handle non-unit targets
	History = `XCOMHISTORY;
	UnitState = XComGameState_Unit(History.GetGameStateForObjectID( kAbility.OwnerStateObject.ObjectID ));
	TargetState = XComGameState_Unit(History.GetGameStateForObjectID( kTarget.PrimaryTarget.ObjectID ));
	if (kAbility != none)
	{
		AbilityTemplate = kAbility.GetMyTemplate();
		SourceWeapon = kAbility.GetSourceWeapon();			

		// Check if it's overwatch
		if (default.OVERWATCH_ABILITIES.Find(kAbility.GetMyTemplateName()) != INDEX_NONE)
		{
			// Check if target is moving
			// Is interrupt state, so using same game state
			LastGameState = History.GetGameStateFromHistory(History.GetCurrentHistoryIndex());
			LastAbilityContext = XComGameStateContext_Ability(LastGameState.GetContext());
			if (LastAbilityContext != none)
				if (default.MOVEMENT_ABILITY.Find(LastAbilityContext.InputContext.AbilityTemplateName) != INDEX_NONE)
					isRunningOverwatch = true;
		}
	}

	//  reset shot breakdown
	m_ShotBreakdown = EmptyShotBreakdown;

	//  check for a special guaranteed hit
	m_ShotBreakdown.SpecialGuaranteedHit = UnitState.CheckSpecialGuaranteedHit(kAbility, SourceWeapon, TargetState);
	m_ShotBreakdown.SpecialCritLabel = UnitState.CheckSpecialCritLabel(kAbility, SourceWeapon, TargetState);

	//  add all of the built-in modifiers
	if (bGuaranteedHit || m_ShotBreakdown.SpecialGuaranteedHit != '')
	{
		Mod.ModType = eHit_Success;
		Mod.Value = 100;
		Mod.Reason = AbilityTemplate.LocFriendlyName;
		m_ShotBreakdown.Modifiers.AddItem(Mod);
		m_ShotBreakdown.ResultTable[eHit_Success] += 100;
		m_ShotBreakdown.FinalHitChance = m_ShotBreakdown.ResultTable[eHit_Success];
		`log("+100% aim for guarantee hit", bDebugLog, 'XCom_HitRolls');

	}
	AddModifier(BuiltInHitMod, AbilityTemplate.LocFriendlyName, m_ShotBreakdown, eHit_Success);
	AddModifier(BuiltInCritMod, AbilityTemplate.LocFriendlyName, m_ShotBreakdown, eHit_Crit);

	if (bIndirectFire)
	{
		m_ShotBreakdown.HideShotBreakdown = true;
		AddModifier(100, AbilityTemplate.LocFriendlyName, m_ShotBreakdown, eHit_Success);
	}

	if (UnitState != none && TargetState == none)
	{
		// when targeting non-units, we have a 100% chance to hit. They can't dodge or otherwise
		// mess up our shots
		m_ShotBreakdown.HideShotBreakdown = true;
		AddModifier(100, class'XLocalizedData'.default.OffenseStat, m_ShotBreakdown);
	}
	else if (UnitState != none && TargetState != none)
	{				
		if (!bIndirectFire)
		{
			// StandardAim (with direct fire) will require visibility info between source and target (to check cover). 
			if (`TACTICALRULES.VisibilityMgr.GetVisibilityInfo(UnitState.ObjectID, TargetState.ObjectID, VisInfo))
			{	
				if (UnitState.CanFlank() && TargetState.GetMyTemplate().bCanTakeCover && VisInfo.TargetCover == CT_None)
					bFlanking = true;
				if (VisInfo.bClearLOS && !VisInfo.bVisibleGameplay)
					bSquadsight = true;

				//  Add basic offense and defense values
				AddModifier(UnitState.GetBaseStat(eStat_Offense), class'XLocalizedData'.default.OffenseStat, m_ShotBreakdown);			
				UnitState.GetStatModifiers(eStat_Offense, StatMods, StatModValues);
				for (i = 0; i < StatMods.Length; ++i)
				{
					AddModifier(int(StatModValues[i]), StatMods[i].GetX2Effect().FriendlyName, m_ShotBreakdown);
				}
				//  Flanking bonus (do not apply to overwatch shots)
				if (bFlanking && !bReactionFire && !bMeleeAttack)
				{
					AddModifier(UnitState.GetCurrentStat(eStat_FlankingAimBonus), class'XLocalizedData'.default.FlankingAimBonus, m_ShotBreakdown);
				}
				//  Squadsight penalty
				if (bSquadsight)
				{
					Tiles = UnitState.TileDistanceBetween(TargetState);
					//  remove number of tiles within visible range (which is in meters, so convert to units, and divide that by tile size)
					Tiles -= UnitState.GetVisibilityRadius() * class'XComWorldData'.const.WORLD_METERS_TO_UNITS_MULTIPLIER / class'XComWorldData'.const.WORLD_StepSize;
					if (Tiles > 0)      //  pretty much should be since a squadsight target is by definition beyond sight range. but... 
						AddModifier(max(default.SQUADSIGHT_PENALTY_FLOAT * Tiles, default.SQUADSIGHT_PENALTY_MAX), class'XLocalizedData'.default.SquadsightMod, m_ShotBreakdown);
				}

				//  Check for modifier from weapon 				
				if (SourceWeapon != none)
				{
					iWeaponMod = SourceWeapon.GetItemAimModifier();
					AddModifier(iWeaponMod, class'XLocalizedData'.default.WeaponAimBonus, m_ShotBreakdown);

					WeaponUpgrades = SourceWeapon.GetMyWeaponUpgradeTemplates();
					for (i = 0; i < WeaponUpgrades.Length; ++i)
					{
						if (WeaponUpgrades[i].AddHitChanceModifierFn != None)
						{
							if (WeaponUpgrades[i].AddHitChanceModifierFn(WeaponUpgrades[i], VisInfo, iWeaponMod))
							{
								AddModifier(iWeaponMod, WeaponUpgrades[i].GetItemFriendlyName(), m_ShotBreakdown);
							}
						}
					}
				}
				//  Target defense
				AddModifier(-TargetState.GetCurrentStat(eStat_Defense), class'XLocalizedData'.default.DefenseStat, m_ShotBreakdown);			
				
				//  Add weapon range
				if (SourceWeapon != none)
				{
					iRangeModifier = GetWeaponRangeModifier(UnitState, TargetState, SourceWeapon);
					AddModifier(iRangeModifier, class'XLocalizedData'.default.WeaponRange, m_ShotBreakdown);
				}			
				//  Cover modifiers
				if (bMeleeAttack)
				{
					AddModifier(MELEE_HIT_BONUS, class'XLocalizedData'.default.MeleeBonus, m_ShotBreakdown, eHit_Success);
				}
				else
				{
					//  Add cover penalties
					if (TargetState.CanTakeCover() && (!OVERWATCH_BYPASS_COVER || !isRunningOverwatch))
					{
						// if any cover is being taken, factor in the angle to attack
						if( VisInfo.TargetCover != CT_None && !bIgnoreCoverBonus )
						{
							switch( VisInfo.TargetCover )
							{
							case CT_MidLevel:           //  half cover
								AddModifier(-LOW_COVER_BONUS, class'XLocalizedData'.default.TargetLowCover, m_ShotBreakdown);
								CoverValue = LOW_COVER_BONUS;
								break;
							case CT_Standing:           //  full cover
								AddModifier(-HIGH_COVER_BONUS, class'XLocalizedData'.default.TargetHighCover, m_ShotBreakdown);
								CoverValue = HIGH_COVER_BONUS;
								break;
							}

							TileDistance = UnitState.TileDistanceBetween(TargetState);

							// from Angle 0 -> MIN_ANGLE_TO_COVER, receive full MAX_ANGLE_BONUS_MOD
							// As Angle increases from MIN_ANGLE_TO_COVER -> MAX_ANGLE_TO_COVER, reduce bonus received by lerping MAX_ANGLE_BONUS_MOD -> MIN_ANGLE_BONUS_MOD
							// Above MAX_ANGLE_TO_COVER, receive no bonus

							//`assert(VisInfo.TargetCoverAngle >= 0); // if the target has cover, the target cover angle should always be greater than 0
							if( VisInfo.TargetCoverAngle < MAX_ANGLE_TO_COVER && TileDistance <= MAX_TILE_DISTANCE_TO_COVER )
							{
								bShouldAddAngleToCoverBonus = (UnitState.GetTeam() == eTeam_XCom);

								// We have to avoid the weird visual situation of a unit standing behind low cover 
								// and that low cover extends at least 1 tile in the direction of the attacker.
								if( (SHOULD_DISABLE_BONUS_ON_ANGLE_TO_EXTENDED_LOW_COVER && VisInfo.TargetCover == CT_MidLevel) ||
									(SHOULD_ENABLE_PENALTY_ON_ANGLE_TO_EXTENDED_HIGH_COVER && VisInfo.TargetCover == CT_Standing) )
								{
									UnitState.GetKeystoneVisibilityLocation(UnitTileLocation);
									TargetState.GetKeystoneVisibilityLocation(TargetTileLocation);
									NextTileOverCoverType = NextTileOverCoverInSameDirection(UnitTileLocation, TargetTileLocation);

									if( SHOULD_DISABLE_BONUS_ON_ANGLE_TO_EXTENDED_LOW_COVER && VisInfo.TargetCover == CT_MidLevel && NextTileOverCoverType == CT_MidLevel )
									{
										bShouldAddAngleToCoverBonus = false;
									}
									else if( SHOULD_ENABLE_PENALTY_ON_ANGLE_TO_EXTENDED_HIGH_COVER && VisInfo.TargetCover == CT_Standing && NextTileOverCoverType == CT_Standing )
									{
										bShouldAddAngleToCoverBonus = false;

										Alpha = FClamp((VisInfo.TargetCoverAngle - MIN_ANGLE_TO_COVER) / (MAX_ANGLE_TO_COVER - MIN_ANGLE_TO_COVER), 0.0, 1.0);
										AngleToCoverModifier = Lerp(MAX_ANGLE_PENALTY,
											MIN_ANGLE_PENALTY,
											Alpha);
										AddModifier(Round(-1.0 * AngleToCoverModifier), class'XLocalizedData'.default.BadAngleToTargetCover, m_ShotBreakdown);
									}
								}

								if( bShouldAddAngleToCoverBonus )
								{
									Alpha = FClamp((VisInfo.TargetCoverAngle - MIN_ANGLE_TO_COVER) / (MAX_ANGLE_TO_COVER - MIN_ANGLE_TO_COVER), 0.0, 1.0);
									AngleToCoverModifier = Lerp(MAX_ANGLE_BONUS_MOD,
																MIN_ANGLE_BONUS_MOD,
																Alpha);
									AddModifier(Round(CoverValue * AngleToCoverModifier), class'XLocalizedData'.default.AngleToTargetCover, m_ShotBreakdown);
								}
							}
						}
					}
					//  Add height advantage
					if (UnitState.TileLocation.Z + UnitState.GetHeightAdvantageBonusZ() > TargetState.TileLocation.Z)
					{
						MaxHeightDiff = 0;
						foreach default.HEIGHT_MODIFIER(HeightMod)
						{
							if (UnitState.TileLocation.Z + UnitState.GetHeightAdvantageBonusZ() - TargetState.TileLocation.Z == HeightMod.ZDiff)
							{
								SelectedHeightMod = HeightMod;
								break;
							}
							if (UnitState.TileLocation.Z + UnitState.GetHeightAdvantageBonusZ() - TargetState.TileLocation.Z > HeightMod.ZDiff && HeightMod.ZDiff > MaxHeightDiff)
							{
								SelectedHeightMod = HeightMod;
								MaxHeightDiff = HeightMod.ZDiff;
							}
						}
						if (SelectedHeightMod.ZDiff > 0)
						{
							AddModifier(SelectedHeightMod.OffenseBonus, class'XLocalizedData'.default.HeightAdvantage, m_ShotBreakdown);
						}
					}

					//  Check for height disadvantage
					if (UnitState.TileLocation.Z < TargetState.TileLocation.Z)
					{
						MaxHeightDiff = 0;
						foreach default.HEIGHT_MODIFIER(HeightMod)
						{
							if (TargetState.TileLocation.Z - UnitState.TileLocation.Z == HeightMod.ZDiff)
							{
								SelectedHeightMod = HeightMod;
								break;
							}
							if (TargetState.TileLocation.Z - UnitState.TileLocation.Z > HeightMod.ZDiff && HeightMod.ZDiff > MaxHeightDiff)
							{
								SelectedHeightMod = HeightMod;
								MaxHeightDiff = HeightMod.ZDiff;
							}
						}
						if (SelectedHeightMod.ZDiff > 0)
						{
							AddModifier(SelectedHeightMod.DefenseBonus, class'XLocalizedData'.default.HeightDisadvantage, m_ShotBreakdown);
						}
					}
				}
			}

			if (UnitState.IsConcealed())
			{
				`log("Shooter is concealed, target cannot dodge.", bDebugLog, 'XCom_HitRolls');
			}
			else
			{
				if ((SourceWeapon == none || SourceWeapon.CanWeaponBeDodged()) && 
					(!default.UNACTIVATED_CANT_DODGE || TargetState.GetTeam() != eTeam_Alien || 
						XGUnit(TargetState.GetVisualizer()) == none || XGUnit(TargetState.GetVisualizer()).GetAlertLevel(TargetState) == eAL_Red))
					{
						if (TargetState.CanDodge(UnitState, kAbility))
						{
							AddModifier(TargetState.GetCurrentStat(eStat_Dodge), class'XLocalizedData'.default.DodgeStat, m_ShotBreakdown, eHit_Graze, bDebugLog);
						}
						else
						{
							`log("Target cannot dodge due to some gameplay effect.", bDebugLog, 'XCom_HitRolls');
						}
					}
			}
		}					

		//  Now check for critical chances.
		if (bAllowCrit)
		{
			AddModifier(UnitState.GetBaseStat(eStat_CritChance), class'XLocalizedData'.default.CharCritChance, m_ShotBreakdown, eHit_Crit);
			UnitState.GetStatModifiers(eStat_CritChance, StatMods, StatModValues);
			for (i = 0; i < StatMods.Length; ++i)
			{
				AddModifier(int(StatModValues[i]), StatMods[i].GetX2Effect().FriendlyName, m_ShotBreakdown, eHit_Crit);
			}
			if (bSquadsight)
			{
				AddModifier(default.SQUADSIGHT_CRIT_MOD, class'XLocalizedData'.default.SquadsightMod, m_ShotBreakdown, eHit_Crit);
			}

			if (SourceWeapon !=  none)
			{
				AddModifier(SourceWeapon.GetItemCritChance(), class'XLocalizedData'.default.WeaponCritBonus, m_ShotBreakdown, eHit_Crit);
			}
			if (bFlanking && !bMeleeAttack)
			{
				if (`XENGINE.IsMultiplayerGame())
				{
					AddModifier(default.MP_FLANKING_CRIT_BONUS, class'XLocalizedData'.default.FlankingCritBonus, m_ShotBreakdown, eHit_Crit);
				}				
				else
				{
					if ( `SecondWaveEnabled('AbsolutelyCritical') )
					{
						AddModifier(100, class'XLocalizedData'.default.FlankingCritBonus, m_ShotBreakdown, eHit_Crit);
					}
					else
					{
						AddModifier(UnitState.GetCurrentStat(eStat_FlankingCritChance), class'XLocalizedData'.default.FlankingCritBonus, m_ShotBreakdown, eHit_Crit);
					}
				}
			}
		}

		foreach UnitState.AffectedByEffects(EffectRef)
		{
			EffectModifiers.Length = 0;
			EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
			if (EffectState == none)
				continue;
			PersistentEffect = EffectState.GetX2Effect();
			if (PersistentEffect == none)
				continue;

			if (UniqueToHitEffects.Find(PersistentEffect) != INDEX_NONE)
				continue;

			PersistentEffect.GetToHitModifiers(EffectState, UnitState, TargetState, kAbility, self.Class, bMeleeAttack, bFlanking, bIndirectFire, EffectModifiers);
			if (EffectModifiers.Length > 0)
			{
				if (PersistentEffect.UniqueToHitModifiers())
					UniqueToHitEffects.AddItem(PersistentEffect);

				for (i = 0; i < EffectModifiers.Length; ++i)
				{
					if (!bAllowCrit && EffectModifiers[i].ModType == eHit_Crit)
					{
						if (!PersistentEffect.AllowCritOverride())
							continue;
					}
					AddModifier(EffectModifiers[i].Value, EffectModifiers[i].Reason, m_ShotBreakdown, EffectModifiers[i].ModType);
				}
			}
			if (PersistentEffect.ShotsCannotGraze())
			{
				bIgnoreGraze = true;
				IgnoreGrazeReason = PersistentEffect.FriendlyName;
			}
			foreach default.SQUADSIGHT_MODIFIERS(SquadSightMod)
			{
				if (bSquadsight && !SquadSightMod.IsTargetEffect && EffectState.GetX2Effect().EffectName == SquadSightMod.EffectName)
					AddModifier(SquadSightMod.PenaltyModifier * Tiles, EffectState.GetX2Effect().FriendlyName, m_ShotBreakdown);
			}
		}
		UniqueToHitEffects.Length = 0;
		if (TargetState.AffectedByEffects.Length > 0)
		{
			foreach TargetState.AffectedByEffects(EffectRef)
			{
				EffectModifiers.Length = 0;
				EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
				if (EffectState == none)
					continue;
				PersistentEffect = EffectState.GetX2Effect();
				if (PersistentEffect == none)
					continue;
				if (UniqueToHitEffects.Find(PersistentEffect) != INDEX_NONE)
					continue;

				PersistentEffect.GetToHitAsTargetModifiers(EffectState, UnitState, TargetState, kAbility, self.Class, bMeleeAttack, bFlanking, bIndirectFire, EffectModifiers);
				if (EffectModifiers.Length > 0)
				{
					if (PersistentEffect.UniqueToHitAsTargetModifiers())
						UniqueToHitEffects.AddItem(PersistentEffect);

					for (i = 0; i < EffectModifiers.Length; ++i)
					{
						if (!bAllowCrit && EffectModifiers[i].ModType == eHit_Crit)
							continue;
						AddModifier(EffectModifiers[i].Value, EffectModifiers[i].Reason, m_ShotBreakdown, EffectModifiers[i].ModType);
					}
				}
				foreach default.SQUADSIGHT_MODIFIERS(SquadSightMod)
				{
					if (bSquadsight && SquadSightMod.IsTargetEffect && EffectState.GetX2Effect().EffectName == SquadSightMod.EffectName)
						AddModifier(SquadSightMod.PenaltyModifier * Tiles, EffectState.GetX2Effect().FriendlyName, m_ShotBreakdown);
				}
			}
		}
		
		if (default.INDIRECT_FIRE_GUARANTEEHITS && bIndirectFire)
		{
			bIgnoreGraze = true;
			AddModifier(100 - m_ShotBreakdown.ResultTable[eHit_Success], AbilityTemplate.LocFriendlyName, m_ShotBreakdown, eHit_Success);
		}
		//  Remove graze if shooter ignores graze chance.
		if (bIgnoreGraze)
		{
			AddModifier(-m_ShotBreakdown.ResultTable[eHit_Graze], IgnoreGrazeReason, m_ShotBreakdown, eHit_Graze);
		}
		//  Remove crit from reaction fire. Must be done last to remove all crit.
		if (bReactionFire)
		{
			if (default.CONCEAL_REACTION_CRIT && UnitState.GetUnitValue(class'X2Ability_DefaultAbilitySet'.default.ConcealedOverwatchTurn, ConcealedValue))
			{
				if (ConcealedValue.fValue <= 0)
				{
					AddReactionCritModifier(UnitState, TargetState, m_ShotBreakdown, bDebugLog);
				}
			}
			else
			{
				AddReactionCritModifier(UnitState, TargetState, m_ShotBreakdown, bDebugLog);
			}
		}
	}

	//  Final multiplier based on end Success chance
	if (bReactionFire && !bGuaranteedHit)
	{
		FinalAdjust = m_ShotBreakdown.ResultTable[eHit_Success] * GetReactionAdjust(UnitState, TargetState);
		AddModifier(-int(FinalAdjust), AbilityTemplate.LocFriendlyName, m_ShotBreakdown);
		AddReactionFlatModifier(UnitState, TargetState, m_ShotBreakdown, bDebugLog);
	}
	else if (FinalMultiplier != 1.0f)
	{
		FinalAdjust = m_ShotBreakdown.ResultTable[eHit_Success] * FinalMultiplier;
		AddModifier(-int(FinalAdjust), AbilityTemplate.LocFriendlyName, m_ShotBreakdown);
	}
	GrazeScale = float(m_ShotBreakdown.ResultTable[eHit_Graze]) / 100.0f;
	FinalizeHitChance(m_ShotBreakdown);
	if (!ONEHUNDREDPERCENT_CANCELSDODGE && m_ShotBreakdown.FinalHitChance >= 100 && GrazeScale > 0)
	{
		GrazeScale *= float(m_ShotBreakdown.FinalHitChance);
		FinalGraze = Round(GrazeScale);
		m_ShotBreakdown.ResultTable[eHit_Success] -= FinalGraze;
		m_ShotBreakdown.ResultTable[eHit_Graze] = FinalGraze;
	}
	return m_ShotBreakdown.FinalHitChance;
}

function float GetReactionAdjust(XComGameState_Unit Shooter, XComGameState_Unit Target)
{
	local XComGameStateHistory History;
	local XComGameState_Unit OldTarget;
	local UnitValue ConcealedValue;
	local bool bOpportunist;
	local name OpportunistEffect;

	History = `XCOMHISTORY;

	//  No penalty if the shooter went into Overwatch while concealed.
	if (Shooter.GetUnitValue(class'X2Ability_DefaultAbilitySet'.default.ConcealedOverwatchTurn, ConcealedValue))
	{
		if (ConcealedValue.fValue > 0)
			return 0;
	}

	foreach default.OPPORTUNIST_EFFECTS(OpportunistEffect)
	{
		if (Shooter.AffectedByEffectNames.Find(OpportunistEffect) != INDEX_NONE)
		{
			bOpportunist = true;
			break;
		}
	}

	OldTarget = XComGameState_Unit(History.GetGameStateForObjectID(Target.ObjectID, eReturnType_Reference, History.GetCurrentHistoryIndex() - 1));
	`assert(OldTarget != none);

	//  Add penalty if the target was dashing. Look for the target changing position and spending more than 1 action point as a simple check.
	if (OldTarget.TileLocation != Target.TileLocation)
	{
		if (OldTarget.NumAllActionPoints() > 1 && Target.NumAllActionPoints() == 0)
		{		
			if (bOpportunist)
				return 1 - ((1 - default.REACTION_DASHING_FINALMOD) / ( 1 - default.REACTION_FINALMOD));
			else
				return default.REACTION_DASHING_FINALMOD;
		}
	}
	if (bOpportunist)
		return 0;
	return default.REACTION_FINALMOD;
}

static function int StaticGetModifiedHitChanceForCurrentDifficulty(X2AbilityToHitCalc_StandardAim Aim, XComGameState_Player Instigator, XComGameState_Unit TargetState, int BaseHitChance)
{
	local int CurrentLivingSoldiers;
	local int SoldiersLost;  // below normal squad size
	local int ModifiedHitChance;
	local ETeam TargetTeam;
	local XComGameStateHistory History;
	local XComGameState_Unit Unit;

	ModifiedHitChance = BaseHitChance;

	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_Unit', Unit)
	{
		if( Unit.GetTeam() == eTeam_XCom && !Unit.bRemovedFromPlay && Unit.IsAlive() && !Unit.GetMyTemplate().bIsCosmetic )
		{
			++CurrentLivingSoldiers;
		}
	}

	SoldiersLost = Max(0, default.NormalSquadSize - CurrentLivingSoldiers);

	if (TargetState != none)
	{
		TargetTeam = TargetState.GetTeam( );
	}

	// XCom gets 20% bonus to hit for each consecutive miss made already this turn
	if( Instigator.TeamFlag == eTeam_XCom )
	{
		ModifiedHitChance = BaseHitChance * `ScaleTacticalArrayFloat(default.BaseXComHitChanceModifier); // 1.2
		if( BaseHitChance >= default.ReasonableShotMinimumToEnableAimAssist ) // 50
		{
			ModifiedHitChance +=
				Instigator.MissStreak * `ScaleTacticalArrayInt(default.MissStreakChanceAdjustment) + // 20
				SoldiersLost * `ScaleTacticalArrayInt(default.SoldiersLostXComHitChanceAdjustment); // 15
		}
	}
	// Aliens get -10% chance to hit for each consecutive hit made already this turn; this only applies if the XCom currently has less than 5 units alive
	else if( Instigator.TeamFlag == eTeam_Alien || Instigator.TeamFlag == eTeam_TheLost )
	{
		if( CurrentLivingSoldiers <= default.NormalSquadSize ) // 4
		{
			ModifiedHitChance =
				BaseHitChance +
				Instigator.HitStreak * `ScaleTacticalArrayInt(default.HitStreakChanceAdjustment) + // -10
				SoldiersLost * `ScaleTacticalArrayInt(default.SoldiersLostAlienHitChanceAdjustment); // -25
		}

		if( Instigator.TeamFlag == eTeam_Alien && TargetTeam == eTeam_TheLost )
		{
			ModifiedHitChance += `ScaleTacticalArrayFloat(default.AlienVsTheLostHitChanceAdjustment);
		}
		else if( Instigator.TeamFlag == eTeam_TheLost && TargetTeam == eTeam_Alien )
		{
			ModifiedHitChance += `ScaleTacticalArrayFloat(default.TheLostVsAlienHitChanceAdjustment);
		}
	}

	if (ModifiedHitChance == BaseHitChance)
		return BaseHitChance;

	ModifiedHitChance = Clamp(ModifiedHitChance, 0, default.MaxAimAssistScore);

	`log("=" $ GetFuncName() $ "=", true, 'XCom_HitRolls');
	`log("Aim Assisted hit chance:" @ ModifiedHitChance, true, 'XCom_HitRolls');

	return ModifiedHitChance;
}

function int GetModifiedHitChanceForCurrentDifficulty(XComGameState_Player Instigator, XComGameState_Unit TargetState, int BaseHitChance)
{
	return StaticGetModifiedHitChanceForCurrentDifficulty(self, Instigator, TargetState, BaseHitChance);
}