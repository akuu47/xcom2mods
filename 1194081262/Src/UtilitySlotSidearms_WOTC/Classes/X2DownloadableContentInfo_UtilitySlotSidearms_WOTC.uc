class X2DownloadableContentInfo_UtilitySlotSidearms_WOTC extends X2DownloadableContentInfo;

static event OnPostTemplatesCreated() {
	/* Lasers don't exist anymore
	local X2ItemTemplateManager					ItemMgr;
	local X2ItemTemplate						ItemTemplate;
	local array<X2DataTemplate>					DifficultyTemplates;
	local X2DataTemplate						DifficultyTemplate;
	
	ItemMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	
	ItemTemplate = ItemMgr.FindItemTemplate('Pistol_LS');
	if ( ItemTemplate != none ) {
		ItemMgr.FindDataTemplateAllDifficulties('PairedPistol_BM',DifficultyTemplates);
		foreach DifficultyTemplates(DifficultyTemplate) {
			ItemTemplate = X2ItemTemplate(DifficultyTemplate);
			if ( ItemTemplate != none )
				ItemTemplate.BaseItem = 'PairedPistol_LS';
		}
	}

	ItemTemplate = ItemMgr.FindItemTemplate('Sword_LS');
	if ( ItemTemplate != none ) {
		ItemMgr.FindDataTemplateAllDifficulties('PairedSword_BM',DifficultyTemplates);
		foreach DifficultyTemplates(DifficultyTemplate) {
			ItemTemplate = X2ItemTemplate(DifficultyTemplate);
			if ( ItemTemplate != none )
				ItemTemplate.BaseItem = 'PairedSword_LS';
		}
	}*/
	
	PatchVanillaWeapons();
	PatchAbilities();
	class'UtilitySlotSidearms_WOTC'.static.GrimyCreateTemplates();
}

static event OnLoadedSavedGame()
{
	UpdateStorage();
}

static event OnLoadedSavedGameToStrategy()
{
	UpdateStorage();
}

exec function UpdateUtilitySlotSidearms() {
	UpdateStorage();
}

static function FinalizeUnitAbilitiesForInit(XComGameState_Unit UnitState, out array<AbilitySetupData> SetupData, optional XComGameState StartState, optional XComGameState_Player PlayerState, optional bool bMultiplayerDisplay)
{
	class'X2TemplateHelper_USSWOTC'.static.FinalizeUnitAbilities(UnitState, SetupData, StartState, PlayerState, bMultiplayerDisplay);
}

static function UpdateStorage()
{
    local XComGameState NewGameState;
    local XComGameStateHistory History;
    local XComGameState_HeadquartersXCom XComHQ;
    local X2ItemTemplateManager ItemTemplateMgr;
    local X2DataTemplate ItemTemplate;
    local name TemplateName;
    local XComGameState_Item NewItemState;
    local array<name> AllTemplateNames;

    History = `XCOMHISTORY;
    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(" Updating HQ Storage to add utility variants");
    XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
    XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
    //NewGameState.ModifyStateObject(XComHQ);
    ItemTemplateMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

    ItemTemplateMgr.GetTemplateNames(AllTemplateNames);

    foreach AllTemplateNames(TemplateName)
    {
        if (InStr(string(TemplateName), "Paired") != INDEX_NONE) // Does the TemplateName have "Paired" in it?
        {
			ItemTemplate = ItemTemplateMgr.FindItemTemplate(name(Repl(string(TemplateName), "Paired", ""))); // Find the non-Paired "parent" template
            if (XComHQ.HasItem(X2ItemTemplate(ItemTemplate))) // Does XCOM have the non-Paired "parent" item?
            {
				ItemTemplate = ItemTemplateMgr.FindItemTemplate(name("Paired" $ ItemTemplate.DataName)); // Find the Paired template
                if (!XComHQ.HasItem(X2ItemTemplate(ItemTemplate))) // Does XCOM NOT have the Paired item?
                {
                    `LOG("Adding to HQ" @ ItemTemplate.DataName,, 'UtilitySlotSidearms_WOTC');
                    NewItemState = X2ItemTemplate(ItemTemplate).CreateInstanceFromTemplate(NewGameState);
                    NewGameState.AddStateObject(NewItemState);
                    XComHQ.AddItemToHQInventory(NewItemState);
                }
            }
        }
    }
    History.AddGameStateToHistory(NewGameState);
    History.CleanupPendingGameState(NewGameState);
}

static function PatchVanillaWeapons() {
	local X2ItemTemplateManager ItemMgr;
	local X2WeaponTemplate Template;

	ItemMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	Template = X2WeaponTemplate(ItemMgr.FindItemTemplate('AlienHunterAxeThrown_CV'));
	Template.WeaponCat = 'sword_thrown';
	Template = X2WeaponTemplate(ItemMgr.FindItemTemplate('AlienHunterAxeThrown_MG'));
	Template.WeaponCat = 'sword_thrown';
	Template = X2WeaponTemplate(ItemMgr.FindItemTemplate('AlienHunterAxeThrown_BM'));
	Template.WeaponCat = 'sword_thrown';
	
	Template = X2WeaponTemplate(ItemMgr.FindItemTemplate('WristBladeLeft_CV'));
	Template.WeaponCat = 'wristblade_left';
	Template = X2WeaponTemplate(ItemMgr.FindItemTemplate('WristBladeLeft_MG'));
	Template.WeaponCat = 'wristblade_left';
	Template = X2WeaponTemplate(ItemMgr.FindItemTemplate('WristBladeLeft_BM'));
	Template.WeaponCat = 'wristblade_left';
	
	Template = X2WeaponTemplate(ItemMgr.FindItemTemplate('ShardGauntletLeft_CV'));
	Template.WeaponCat = 'gauntlet_left';
	Template = X2WeaponTemplate(ItemMgr.FindItemTemplate('ShardGauntletLeft_MG'));
	Template.WeaponCat = 'gauntlet_left';
	Template = X2WeaponTemplate(ItemMgr.FindItemTemplate('ShardGauntletLeft_BM'));
	Template.WeaponCat = 'gauntlet_left';

	// Dear Firaxis: Why did you ship the claymore without its archetype? Signed, Every Modder Who Hates You
	Template = X2WeaponTemplate(ItemMgr.FindItemTemplate('Reaper_Claymore'));
	Template.GameArchetype = "WP_Claymore.WP_Claymore";
}

static function PatchAbilities() {
    local X2AbilityTemplateManager	TemplateManager;
	local X2AbilityTemplate			Template;
    
    TemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
    
    AddMissingAnimset(TemplateManager, 'Justice', "Skirmisher.Anims.AS_Skirmisher");

	Template = TemplateManager.FindAbilityTemplate('LaunchGrenade');
	Template.OverrideAbilities.AddItem('ThrowGrenade');
}

static function AddMissingAnimset(X2AbilityTemplateManager TemplateManager, name AbilityName, string AnimSetPath, optional string FemaleAnimSetPath = "") {
    local X2AbilityTemplate Template;
    local X2Effect_AdditionalAnimSets AdditionalAnimSetsEffect;
    local X2Effect CurrentEffect;
    local name EffectName;

    EffectName = name(string(AbilityName) $ "Anim");
    
    Template = TemplateManager.FindAbilityTemplate(AbilityName);
    if (Template != none) {
        if (Template.AbilityShooterEffects.Length > 0) {
            foreach Template.AbilityShooterEffects(CurrentEffect) {
                AdditionalAnimSetsEffect = X2Effect_AdditionalAnimSets(CurrentEffect);
                if (AdditionalAnimSetsEffect != none) {
                    if (AdditionalAnimSetsEffect.EffectName == EffectName) {
                        `log("AnimSet " $ AnimSetPath $ " already applied to " $ string(AbilityName) $ " -- skipping!");
                        return;
                    }
                }
            }
        }

        AdditionalAnimSetsEffect = new class'X2Effect_AdditionalAnimSets';
        AdditionalAnimSetsEffect.EffectName = EffectName;
        AdditionalAnimSetsEffect.AddAnimSetWithPath(AnimSetPath);
        if (FemaleAnimSetPath != "") {
            AdditionalAnimSetsEffect.AddAnimSetWithPath(FemaleAnimSetPath);
        }
        Template.AddShooterEffect(AdditionalAnimSetsEffect);
    }

}

exec function OAddItem(string strItemTemplate, optional int Quantity = 1, optional bool bLoot = false)
{
    local X2ItemTemplateManager ItemManager;
    local X2ItemTemplate ItemTemplate;
    local XComGameState NewGameState;
    local XComGameState_Item ItemState;
    local XComGameState_HeadquartersXCom HQState;
    local XComGameStateHistory History;

    ItemManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
    ItemTemplate = ItemManager.FindItemTemplate(name(strItemTemplate));
    if (ItemTemplate == none)
    {
        `log("No item template named" @ strItemTemplate @ "was found.");
        return;
    }
    History = `XCOMHISTORY;
    HQState = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
    `assert(HQState != none);
    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Add Item Cheat: Create Item");
    ItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
    NewGameState.AddStateObject(ItemState);
    ItemState.Quantity = Quantity;
    `XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Add Item Cheat: Complete");
    HQState = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(HQState.Class, HQState.ObjectID));
    HQState.AddItemToHQInventory(ItemState);
    NewGameState.AddStateObject(HQState);
    `XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
    `log("Added item" @ strItemTemplate @ "object id" @ ItemState.ObjectID);
}