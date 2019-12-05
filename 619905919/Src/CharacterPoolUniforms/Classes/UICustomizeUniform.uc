class UICustomizeUniform extends UICustomize_Menu;

var localized string strApplyUniform;

simulated function UpdateData()
{

	super.UpdateData();

	if (bInArmory)
	{
		GetListItem(List.ItemCount).UpdateDataDescription(class'UIUtilities_Text'.static.GetColoredText(strApplyUniform, eUIState_Normal), RequestUniforms);
	}
}

simulated function RequestUniforms()
{
	CustomizeManager.UpdateCamera();
	Movie.Pres.ScreenStack.Push(Spawn(class'UICustomizeUniformChoices', Movie.Pres), Movie.Pres.Get3DMovie());
}