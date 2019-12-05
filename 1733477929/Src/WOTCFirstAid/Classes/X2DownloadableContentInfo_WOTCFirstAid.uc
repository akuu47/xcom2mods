class X2DownloadableContentInfo_WOTCFirstAid extends X2DownloadableContentInfo;

static event OnPostTemplatesCreated()
{
	local X2CharacterTemplateManager	CharMgr;
	local X2CharacterTemplate			CharTemplate;
	local X2DataTemplate				DataTemplate;

	CharMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

	foreach CharMgr.IterateTemplates(DataTemplate, none)
	{
		CharTemplate = X2CharacterTemplate(DataTemplate);

		if (CharTemplate.bIsSoldier) 
		{
			CharTemplate.Abilities.AddItem('IRI_FirstAid');
		}
	}
}