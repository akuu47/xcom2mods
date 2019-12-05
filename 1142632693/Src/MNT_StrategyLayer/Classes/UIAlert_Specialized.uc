class UIAlert_Specialized extends UIAlert;

var public localized String m_strSpecializedSoldierHeader;
var public localized String m_strSpecializedSoldierTitle;
var public localized String m_strSoldierIsSpecialized;
var public localized String m_strSoldierSpecializedHelp;

var XComGameState_Unit UnitState;
var name Spec;

//override for UIAlert child to trigger specific Alert built in this class
simulated function BuildAlert()
{
	BindLibraryItem();
	BuildIsSpecializedAlert();
}

simulated function BuildIsSpecializedAlert()
{
	
	// Send over to flash
	LibraryPanel.MC.BeginFunctionOp("UpdateData");
	LibraryPanel.MC.QueueString(m_strSpecializedSoldierHeader); //ATTENTION
	LibraryPanel.MC.QueueString(m_strSpecializedSoldierTitle); //SOLDIER IS Specialized
	LibraryPanel.MC.QueueString(""); //ICON
	LibraryPanel.MC.QueueString(Caps(UnitState.GetName(eNameType_FullNick))); //STAFF AVAILABLE STRING
	LibraryPanel.MC.QueueString(Repl(m_strSoldierIsSpecialized, "%SPEC", Spec)); //STAFF BONUS STRING
	LibraryPanel.MC.QueueString(Repl(m_strSoldierSpecializedHelp, "%SPEC", Spec)); //STAFF BENEFIT STRING
	LibraryPanel.MC.QueueString("");
	LibraryPanel.MC.QueueString(m_strOK); //OK
	LibraryPanel.MC.EndOp();
	GetOrStartWaitingForStaffImage();
	//This panel has only one button, for confirm.
	Button2.DisableNavigation(); 
	Button2.Hide();

}

