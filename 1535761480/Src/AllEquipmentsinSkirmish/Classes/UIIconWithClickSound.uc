class UIIconWithClickSound extends UIIcon;

simulated function OnMouseEvent(int cmd, array<string> args)
{
	super(UIPanel).OnMouseEvent(cmd, args);

	switch(cmd)
	{
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_IN :
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_DRAG_OVER :
		OnReceiveFocus();
		break;
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_OUT :
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_DRAG_OUT :
		OnLoseFocus();
		break;
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_UP_DELAYED:
		if(!IsDisabled && OnClickedDelegate != none)
		{
			Movie.Pres.PlayUISound(eSUISound_MenuSelect);
			OnClickedDelegate();
		}
		break;
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_DOUBLE_UP:
		if(!IsDisabled && OnDoubleClickedDelegate != none)
			OnDoubleClickedDelegate();
		break;
	}
}