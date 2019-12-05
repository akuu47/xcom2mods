class UISL_UICustomiseSkirmisherCloak extends UIScreenListener;

// This event is triggered after a screen is initialized
event OnInit(UIScreen Screen)
{
	UICustomize(Screen).CustomizeManager.SubscribeToGetIconsForBodyPart(GetIconsForBodyPart);
}

function string GetIconsForBodyPart(X2BodyPartTemplate BodyPart)
{
	if( BodyPart.DLCName == 'SkirmisherCloak' )
	{
		return class'UIUtilities_Text'.static.InjectImage("img:///SkirmisherCloakUI.SkirmisherCloak_Icon", 26, 26, -4) $ " ";
	}
	else if( BodyPart.DLCName == 'SkirmisherCloak' )
    {
        return class'UIUtilities_Text'.static.InjectImage("img:///SkirmisherCloakUI.SkirmisherCloak_Icon", 26, 26, -4) $ " ";
    }
	return "";
}