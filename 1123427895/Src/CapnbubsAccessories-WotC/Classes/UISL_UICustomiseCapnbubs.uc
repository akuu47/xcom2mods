//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIScreenListener_UICustomize
//  AUTHOR:  Brit Steiner
//
//  PURPOSE: Adding DLC icons to the item lists.
//
//---------------------------------------------------------------------------------------
//  Copyright (c) 2009-2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class UISL_UICustomiseCapnbubs extends UIScreenListener;
 
// This event is triggered after a screen is initialized
event OnInit(UIScreen Screen)
{
    local UICustomize CustomizeScreen;
 
    CustomizeScreen = UICustomize(Screen);
 
    if( CustomizeScreen != none )
    {
        if( CustomizeScreen.CustomizeManager != None )
        {
            CustomizeScreen.CustomizeManager.SubscribeToGetIconsForBodyPart(GetIconsForBodyPart);
        }
    }
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
    if( BodyPart.DLCName == 'CBAccessories' )
    {
        return class'UIUtilities_Text'.static.InjectImage("img:///UILibrary_Capnbubs.Capnbubs_icon", 26, 26, -4) $ " ";
    }
    return "";
}