//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_ComplicatedRedFog.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_ComplicatedRedFog extends X2DownloadableContentInfo config(RedFog);

var config array<name> arrImmuneToRedFog;
var config array<name> arrAddUnimmune;
var config bool bOnlyXcom;

static event OnPostTemplatesCreated()
{
	local X2CharacterTemplate 				Char, Template;
	local X2CharacterTemplateManager		CharMgr;
	local X2DataTemplate					DifficultyTemplate, Iter;
	local array<X2DataTemplate>				DifficultyTemplates;
	local int idx, i;
	local name Unimmune;
	local bool bskipme;
	
	CharMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
	
	foreach CharMgr.IterateTemplates(Iter, none)
	{
		Template = X2CharacterTemplate(Iter);
		CharMgr.FindDataTemplateAllDifficulties(Template.DataName, DifficultyTemplates);
		foreach DifficultyTemplates(DifficultyTemplate) 
		{
			bskipme=false;
			Char = X2CharacterTemplate(DifficultyTemplate);
			for(idx=0;idx<default.arrImmuneToRedFog.Length;idx++)
			{
				if((Char.CharacterGroupName == default.arrImmuneToRedFog[idx]) || (Char.DataName == default.arrImmuneToRedFog[idx]))
					bskipme=true;
			}
			//if we only want xcom to have red fog...
			if(default.bOnlyXcom)
			{
				//if the template isn't a soldier, skip them
				if(!Char.bIsSoldier)
				{
					bskipme=true;
				}
				//if they aren't a soldier but are a reshero, unskip them.
				else if(Char.bIsResistanceHero)
				{
					bskipme=false;
				}
			}
				//If they're on our unimmune exception list, unskip them.
			foreach default.arrAddUnimmune(Unimmune)
				{
					if((Unimmune == Char.CharacterGroupName) || (Unimmune == Char.DataName))
						bskipme=false;
				}
			if(!bskipme)
			{
				for (i=0;i<class'X2Ability_RedFogAbilities'.default.NumBreakPoints;i++)
				{
					Char.Abilities.AddItem(name("RedFog" $ i+1));
					//`log("Adding RedFog "$Char.DataName$" "$name("RedFog" $ i+1),,'ComplicatedRedFog');
					
				}
			}
		}
	}
}