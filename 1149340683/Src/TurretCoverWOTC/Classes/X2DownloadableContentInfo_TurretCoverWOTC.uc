//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_TurretCoverWOTC.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_TurretCoverWOTC extends X2DownloadableContentInfo;



static event OnPostTemplatesCreated()
{
	AddAbilitytoCharacters(class'X2Ability_AlwaysProvideCover'.default.HighCover, class'X2Ability_AlwaysProvideCover'.default.HighCoverAbilityName);
	AddAbilitytoCharacters(class'X2Ability_AlwaysProvideCover'.default.LowCover, class'X2Ability_AlwaysProvideCover'.default.LowCoverAbilityName);

	BulwarkCompatibility();
}

static function AddAbilityToCharacters(array<name> Characters, name Ability)
{
	local X2CharacterTemplateManager CharMgr;
	local X2CharacterTemplate CharTemplate;
	local array<X2DataTemplate> Templates;
	local X2DataTemplate Template;
	local name CharName;
	
	CharMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
	
	foreach Characters(CharName)
	{
		CharTemplate = CharMgr.FindCharacterTemplate(CharName);
		if(CharTemplate.bShouldCreateDifficultyVariants)
		{
			CharMgr.FindDataTemplateAllDifficulties(CharName, Templates);
			foreach Templates(Template)
			{
				AddAbility(X2CharacterTemplate(Template), Ability);
			}
		}

		else
		{
			AddAbility(CharTemplate, Ability);
		}
	}
}

static function AddAbility(X2CharacterTemplate Template, name Ability)
{
	if(none != Template && INDEX_NONE == Template.Abilities.find(Ability))
	{
		`log("TurretCoverWOTC: Adding"@string(Ability)@"to"@Template);
		Template.Abilities.AddItem(Ability);
	}
	else
	{
		`log("TurretCoverWOTC: Failed to grant"@string(Ability)@"to"@Template);
	}
}

static function BulwarkCompatibility()
{
	local X2AbilityTemplateManager AbilityMgr;
	local X2AbilityTemplate AbilityTemplate;

	AbilityMgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	AbilityTemplate = AbilityMgr.FindAbilityTemplate('Bulwark');
	if(none != AbilityTemplate)
	{
		AbilityTemplate.OverrideAbilities.AddItem(class'X2Ability_AlwaysProvideCover'.default.HighCoverAbilityName);
		AbilityTemplate.OverrideAbilities.AddItem(class'X2Ability_AlwaysProvideCover'.default.LowCoverAbilityName);
	}
}