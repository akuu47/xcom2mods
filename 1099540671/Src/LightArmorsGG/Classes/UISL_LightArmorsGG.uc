// This is an Unreal Script
//Thanks to robojumper for helping debugging that script

//class UIScreenListener_UICustomize extends UIScreenListener;
class UISL_LightArmorsGG extends UIScreenListener;

// This event is triggered after a screen is initialized
event OnInit(UIScreen Screen){
	local UICustomize CustomizeScreen;
	CustomizeScreen = UICustomize(Screen);
	if( CustomizeScreen != none ){
		if( CustomizeScreen.CustomizeManager != None ){
			CustomizeScreen.CustomizeManager.SubscribeToGetIconsForBodyPart(GetIconsForBodyPart);
		}
	}
}

function string GetIconsForBodyPart(X2BodyPartTemplate BodyPart){
	if( BodyPart.DLCName == 'LightArmorsGG' )	{
		return class'UIUtilities_Text'.static.InjectImage("img:///ArmorsGG.GGIcon", 26, 26, -4) $ " ";
	}
	return "";
}