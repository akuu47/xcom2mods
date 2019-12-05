//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_PersistentStatChange.uc
//  AUTHOR:  Timothy Talley
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Effect_ArmorStatChange extends X2Effect_ModifyStats config(Mint_StrategyOverhaul);

var array<StatChange>	m_aStatChanges;
var config float ArmorModifier, ShieldModifier;

simulated function SetStatArray(array<StatChange> StatArray)
{
	m_aStatChanges = StatArray;
}

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local int idx, ArmorMod, ShieldMod;
	local bool ModdedArmor, ModdedShield;
	local StatChange Change;

	NewEffectState.StatChanges = m_aStatChanges;

	ArmorMod = 0;
	ShieldMod = 0;
	ModdedArmor = false;
	ModdedShield = false;

	for (idx = 0; idx < NewEffectState.StatChanges.Length; ++idx)
	{
		Change = NewEffectState.StatChanges[ idx ];

		if (Change.StatType == eStat_HP && Change.ModOp == MODOP_Addition){

			// multiply by beta strike values if neccessary
			if(`SecondWaveEnabled('BetaStrike'))
				NewEffectState.StatChanges[ idx ].StatAmount *= class'X2StrategyGameRulesetDataStructures'.default.SecondWaveBetaStrikeHealthMod;

			// convert to armor/shields if Delta Strike enabled
			if (`SecondWaveEnabled('DeltaStrike')){		

				// Account for base hp change
				if(`SecondWaveEnabled('BetaStrike'))
					NewEffectState.StatChanges[ idx ].StatAmount += 4;

				ArmorMod += (Round(NewEffectState.StatChanges[ idx ].StatAmount * ArmorModifier));
				ShieldMod += (Round(NewEffectState.StatChanges[ idx ].StatAmount * ShieldModifier));
				
				// set to zero, siunce we're replacing hp with armor/shield
				NewEffectState.StatChanges[ idx ].StatAmount = 0;
			}

		}

		// Adds existing armor and shield modifiers if they exist
		if (Change.StatType == eStat_ArmorMitigation && `SecondWaveEnabled('DeltaStrike')){
			ArmorMod += NewEffectState.StatChanges[ idx ].StatAmount;
		}
		
		if (Change.StatType == eStat_ShieldHP && `SecondWaveEnabled('DeltaStrike'))
			ShieldMod += NewEffectState.StatChanges[ idx ].StatAmount;

	}

	// Since most armors won't modify armor or shield values, loop once more and set correct values, adding entries if needed
	if(`SecondWaveEnabled('DeltaStrike')){
		for (idx = 0; idx < NewEffectState.StatChanges.Length; ++idx)
		{
			Change = NewEffectState.StatChanges[ idx ];

			if (Change.StatType == eStat_ArmorMitigation)
			{
				NewEffectState.StatChanges[ idx ].StatAmount = ArmorMod;
				ModdedArmor = true;
			}
			if (Change.StatType == eStat_ShieldHP){
				NewEffectState.StatChanges[ idx ].StatAmount = ShieldMod;
				ModdedShield = true;
			}
		}

		//Manually add armor/shields if they weren't found in the existing stat array
		if(!ModdedArmor){
			Change.StatType = eStat_ArmorMitigation;
			Change.StatAmount = ArmorMod;
			Change.ModOp = MODOP_Addition;

			NewEffectState.StatChanges.AddItem(Change);
		}
		if(!ModdedShield){
			Change.StatType = eStat_ShieldHP;
			Change.StatAmount = ShieldMod;
			Change.ModOp = MODOP_Addition;

			NewEffectState.StatChanges.AddItem(Change);
		}

	}


	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}