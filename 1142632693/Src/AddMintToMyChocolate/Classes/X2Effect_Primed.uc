class X2Effect_Primed extends X2Effect_Persistent config (GameState_SoldierAbilities);

var config float BONUS_MULT;
var config int MIN_PRIME;
var() name AbilityToTrigger;

function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{
	local int DamageMod;

	if (AppliedData.AbilityInputContext.PrimaryTarget.ObjectID > 0 && class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult) && CurrentDamage != 0)
	{
		DamageMod = BONUS_MULT * CurrentDamage;
		if (DamageMod < MIN_PRIME)
			DamageMod = MIN_PRIME;
	}
	return DamageMod;
}

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local Object EffectObj;
	local XComGameState_Unit TargetUnit;

	EventMgr = `XEVENTMGR;
	EffectObj = EffectGameState;
	TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

	EventMgr.RegisterForEvent(EffectObj, 'UnitTakeEffectDamage', EffectGameState.HomingMineListener, ELD_OnStateSubmitted, , TargetUnit);
	EventMgr.RegisterForEvent(EffectObj, 'UnitDied', EffectGameState.HomingMineListener, ELD_OnStateSubmitted, , TargetUnit);
}

function bool ChangeHitResultForTarget(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit TargetUnit, XComGameState_Ability AbilityState, bool bIsPrimaryTarget, const EAbilityHitResult CurrentResult, out EAbilityHitResult NewHitResult)
{
	local XComGameState_Unit SourceUnit;

	if (class'XComGameStateContext_Ability'.static.IsHitResultMiss(CurrentResult) && X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc) != none)
	{
		SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

		if (SourceUnit.GetTeam() == Attacker.GetTeam())		//	guarantee shot for squadmates only
		{
			NewHitResult = eHit_Success;
			return true;
		}
	}
	return false;
}

simulated function GetAOETiles(XComGameState_Unit EffectSource, XComGameState_Unit EffectTarget, out array<TTile> AOETiles)
{
	local X2AbilityTemplate AbilityTemplate;
	local XGUnit OwnerVisualizer;
	local XComGameStateHistory History;
	local XComGameState_Ability Ability;

	History = `XCOMHISTORY;

	Ability = XComGameState_Ability(History.GetGameStateForObjectID(EffectSource.FindAbility(AbilityToTrigger).ObjectID));
	if( Ability != None )
	{
		AbilityTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(AbilityToTrigger);
		if( AbilityTemplate != None )
		{
			OwnerVisualizer = XGUnit(History.GetVisualizer(EffectTarget.ObjectID));
			if( OwnerVisualizer != None )
			{
				if( AbilityTemplate.AbilityMultiTargetStyle != None )
				{
					AbilityTemplate.AbilityMultiTargetStyle.GetValidTilesForLocation(Ability, OwnerVisualizer.Location, AOETiles);
				}

				if( AbilityTemplate.AbilityTargetStyle != None )
				{
					AbilityTemplate.AbilityTargetStyle.GetValidTilesForLocation(Ability, OwnerVisualizer.Location, AOETiles);
				}
			}
		}
	}
}

function bool ShouldUseMidpointCameraForTarget(XComGameState_Ability AbilityState, XComGameState_Unit Target)
{
	return true;
}

DefaultProperties
{
	DuplicateResponse = eDupe_Allow
	EffectName = "Primed"
	bCanBeRedirected = false
}