class X2DownloadableContentInfo_MorePsionicUnits extends X2DownloadableContentInfo;

static event OnPostTemplatesCreated()
{
	local X2CharacterTemplateManager	CharacterMgr;
	local array<X2DataTemplate>			TemplateAllDifficulties;
	local X2DataTemplate				Template;
	local X2CharacterTemplate			CharacterTemplate;
	local name							TemplateName;
	local array<name>					TemplateNames;

	CharacterMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

	CharacterMgr.GetTemplateNames(TemplateNames);

	foreach TemplateNames(TemplateName)
	{
		CharacterMgr.FindDataTemplateAllDifficulties(TemplateName, TemplateAllDifficulties);

		foreach TemplateAllDifficulties(Template)
		{
			CharacterTemplate = X2CharacterTemplate(Template);

			if (CharacterTemplate.CharacterGroupName == 'ChosenAssassin')
				CharacterTemplate.bIsPsionic = true;

			if (CharacterTemplate.CharacterGroupName == 'ChosenSniper')
				CharacterTemplate.bIsPsionic = true;

			if (CharacterTemplate.CharacterGroupName == 'ChosenWarlock')
				CharacterTemplate.bIsPsionic = true;

			if (CharacterTemplate.CharacterGroupName == 'SpectralStunLancer')
				CharacterTemplate.bIsPsionic = true;

			if (CharacterTemplate.CharacterGroupName == 'SpectralZombie')
				CharacterTemplate.bIsPsionic = true;

			if (CharacterTemplate.CharacterGroupName == 'PsiZombie')
				CharacterTemplate.bIsPsionic = true;

			if (CharacterTemplate.DefaultSoldierClass == 'Templar')
				CharacterTemplate.bIsPsionic = true;

			if (CharacterTemplate.DefaultSoldierClass == 'TemplarDisciple')
				CharacterTemplate.bIsPsionic = true;
		}
	}
}