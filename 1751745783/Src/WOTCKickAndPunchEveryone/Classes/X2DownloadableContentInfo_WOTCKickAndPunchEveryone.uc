class X2DownloadableContentInfo_WOTCKickAndPunchEveryone extends X2DownloadableContentInfo;

static event OnPostTemplatesCreated()
{
	local X2CharacterTemplateManager	CharMgr;
	local X2CharacterTemplate			CharTemplate;
	local X2DataTemplate				DataTemplate;

	CharMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

	foreach CharMgr.IterateTemplates(DataTemplate, none)
	{
		CharTemplate = X2CharacterTemplate(DataTemplate);

		if (CharTemplate.bIsSoldier && !CharTemplate.bIsRobotic) 
		{
			if (class'X2Ability_KickAndPunch'.default.ADD_MELEE_TO_EVERYONE) CharTemplate.Abilities.AddItem('IRI_Melee_Ability');

			if (class'X2Ability_KickAndPunch'.default.ADD_STOCKSTRIKE_TO_EVERYONE) CharTemplate.Abilities.AddItem('IRI_Stockstrike_Ability');

			if (class'X2Ability_KickAndPunch'.default.ADD_KICK_TO_EVERYONE) CharTemplate.Abilities.AddItem('IRI_Kick_Ability');

			if (class'X2Ability_KickAndPunch'.default.ADD_PUNCH_TO_EVERYONE) CharTemplate.Abilities.AddItem('IRI_Punch_Ability');
		}
	}
}

static function FinalizeUnitAbilitiesForInit(XComGameState_Unit UnitState, out array<AbilitySetupData> SetupData, optional XComGameState StartState, optional XComGameState_Player PlayerState, optional bool bMultiplayerDisplay)
{
	local int Index;
	local XComGameState_Item ItemState;
	ItemState = UnitState.GetItemInSlot(eInvSlot_PrimaryWeapon);

	if (class'X2Ability_KickAndPunch'.default.EXCLUDED_CLASSES.Find(UnitState.GetSoldierClassTemplateName()) != INDEX_NONE ||	//	remove granted abilities from specified classes
	ItemState != none && class'X2Ability_KickAndPunch'.default.EXCLUDED_PRIMARY_WEAPON_CATEGORIES.Find(X2WeaponTemplate(ItemState.GetMyTemplate()).WeaponCat) != INDEX_NONE)	// OR from soldiers wielding a specific primary weapon
	{
		for(Index = SetupData.Length; Index >= 0; Index--)
		{
			if (class'X2Effect_MeleeAbilityCost'.default.MELEE_ABILITIES.Find(SetupData[Index].Template.DataName) != INDEX_NONE)
			{
				SetupData.Remove(Index, 1);
			}
		}
	}
}