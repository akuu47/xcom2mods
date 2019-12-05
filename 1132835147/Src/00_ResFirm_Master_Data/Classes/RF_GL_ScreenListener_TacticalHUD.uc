class RF_GL_ScreenListener_TacticalHUD extends UIScreenListener;

// This event is triggered after a screen is initialized
event OnInit(UIScreen Screen) 
{
	local UITacticalHUD MyScreen;
	MyScreen = UITacticalHUD(Screen);

	if( MyScreen == none ) { return; }
	else { MyScreen = UITacticalHUD(Screen); }

	MyScreen.m_kInventory.Remove();
	MyScreen.m_kInventory = MyScreen.Spawn(class'RF_GL_TacticalHUDInventory', MyScreen).InitInventory();
}

defaultProperties
{
    ScreenClass=class'UITacticalHUD'
}
