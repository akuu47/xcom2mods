class X2Effect_WardenProtocol extends X2Effect_ModifyStats implements(XMBEffectInterface) config(GameData_SoldierSkills);

var int Shields_CV, Shields_MG, Shields_BM;
var int TauntMod;
var float DamageReduction;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local XComGameState_Unit UnitState;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	EffectObj = EffectGameState;

	EventMgr.RegisterForEvent(EffectObj, 'ShieldsExpended', EffectGameState.OnShieldsExpended, ELD_OnStateSubmitted, , UnitState);

	// Register for the required events
	// When the Gremlin is recalled to its owner, if aid protocol is in effect, override and return to the unit receiving aid
	// (Priority 49, so this happens after the regular ItemRecalled)
	//EventMgr.RegisterForEvent(EffectObj, 'ItemRecalled', class'X2Effect_WardenProtocol'.static.OnItemRecalled, ELD_OnStateSubmitted, 49);
}

function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{
	return -int(float(CurrentDamage) * DamageReduction);
}

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Item SourceItem;
	local XComGameState_Unit SourceUnit;
	local X2GremlinTemplate GremlinTemplate;
	local StatChange Change, TauntChange;


	SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	SourceItem = XComGameState_Item(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.ItemStateObjectRef.ObjectID));

	if (SourceItem == none)
		SourceItem = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.ItemStateObjectRef.ObjectID));

	Change.StatType = eStat_ShieldHP;
	Change.StatAmount = int(SourceUnit.GetCurrentStat(eStat_Hacking) / Shields_CV);

	if (SourceItem != none)
	{
		GremlinTemplate = X2GremlinTemplate(SourceItem.GetMyTemplate());
		if (GremlinTemplate != none)
		{
			if (GremlinTemplate.WeaponTech == 'magnetic')
				Change.StatAmount = int(SourceUnit.GetCurrentStat(eStat_Hacking) / Shields_MG);
			else if (GremlinTemplate.WeaponTech == 'beam')
				Change.StatAmount = int(SourceUnit.GetCurrentStat(eStat_Hacking) / Shields_BM);
		}
	}
	NewEffectState.StatChanges.AddItem(Change);

	TauntChange.StatType = eStat_Defense;
	TauntChange.StatAmount = TauntMod;

	NewEffectState.StatChanges.AddItem(TauntChange);

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
	local XComGameState_Ability AbilityState;
	local XComGameState_Item ItemState;

	super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);

	if( !bCleansed )     //  if it was cleansed, then it was pre-emptively removed by telling the gremlin to do something else. (not really going to happen w/o something like Inspire adding an AP)
	{
		AbilityState = XComGameState_Ability(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
		if (AbilityState == none)
			AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));

		//Recall the Gremlin if it hasn't been recalled already (for example, by the target's death)
		ItemState = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.ItemStateObjectRef.ObjectID));
		if (ItemState != None && ItemState.AttachedUnitRef.ObjectID != ItemState.OwnerStateObject.ObjectID)
			`XEVENTMGR.TriggerEvent('ItemRecalled', AbilityState, AbilityState, NewGameState);
	}

}
// XMBEffectInterface

function bool GetTagValue(name Tag, XComGameState_Ability AbilityState, out string TagValue)
{
	local XComGameState_Item SourceItem;
	local X2GremlinTemplate GremlinTemplate;

	if (AbilityState != none)
	{
		SourceItem = AbilityState.GetSourceWeapon();
	}

	switch (tag)
	{
	case 'Shield':
		if (SourceItem != none)
		{
			GremlinTemplate = X2GremlinTemplate(SourceItem.GetMyTemplate());
			if (GremlinTemplate != none)
			{
				TagValue = string(Shields_CV);
				if (GremlinTemplate.WeaponTech == 'magnetic')
					TagValue = string(Shields_MG);
				else if (GremlinTemplate.WeaponTech == 'beam')
					TagValue = string(Shields_BM);
				return true;
			}
		}
		TagValue = Shields_CV$"/"$Shields_MG$"/"$Shields_BM;
		return true;
	}

	return false;
}

function bool GetExtValue(LWTuple Tuple) { return false; }
function bool GetExtModifiers(name Type, XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, ShotBreakdown ShotBreakdown, out array<ShotModifierInfo> ShotModifiers) { return false; }

defaultproperties
{
	EffectName="MNT_WardenProtocol"
	DuplicateResponse=eDupe_Refresh
}