class UIAlert_IsPsionic extends UIAlert;

var public localized String m_strPsionicSoldierHeader;
var public localized String m_strPsionicSoldierTitle;
var public localized String m_strSoldierIsPsionic;
var public localized String m_strSoldierPsionicHelp;

var XComGameState_Unit UnitState;

//override for UIAlert child to trigger specific Alert built in this class
simulated function BuildAlert()
{
	BindLibraryItem();
	BuildIsPsionicAlert();
}

simulated function BuildIsPsionicAlert()
{

	// Send over to flash
	LibraryPanel.MC.BeginFunctionOp("UpdateData");
	LibraryPanel.MC.QueueString(m_strPsionicSoldierHeader); //ATTENTION
	LibraryPanel.MC.QueueString(m_strPsionicSoldierTitle); //SOLDIER IS PSIONIC
	LibraryPanel.MC.QueueString(""); //ICON
	LibraryPanel.MC.QueueString(Caps(UnitState.GetName(eNameType_FullNick))); //STAFF AVAILABLE STRING
	LibraryPanel.MC.QueueString(m_strSoldierIsPsionic); //STAFF BONUS STRING
	LibraryPanel.MC.QueueString(m_strSoldierPsionicHelp); //STAFF BENEFIT STRING
	LibraryPanel.MC.QueueString("");
	LibraryPanel.MC.QueueString(m_strOK); //OK
	LibraryPanel.MC.EndOp();
	GetOrStartWaitingForStaffImage();
	//This panel has only one button, for confirm.
	Button2.DisableNavigation(); 
	Button2.Hide();

}

