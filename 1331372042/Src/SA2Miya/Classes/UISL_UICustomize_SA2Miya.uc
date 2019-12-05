//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIScreenListener_UICustomize_*.uc
//  AUTHOR:  Brit Steiner
//
//  PURPOSE: Adding DLC icons to the item lists.
//
//---------------------------------------------------------------------------------------
//  Copyright (c) 2009-2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class UISL_UICustomize_SA2Miya extends UIScreenListener;
 
// This event is triggered after a screen is initialized
event OnInit(UIScreen Screen)
{
	UICustomize(Screen).CustomizeManager.SubscribeToGetIconsForBodyPart(GetIconsForBodyPart);
}

// This event is triggered when a screen is removed
event OnRemoved(UIScreen Screen)
{
	local UICustomize CustomizeScreen;

	CustomizeScreen = UICustomize(Screen);

	if( CustomizeScreen != none )
	{
		if( CustomizeScreen.CustomizeManager != None )
		{
			CustomizeScreen.CustomizeManager.UnsubscribeToGetIconsForBodyPart(GetIconsForBodyPart);
		}
	}

}
 
function string GetIconsForBodyPart(X2BodyPartTemplate BodyPart)
{
    if( BodyPart.DLCName == 'SA2Miya' )
    {
        return class'UIUtilities_Text'.static.InjectImage("img:///SA2Miya_Content.UI.Icon_SA2", 26, 26, -4) $ " ";
    }
    return "";
}


defaultproperties
{
	// Leaving this assigned to none will cause every screen to trigger its signals on this class
	ScreenClass = class'UICustomize_Menu';
}