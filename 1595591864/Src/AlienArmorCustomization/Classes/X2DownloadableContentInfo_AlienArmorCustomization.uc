class X2DownloadableContentInfo_AlienArmorCustomization extends X2DownloadableContentInfo;

static function UpdateAnimations(out array<AnimSet> CustomAnimSets, XComGameState_Unit UnitState, XComUnitPawn Pawn)
{
	local name ArmorName;

    if(!UnitState.IsSoldier()) return;

	ArmorName = X2ArmorTemplate(UnitState.GetItemInSlot(eInvSlot_Armor).GetMyTemplate()).DataName;

	if (UnitState.kAppearance.iGender == eGender_Male)
	{
		switch (ArmorName)
		{
			case 'HeavyAlienArmor':
				CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("DLC_60_RageSuit.Anims.AS_RageSuit_M")));
				CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("DLC_60_Soldier_RageArmor_ANIM.Anims.AS_RageArmor")));
				return;
			case 'HeavyAlienArmorMk2':
				CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("DLC_60_RageSuit.Anims.AS_RageSuit_M")));
				CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("DLC_60_Soldier_RageArmor_ANIM.Anims.AS_RageArmor")));
				return;
			case 'LightAlienArmor':
				CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("DLC_60_ViperSuit.Anims.AS_ViperSuit_M")));
				CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("DLC_60_Soldier_SerpentSuit_ANIM.Anims.AS_SerpentSuit")));
				return;
			case 'LightAlienArmorMk2':
				CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("DLC_60_ViperSuit.Anims.AS_ViperSuit_M")));
				CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("DLC_60_Soldier_SerpentSuit_ANIM.Anims.AS_SerpentSuit")));
				return;
			case 'MediumAlienArmor':
				CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("DLC_60_ArchonArmor.Anims.AS_ArchonArmor_M")));
				CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("DLC_60_Soldier_IcarusSuit_ANIM.Anims.AS_IcarusSuit")));
				return;
			default:
				return;
		}
	}
	else
	{
		switch (ArmorName)
		{
			case 'HeavyAlienArmor':
				CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("DLC_60_RageSuit.Anims.AS_RageSuit_F")));
				CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("DLC_60_Soldier_RageArmor_ANIM.Anims.AS_RageArmor")));
				return;
			case 'HeavyAlienArmorMk2':
				CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("DLC_60_RageSuit.Anims.AS_RageSuit_F")));
				CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("DLC_60_Soldier_RageArmor_ANIM.Anims.AS_RageArmor")));
				return;
			case 'LightAlienArmor':
				CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("DLC_60_ViperSuit.Anims.AS_ViperSuit_F")));
				CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("DLC_60_Soldier_SerpentSuit_ANIM.Anims.AS_SerpentSuit")));
				return;
			case 'LightAlienArmorMk2':
				CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("DLC_60_ViperSuit.Anims.AS_ViperSuit_F")));
				CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("DLC_60_Soldier_SerpentSuit_ANIM.Anims.AS_SerpentSuit")));
				return;
			case 'MediumAlienArmor':
				CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("DLC_60_ArchonArmor.Anims.AS_ArchonArmor_F")));
				CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("DLC_60_Soldier_IcarusSuit_ANIM.Anims.AS_IcarusSuit")));
				return;
			default:
				return;
		}
	}
}

static function string DLCAppendSockets(XComUnitPawn Pawn)
{
	local XComGameState_Unit UnitState;
	local name ArmorName;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(Pawn.ObjectID));
	if (UnitState == none) return "";
	ArmorName = X2ArmorTemplate(UnitState.GetItemInSlot(eInvSlot_Armor).GetMyTemplate()).DataName;

	if (UnitState.kAppearance.iGender == eGender_Male)
	{
		switch (ArmorName)
		{
			case 'HeavyAlienArmor':
				return "AlienArmorCustom.Meshes.SM_RageSuit_M";
			case 'HeavyAlienArmorMk2':
				return "AlienArmorCustom.Meshes.SM_RageSuit_M";
			case 'MediumAlienArmor':
				return "AlienArmorCustom.Meshes.SM_ArchonArmor";
			default:
				return "";
		}
	}
	else
	{
		switch (ArmorName)
		{
			case 'HeavyAlienArmor':
				return "AlienArmorCustom.Meshes.SM_RageSuit_F";
			case 'HeavyAlienArmorMk2':
				return "AlienArmorCustom.Meshes.SM_RageSuit_F";
			case 'MediumAlienArmor':
				return "AlienArmorCustom.Meshes.SM_ArchonArmor_F";
			default:
				return "";
		}
	}
}