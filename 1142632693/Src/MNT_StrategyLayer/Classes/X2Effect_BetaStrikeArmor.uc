//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_PersistentStatChange.uc
//  AUTHOR:  Timothy Talley
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Effect_BetaStrikeArmor extends X2Effect_ModifyStats config(Mint_StrategyOverhaul);

var bool isSoldier, isSPARK;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local int HPMod;
	local StatChange Change;
	local array<StatChange> m_aStatChanges;

	// if beta strike isn't enabled, do nothing
	if(!`SecondWaveEnabled('BetaStrike'))
		return;

	// give health = amount of hp the soldier has

	Change.StatType = eStat_HP;
	Change.ModOp = MODOP_Addition;

	if(isSoldier)
		Change.StatAmount = 4; // too lazy to manually grab via code
	else if(isSPARK)
		Change.StatAmount = 10;

	HPMod = Change.StatAmount;

	if(`SecondWaveEnabled('DeltaStrike')){
		//Add armor and shields instead
		Change.StatType = eStat_ArmorMitigation;
		Change.StatAmount = Round(HPMod * class'X2Effect_ArmorStatChange'.default.ArmorModifier);
		Change.ModOp = MODOP_Addition;

		m_aStatChanges.AddItem(Change);

		Change.StatType = eStat_ShieldHP;
		Change.StatAmount = Round(HPMod * class'X2Effect_ArmorStatChange'.default.ShieldModifier);
		Change.ModOp = MODOP_Addition;

		m_aStatChanges.AddItem(Change);

	}
	else
		 m_aStatChanges.AddItem(Change);

	NewEffectState.StatChanges = m_aStatChanges;

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}