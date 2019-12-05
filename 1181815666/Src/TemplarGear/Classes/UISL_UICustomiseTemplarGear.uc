// This is an Unreal Script

class UISL_UICustomiseTemplarGear extends UIScreenListener;

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
	if( BodyPart.DLCName == 'TemplarGear' )
	{
		return class'UIUtilities_Text'.static.InjectImage("img:///Templar_GearUI.UI_TemplarGear32x32", 26, 26, -4) $ " ";
	}
	return "";
}


defaultproperties
{
	// Leaving this assigned to none will cause every screen to trigger its signals on this class
	ScreenClass = class'UICustomize_Menu';
}