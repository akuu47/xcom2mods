class UISL_UICustomiseCapnbubs extends UIScreenListener;

// This event is triggered after a screen is initialized
event OnInit(UIScreen Screen)
{
	UICustomize(Screen).CustomizeManager.SubscribeToGetIconsForBodyPart(GetIconsForBodyPart);
}

function string GetIconsForBodyPart(X2BodyPartTemplate BodyPart)
{
	if( BodyPart.DLCName == 'WardenGear' )
	{
		return class'UIUtilities_Text'.static.InjectImage("img:///WardenArmorUI.UI_Icon.WardenGear_Icon", 26, 26, -4) $ " ";
	}
	else if( BodyPart.DLCName == 'WardenGearNoCamo' )
    {
        return class'UIUtilities_Text'.static.InjectImage("img:///WardenArmorUI.UI_Icon.WardenGearNoCamo_Icon", 26, 26, -4) $ " ";
    }
	return "";
}