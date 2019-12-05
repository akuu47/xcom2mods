class X2DownloadableContentInfo_MoreGrenadesWOTC extends X2DownloadableContentInfo config(MoreGrenades);

var config bool OnlyOneClass;
var config string BonusClass;
var config int BonusGrenades;

static function FinalizeUnitAbilitiesForInit(XComGameState_Unit UnitState, out array<AbilitySetupData> SetupData, optional XComGameState StartState, optional XComGameState_Player PlayerState, optional bool bMultiplayerDisplay)
{
	local array<XComGameState_Item> UnitInventory;
	local int i, j;
	local int ExtraGrenadeAmmo;
	local XComGameState_Item item, compare;
	local X2GrenadeTemplate GrenadeTemplate, CompareTemplate;

	if (StartState != none) {
		UnitInventory = UnitState.GetAllInventoryItems(StartState);

		if (!default.OnlyOneClass || UnitState.GetSoldierClassTemplateName() == name(default.BonusClass)) {
			for (i=0; i<UnitInventory.Length; i++) {
				item = UnitInventory[i];
				if (!item.bMergedOut) {
					GrenadeTemplate = X2GrenadeTemplate(item.GetMyTemplate());
					if (GrenadeTemplate != none) {
						ExtraGrenadeAmmo = default.BonusGrenades + UnitBonusWeaponAmmoFromAbilities(UnitState, item, StartState);

						for(j = i+1; j<UnitInventory.Length; j++) {
							compare = UnitInventory[j];
							CompareTemplate = X2GrenadeTemplate(compare.GetMyTemplate());
							if (CompareTemplate == GrenadeTemplate) {
								if (compare.bMergedOut) {
									ExtraGrenadeAmmo += (default.BonusGrenades + UnitBonusWeaponAmmoFromAbilities(UnitState, compare, StartState));
								}
							}
						}

						item.Ammo += ExtraGrenadeAmmo;
					}
				}
			}
		}
	}

}

// this function is protected in XComGameState_Unit for apparently no reason
static function int UnitBonusWeaponAmmoFromAbilities(XComGameState_Unit Unit, XComGameState_Item ItemState, XComGameState StartState)
{
	local array<SoldierClassAbilityType> SoldierAbilities;
	local X2AbilityTemplateManager AbilityTemplateManager;
	local X2AbilityTemplate AbilityTemplate;
	local X2CharacterTemplate CharacterTemplate;
	local int Bonus, Idx;

	//  Note: This function is called prior to abilities being generated for the unit, so we only inspect
	//          1) the earned soldier abilities
	//          2) the abilities on the character template

	Bonus = 0;
	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	SoldierAbilities = Unit.GetEarnedSoldierAbilities();

	for (Idx = 0; Idx < SoldierAbilities.Length; ++Idx)
	{
		AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(SoldierAbilities[Idx].AbilityName);
		if (AbilityTemplate != none && AbilityTemplate.GetBonusWeaponAmmoFn != none)
			Bonus += AbilityTemplate.GetBonusWeaponAmmoFn(Unit, ItemState);
	}

	CharacterTemplate = Unit.GetMyTemplate();
	
	for (Idx = 0; Idx < CharacterTemplate.Abilities.Length; ++Idx)
	{
		AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(CharacterTemplate.Abilities[Idx]);
		if (AbilityTemplate != none && AbilityTemplate.GetBonusWeaponAmmoFn != none)
			Bonus += AbilityTemplate.GetBonusWeaponAmmoFn(Unit, ItemState);
	}

	return Bonus;
}