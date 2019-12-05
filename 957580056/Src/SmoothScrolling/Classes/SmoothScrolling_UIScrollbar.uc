class SmoothScrolling_UIScrollbar extends UIScrollbar;

var float fInterpCurrTime; // [0, INTERP_TIME]
var float fInterpStart, fInterpGoal;
var float INTERP_TIME;

simulated function UIPanel InitPanel(optional name InitName, optional name InitLibID)
{
	super.InitPanel(InitName, InitLibID);
	Movie.Pres.SubscribeToUIUpdate(Update);
	return self;
}

simulated event Removed()
{
	super.Removed();
	Movie.Pres.UnsubscribeToUIUpdate(Update);
}

// always do that update to prevent thumb from flickering
simulated function Update()
{
	fInterpCurrTime += WorldInfo.DeltaSeconds;
	fInterpCurrTime = FClamp(fInterpCurrTime, 0.0, INTERP_TIME);

	percent = easeOutQuad(fInterpCurrTime, fInterpStart, fInterpGoal - fInterpStart, INTERP_TIME);
	if (!MC.GetBool("bDraggingThumb"))
	{
		super.SetPercent(percent);
		MC.FunctionNum("SetThumbAtPercent", percent);
	}
}

simulated function OnMouseScrollEvent( int delta ) // -1 for up, 1 for down
{
	AnimateToPercent(FClamp(fInterpGoal - delta * GetPercentToScroll(), 0.0, 1.0));
}

simulated function float easeOutQuad(float t, float b, float c, float d)
{
	return (-c) * ((t/d) * ((t/d) - 2)) + b;
}

// override, removing the mc call
simulated function UIScrollbar SetThumbAtPercent( float newPercent )
{
	if( newPercent < 0.0 || newPercent > 1.0 )
	{
		`log( "UIScrollbar.SetThumbAtPercent() You're trying to set the percentage out of range. (0.0 to 1.0) You're trying to set: " $ string(newPercent),,'uixcom');
	}

	if(percent != newPercent)
	{
		AnimateToPercent(newPercent);
	}
	return self;
}

simulated function float GetPercentToScroll()
{
	local UIList ParentList;
	ParentList = UIList(GetParent(class'UIList', true));

	if (ParentList != none)
	{
		return (ParentList.bIsHorizontal ? ParentList.Width : ParentList.Height) / (2 * ParentList.TotalItemSize);
	}
	return 0.1f;	
}

simulated function OnCommand( string cmd, string arg )
{
	local float newPercent; 

	if( cmd == "NotifyPercentChanged" )
	{
		newPercent = float(arg); 

		if( newPercent != percent )
		{
			SetPercent(newPercent);
		}
	}
}

simulated function AnimateToPercent(float newPercent)
{
	fInterpStart = percent;
	fInterpGoal = newPercent;
	fInterpCurrTime = 0;
}

simulated function SetPercent( float newPercent )
{
	super.SetPercent(newPercent);
	percent = newPercent;
	fInterpStart = newPercent;
	fInterpGoal = newPercent;
}


defaultproperties
{
	INTERP_TIME=0.55	
}