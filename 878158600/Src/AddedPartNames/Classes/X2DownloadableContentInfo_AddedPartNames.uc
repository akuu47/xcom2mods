//---------------------------------------------------------------------------------------
//  FILE:   X2DownloadableContentInfo_AddedPartNames.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_AddedPartNames extends X2DownloadableContentInfo;

var localized array<name> TorsoTemplate;
var localized array<string> TorsoName;

var localized array<name> ArmsTemplate;
var localized array<string> ArmsName;

var localized array<name> LegsTemplate;
var localized array<string> LegsName;


/// <summary>
/// Called after the Templates have been created (but before they are validated) while this DLC / Mod is installed.
/// </summary>
static event OnPostTemplatesCreated()
{
	local int i;
	local X2BodyPartTemplateManager Mgr;
	Mgr = class'X2BodyPartTemplateManager'.static.GetBodyPartTemplateManager();
	for (i = 0; i < default.TorsoTemplate.Length; i++)
	{
		`log(default.TorsoTemplate[i] @ default.TorsoName[i]);
		Mgr.FindUberTemplate("Torso", default.TorsoTemplate[i]).DisplayName = default.TorsoName[i];
	}
	for (i = 0; i < default.ArmsTemplate.Length; i++)
	{
		`log(default.ArmsTemplate[i] @ default.ArmsName[i]);
		Mgr.FindUberTemplate("Arms", default.ArmsTemplate[i]).DisplayName = default.ArmsName[i];
	}
	for (i = 0; i < default.LegsTemplate.Length; i++)
	{
		`log(default.LegsTemplate[i] @ default.LegsName[i]);
		Mgr.FindUberTemplate("Legs", default.LegsTemplate[i]).DisplayName = default.LegsName[i];
	}
}