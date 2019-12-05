//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_WOTC_AlternateBleedout.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_WOTC_AlternateBleedout extends X2DownloadableContentInfo config(AlternateBleedout);

// Second Wave List Entry Variables
var localized string			strAlternateBleedout_Description;
var localized string			strAlternateBleedout_Tooltip;

// Excluded Template Variable
var config array<name>			EXCLUDED_TEMPLATES;

// Toggle for detailed Debug Logging
var config bool					bDEBUG_LOG;


static event OnPostTemplatesCreated()
{
	UpdateSecondWaveOptionsList();
	UpdateCharacterTemplates();
}


// Add the Pont-Based Not Created Equal option to the Second Wave Advanced Options list
static function UpdateSecondWaveOptionsList()
{
	local array<Object>			UIShellDifficultyArray;
	local Object				ArrayObject;
	local UIShellDifficulty		UIShellDifficulty;
    local SecondWaveOption		AlternateBleedout_Option;
	
	AlternateBleedout_Option.ID = 'AlternateBleedout';
	AlternateBleedout_Option.DifficultyValue = 0;

	UIShellDifficultyArray = class'XComEngine'.static.GetClassDefaultObjects(class'UIShellDifficulty');
	foreach UIShellDifficultyArray(ArrayObject)
	{
		UIShellDifficulty = UIShellDifficulty(ArrayObject);
		UIShellDifficulty.SecondWaveOptions.AddItem(AlternateBleedout_Option);
		UIShellDifficulty.SecondWaveDescriptions.AddItem(default.strAlternateBleedout_Description);
		UIShellDifficulty.SecondWaveToolTips.AddItem(default.strAlternateBleedout_Tooltip);
	}
}


// Update the Character Templates to assign the Stat Randomization function
static function UpdateCharacterTemplates()
{
	local X2CharacterTemplateManager	CharacterTemplateManager;
    local X2CharacterTemplate			CharTemplate;
    local array<X2DataTemplate>			DataTemplates;
    local X2DataTemplate				Template, DiffTemplate;

    CharacterTemplateManager = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

    foreach CharacterTemplateManager.IterateTemplates(Template, None)
    {
		if (default.EXCLUDED_TEMPLATES.Find(Template.DataName) != INDEX_NONE)
		{	// Skip updating excluded character templates.
		/**/`LOG("Alternate Bleedout: Not implementing for" @ Template.DataName @ " - Template is excluded");
			continue;
		}
		
        CharacterTemplateManager.FindDataTemplateAllDifficulties(Template.DataName, DataTemplates);
        foreach DataTemplates(DiffTemplate)
        {
            CharTemplate = X2CharacterTemplate(DiffTemplate);
            if (CharTemplate.bIsSoldier && !CharTemplate.bIsRobotic)
            {	// Assign the ability that overrides the Bleedout chance to the template's default abilities.
				CharTemplate.Abilities.AddItem('AlternateBleedoutAbility');
				/*DEBUG*/`LOG("Alternate Bleedout: Successfully implementing for" @ CharTemplate.DataName, default.bDEBUG_LOG);
}	}	}	}