class X2DownloadableContentInfo_WotC_StabilizeMe extends X2DownloadableContentInfo;

static event OnLoadedSavedGame()
{
}

static event InstallNewCampaign(XComGameState StartState)
{}


static event OnPostTemplatesCreated() {
	GiveStabilizeMedkitOwner();
}

static function GiveStabilizeMedkitOwner()
{
	local X2CharacterTemplateManager	CharManager;
	local X2CharacterTemplate			CharTemplate;

	local X2DataTemplate			DifficultyTemplate;

	CharManager = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

	foreach CharManager.IterateTemplates(DifficultyTemplate, none) {
		CharTemplate = X2CharacterTemplate(DifficultyTemplate);

		if(CharTemplate != none && CharTemplate.bIsSoldier && !CharTemplate.bIsRobotic)
		{
			CharTemplate.Abilities.AddItem('StabilizeMedkitOwner');
			//`log('Unit acquired CarryUnitWorkaround');
		}
	}
}