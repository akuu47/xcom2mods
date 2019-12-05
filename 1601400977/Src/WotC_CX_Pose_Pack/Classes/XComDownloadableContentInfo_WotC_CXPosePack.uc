//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_*.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class XComDownloadableContentInfo_WotC_CXPosePack extends X2DownloadableContentInfo;



/// <summary>
/// Called after the Templates have been created (but before they are validated) while this DLC / Mod is installed.
/// </summary>
static event OnPostTemplatesCreated()
{
	//Add the additional AnimSets first
	class'X2Helpers_WotC_CX_PosePack'.static.OnPostCharacterTemplatesCreated();

//	//Add the new photobooth poses
//	class'X2Helpers_PhotoboothUtil'.static.AddPosesToPhotoboothBypass();
}
