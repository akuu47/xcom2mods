class XComGameState_Stealth extends XComGameState_BaseObject;

var private int ConcealmentLoss;

public function SetConcealmentLoss(int ConcealmentLossToSet)
{
	ConcealmentLoss = ConcealmentLossToSet;
}

public function int GetConcealmentLoss()
{
	return ConcealmentLoss;
}

public function AddConcealmentLoss(int ConcealmentLossToAdd)
{
	ConcealmentLoss = ConcealmentLoss + ConcealmentLossToAdd;
	if (ConcealmentLoss > 100)
		ConcealmentLoss = 100;
}