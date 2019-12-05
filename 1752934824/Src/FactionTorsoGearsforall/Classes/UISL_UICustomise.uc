class UISL_UICustomise extends UIScreenListener;

// This event is triggered after a screen is initialized
event OnInit(UIScreen Screen)
{
	UICustomize(Screen).CustomizeManager.SubscribeToGetIconsForBodyPart(GetIconsForBodyPart);
}

function string GetIconsForBodyPart(X2BodyPartTemplate BodyPart)
{
	if( BodyPart.DLCName == 'FactionTorsoGear' )
	{
		return class'UIUtilities_Text'.static.InjectImage("img:///UILibrary_Common.class_rookie", 26, 26, -4) $ " ";
	}
	else if( BodyPart.DLCName == 'FactionTorsoGear' )
    {
        return class'UIUtilities_Text'.static.InjectImage("img:///UILibrary_Common.class_rookie", 26, 26, -4) $ " ";
    }
	return "";
}

