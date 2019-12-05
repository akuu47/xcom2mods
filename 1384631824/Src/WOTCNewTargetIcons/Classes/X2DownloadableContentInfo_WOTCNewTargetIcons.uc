//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_WOTCNewTargetIcons.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_WOTCNewTargetIcons extends X2DownloadableContentInfo;

struct CharPropLimit
{
	var bool bRequireAlien;
	var bool bRequireAdvent;
	
	structdefaultproperties
	{
		bRequireAlien=false
		bRequireAdvent=false
	}
};

struct NameStringMapping
{
	var name nm;
	var string str;
	var CharPropLimit Limits;
};

var config array<NameStringMapping> CharGroups;

/// <summary>
/// Called after the Templates have been created (but before they are validated) while this DLC / Mod is installed.
/// </summary>
static event OnPostTemplatesCreated()
{
	local X2CharacterTemplateManager Mgr;
	local X2DataTemplate Template;
	local X2CharacterTemplate Tmpl;
	local int i;

	Mgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
	foreach Mgr.IterateTemplates(Template, none)
	{
		Tmpl = X2CharacterTemplate(Template);
		if (Tmpl == none)
			continue;

		i = default.CharGroups.Find('nm', Tmpl.CharacterGroupName);
		if (i != INDEX_NONE)
		{
			SetTargetingImage(Tmpl.DataName, default.CharGroups[i].str, Mgr);
		}
	}
}

static function SetTargetingImage(name TemplateName, string strPath, X2CharacterTemplateManager Mgr)
{
	local array<X2DataTemplate> CharacterTemplates;
	local int i;

	Mgr.FindDataTemplateAllDifficulties(TemplateName, CharacterTemplates);
	for (i = 0; i < CharacterTemplates.Length; i++)
	{
		X2CharacterTemplate(CharacterTemplates[i]).strTargetIconImage = strPath;
	}
}