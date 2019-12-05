// Author: SporksAreGoodForYou.


class UISL_Helmet_Customize extends UIScreenListener;

var bool ButtonShown;
var UICustomize_Menu Screen;
var UIColorSelector CP;

Event OnInit(UIScreen S) {
	if(!ButtonShown) {
		AddButtons(S);
	}
	Screen = UICustomize_Menu(S);
}

Event OnReceiveFocus(UIScreen S) {
	if(!ButtonShown) {
		AddButtons(S);
	}
	Screen = UICustomize_Menu(S);
}

Event OnRemoved(UIScreen S) { ButtonShown = false; }
Event OnLoseFocus(UIScreen S) {	ButtonShown = false; }

function AddButtons(UIScreen S) {
	local UIButton B;

	B = S.Spawn(class'UIButton', S);
	B.InitButton('HelmetButton', "VISOR COLOR PALETTE", AddSelector);
	// Hide it, and listen for a helmet match
	ButtonShown = true;

}

function AddSelector(UIButton B) {
	local int ColorSelectorX, ColorSelectorY, ColorSelectorWidth, ColorSelectorHeight;

	// Fix these
	ColorSelectorX=100;
	ColorSelectorY=275;
	ColorSelectorWidth=584;
	ColorSelectorHeight = 500;

	// Hide the list.
	Screen.List.Hide();

	// Add a button, which in turn spawns a color selector.
	if(CP == None) {
		CP = B.Screen.Spawn(class'UIColorSelector', B.Screen);
		CP.InitColorSelector('HaloHelmet', ColorSelectorX, ColorSelectorY, ColorSelectorWidth, ColorSelectorHeight,
			GetWeaponColorList(), PreviewWeaponColor, SetWeaponColor,
			// Do the thing
			);
	}
	else {
		CP.Show();
	}
}

function PreviewWeaponColor(int iColorIndex) {
	local UICustomize_Menu UIMenu;
	local XComHumanPawn HumanPawn;

	// Get the pawn
	UIMenu = UICustomize_Menu(`SCREENSTACK.GetScreen(class'UICustomize_Menu'));
	HumanPawn = XComHumanPawn(UIMenu.CustomizeManager.ActorPawn);
	
	class'Helmet_Tinter'.static.ApplyTint(HumanPawn, iColorIndex);
}

function SetWeaponColor(int iColorIndex) {
	local UICustomize_Menu UIMenu;
	local XComHumanPawn HumanPawn;
	local float UnitValSave;
	local XComGameState_Unit UnitState;


	// Get the pawn
	UIMenu = UICustomize_Menu(`SCREENSTACK.GetScreen(class'UICustomize_Menu'));
	HumanPawn = XComHumanPawn(UIMenu.CustomizeManager.ActorPawn);
	
	// Check the materials.
	class'Helmet_Tinter'.static.ApplyTint(HumanPawn, iColorIndex);

	// Save the variable. Weirdly, this doesn't require a state update. But eh, I'll take it.
	UnitValSave = iColorIndex;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(HumanPawn.ObjectID));
	UnitState.SetUnitFloatValue('Halo_VisorColour', UnitValSave, eCleanup_Never);

	Screen.List.Show();
	CP.Hide();
}

simulated function array<string> GetWeaponColorList()
{
	local XComLinearColorPalette Palette;
	local array<string> Colors; 
	local int i; 

	Palette = class'Helmet_Tinter'.static.GetPalette();
	// Palette = `CONTENT.GetColorPalette(ePalette_ArmorTint);
	for(i = 0; i < Palette.Entries.length; i++)
	{
		Colors.AddItem(class'UIUtilities_Colors'.static.LinearColorToFlashHex(Palette.Entries[i].Primary, class'XComCharacterCustomization'.default.UIColorBrightnessAdjust));
	}

	return Colors;
}


defaultproperties
{
	ScreenClass = UICustomize_Menu;
}