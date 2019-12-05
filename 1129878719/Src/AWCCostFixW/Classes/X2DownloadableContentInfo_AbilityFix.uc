//---------------------------------------------------------------------------------------
//  CLASS:     X2DownloadableContentInfo_AbilityFix
//  AUTHOR:  Mr. Nice
//           
//---------------------------------------------------------------------------------------


class X2DownloadableContentInfo_AbilityFix extends X2DownloadableContentInfo config(AbilityFix_DEFAULT);

`define GETAB(ABNAME) abilities.FindAbilityTemplate(`ABNAME)
`define IFGETAB(ABNAME) ability=`GETAB(`ABNAME); if (ability!=none)

`include(AWCCostFixW\Src\ModConfigMenuAPI\MCM_API_CfgHelpers.uci)

var config array<name> FIRST_SHOT;
var config array<name> SECOND_SHOT;
var config array<name> SERIAL_VARIANT;

var array<name> MoveAPOrdinal;
/// <summary>
/// Called after the Templates have been created (but before they are validated) while this DLC / Mod is installed.
/// </summary>
static event OnPostTemplatesCreated()
{
	local X2AbilityTemplateManager abilities;
	local X2AbilityTemplate ability;
	local X2DataTemplate DataTemplate;
	local X2Effect_Persistent PersistentEffect;
	local X2AbilityCost_ActionPoints APCost;
	local X2AbilityCost_ImplacableFixPost PostFix;
	local X2AbilityCost_ImplacableFixPre PreFix;
	local int i, idx;
	local name AbilityName;
	
	abilities=class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	foreach abilities.IterateTemplates(DataTemplate)
	{
		ability=X2AbilityTemplate(DataTemplate);
		for (i=0;i<ability.AbilityCosts.Length;i++)
		{
			APCost=X2AbilityCost_ActionPoints(ability.AbilityCosts[i]);
			if (APCost!=none)
			{
				if (i==0 && APCost.AllowedTypes.Find(class'X2CharacterTemplateManager'.default.CounterattackActionPoint)!=INDEX_NONE)
					 continue;
				idx=APCost.AllowedTypes.Find('standard');
				if (idx!=INDEX_NONE)
					APCost.AllowedTypes.InsertItem(idx, 'reaper');
				else
				{
					idx=APCost.AllowedTypes.Find('momentum');
					if (idx!=INDEX_NONE)
						APCost.AllowedTypes.InsertItem(idx, 'reaper');
				}
				if(!APCost.bFreeCost)
				{
					PostFix=new class'X2AbilityCost_ImplacableFixPost';
					PreFix=new class'X2AbilityCost_ImplacableFixPre';
					PreFix.PostFix=PostFix;
					PreFix.APCost=APCost;
					ability.AbilityCosts.InsertItem(i+1, PostFix);
					ability.AbilityCosts.InsertItem(i, PreFix);
					i+=2;
				}
			}
		}
	}

	foreach default.SERIAL_VARIANT(AbilityName)
	{
		`log(`showvar(AbilityName));
		`IFGETAB(AbilityName)
		{
		`log(`showvar(AbilityName));
			PersistentEffect = new class'X2Effect_SerialAWC';
			PersistentEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnEnd);
			ability.AddTargetEffect(PersistentEffect);
		}
	}

	`IFGETAB('DeathFromAbove')
	{
		PersistentEffect = new class'X2Effect_DeathFromAboveAWC';
		PersistentEffect.BuildPersistentEffect(1, true, false, false);
		ability.AddTargetEffect(PersistentEffect);
	}
	`IFGETAB('SoulReaperContinue')
	{
		for(i=0; i<ability.AbilityTriggers.length; i++)
		{
			if(X2AbilityTrigger_EventListener(ability.AbilityTriggers[i])!=none &&
				Instr(X2AbilityTrigger_EventListener(ability.AbilityTriggers[i]).ListenerData.EventFn, "SoulReaperListener")!=INDEX_NONE)
			{
				X2AbilityTrigger_EventListener(ability.AbilityTriggers[i]).ListenerData.EventFn = SoulReaperListener;
				break;
			}
		}
	}
	LiveApply(abilities);	
}

static function LiveApply(optional X2AbilityTemplateManager Abilities)
{
	local X2AbilityTemplate ability;
	local X2Effect_ApplyWeaponDamage WeaponDamage;
	local int i;

	if (Abilities==none) Abilities=class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	`IFGETAB('CombatProtocol')
	{
		for(i=0;i<ability.AbilityTargetEffects.length;i++)
		{
			WeaponDamage=X2Effect_ApplyWeaponDamage(ability.AbilityTargetEffects[i]);
			if (WeaponDamage!=none && WeaponDamage.DamageTag=='CombatProtocol_Robotic')
			{
				X2Condition_UnitProperty(WeaponDamage.TargetConditions[0]).ExcludeFriendlyToSource=!`GETMCMVAR(FIX_COMBATPROTOCOL_ROBOTIC);
				break;
			}
		}
	}
	`IFGETAB('ArcWave')
	{
		Ability.bSkipMoveStop=`GETMCMVAR(FIX_ARCWAVE);
	}
}

static function int MoveAPCompare(name Item1, name Item2)
{
	return default.MoveAPOrdinal.Find(Item2) - default.MoveAPOrdinal.Find(Item1);
}

static function EventListenerReturn SoulReaperListener(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameStateHistory History;
	local XComGameState_Ability AbilityState;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit SourceUnit, TargetUnit;
	local array<StateObjectReference> PossibleTargets;
	local StateObjectReference BestTargetRef;
	local int BestTargetHP;
	local int i;
	local bool bAbilityContinues;

	if (!`GETMCMVAR(FIX_ANNIHILATE))
		return XComGameState_Ability(CallbackData).SoulReaperListener(EventData, EventSource, GameState, EventID, CallbackData);

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
	{
		AbilityState = XComGameState_Ability(CallbackData);
		SourceUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));

		bAbilityContinues = AbilityState.AbilityTriggerAgainstSingleTarget(AbilityContext.InputContext.PrimaryTarget, false);

		if (!bAbilityContinues && SourceUnit.HasSoldierAbility('SoulHarvester'))
		{
			History = `XCOMHISTORY;
			//	find all possible new targets and select one with the highest HP to fire against
			class'X2TacticalVisibilityHelpers'.static.GetAllVisibleEnemyUnitsForUnit(SourceUnit.ObjectID, PossibleTargets, AbilityState.GetMyTemplate().AbilityTargetConditions);
			BestTargetHP = -1;
			for (i = 0; i < PossibleTargets.Length; ++i)
			{
				TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(PossibleTargets[i].ObjectID));
				if (TargetUnit.GetCurrentStat(eStat_HP) > BestTargetHP)
				{
					BestTargetHP = TargetUnit.GetCurrentStat(eStat_HP);
					BestTargetRef = PossibleTargets[i];
				}
			}
			if (BestTargetRef.ObjectID > 0)
			{
				bAbilityContinues = AbilityState.AbilityTriggerAgainstSingleTarget(BestTargetRef, false);
			}
		}
		if (!bAbilityContinues)
		{
			SourceUnit.BreakConcealment();
		}
	}
	return ELR_NoInterrupt;
}

defaultproperties
{
	MoveAPOrdinal(0)="momentum";
	MoveAPOrdinal(1)="move";
}
