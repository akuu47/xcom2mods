//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_WOTC_ExtendedGrenadeTweaks.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_WOTC_ExtendedGrenadeTweaks extends X2DownloadableContentInfo;

struct DamageStep
{
	var float DistanceRatio;
	var float DamageRatio;
};

/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{}

/// <summary>
/// Called when the player starts a new campaign while this DLC / Mod is installed
/// </summary>
static event InstallNewCampaign(XComGameState StartState)
{}

static event OnPostTemplatesCreated()
{
    local X2AbilityTemplateManager AbilityTemplateMgr;
    local X2ItemTemplateManager ItemTemplateMgr;
    local name TemplateName;
    local array<name> TemplateNames;
    local X2AbilityTemplate AbilityTemplate;
    local array<X2AbilityTemplate> AbilityTemplates;
    local X2DataTemplate ItemTemplate;
    local array<X2DataTemplate> ItemTemplates;
    local X2StrategyElementTemplateManager		StrategyTemplateMgr;
    local array<X2StrategyElementTemplate>		TemplateMods;
    local X2LWTemplateModTemplate				ModTemplate;
    local int idx;
    local int Difficulty;
    
    StrategyTemplateMgr	= class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
    AbilityTemplateMgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
    ItemTemplateMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

    TemplateMods = StrategyTemplateMgr.GetAllTemplatesOfClass(class'X2LWTemplateModTemplate');
    for (idx = 0; idx < TemplateMods.Length; ++idx)
    {
        ModTemplate = X2LWTemplateModTemplate(TemplateMods[idx]);

        // Ability mods
        if (ModTemplate.AbilityTemplateModFn != none)
        {
            AbilityTemplateMgr.GetTemplateNames(TemplateNames);
            foreach TemplateNames(TemplateName)
            {
	            AbilityTemplateMgr.FindAbilityTemplateAllDifficulties(TemplateName, AbilityTemplates);
	            foreach AbilityTemplates(AbilityTemplate)
	            {
		            Difficulty = GetDifficultyFromTemplateName(TemplateName);
		            ModTemplate.AbilityTemplateModFn(AbilityTemplate, Difficulty);
	            }
            }
        }

        // Item mods
        if (ModTemplate.ItemTemplateModFn != none)
        {
            ItemTemplateMgr.GetTemplateNames(TemplateNames);
            foreach TemplateNames(TemplateName)
            {
	            ItemTemplateMgr.FindDataTemplateAllDifficulties(TemplateName, ItemTemplates);
	            foreach ItemTemplates(ItemTemplate)
	            {
		            Difficulty = GetDifficultyFromTemplateName(TemplateName);
		            ModTemplate.ItemTemplateModFn(X2ItemTemplate(ItemTemplate), Difficulty);
	            }
            }
        }
    }
}

static function int GetDifficultyFromTemplateName(name TemplateName)
{
	return int(GetRightMost(string(TemplateName)));
}