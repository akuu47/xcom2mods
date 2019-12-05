class X2DownloadableContentInfo_WOTCReloadEndsTurn extends X2DownloadableContentInfo;

static event OnPostTemplatesCreated()
{
    local X2AbilityTemplateManager          AbilityTemplateManager;
    local X2AbilityTemplate                 AbilityTemplate;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Condition_AbilityProperty		AbilityCondition;
 
   
    // Locate each ability template
    AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
    AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate('Reload');
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;

	AbilityCondition = new class'X2Condition_AbilityProperty';
	
	/*
	if(AbilityCondition.OwnerHasSoldierAbilities.AddItem('QuickReload'))
	{
		ActionPointCost.bConsumeAllPoints = false;
	}
	else
	{
		ActionPointCost.bConsumeAllPoints = true;
	}
	*/
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.AllowedTypes.AddItem(class'X2CharacterTemplateManager'.default.DeepCoverActionPoint);
	AbilityTemplate.AbilityCosts.AddItem(ActionPointCost);
}