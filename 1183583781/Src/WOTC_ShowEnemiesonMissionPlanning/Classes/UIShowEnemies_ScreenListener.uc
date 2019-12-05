class UIShowEnemies_ScreenListener extends UIScreenListener;

event OnInit(UIScreen Screen)
{
	local UIShowEnemies ShowEnemies;

	// Using conditional as opposed to setting default properties screen class so this responds to the extended UISquadSelect from LWS Toolbox or Robojumper's SquadSelect
	if(UISquadSelect(Screen) != none)
	{
		`Log("+++ Initing Squadload");
		ShowEnemies = new class'UIShowEnemies';
		ShowEnemies.OnInit(Screen);
	}
}