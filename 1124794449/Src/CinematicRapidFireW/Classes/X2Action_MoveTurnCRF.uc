//-----------------------------------------------------------
//	Class:	X2Action_MoveTurnCRF
//	Author: Mr. Nice
//	
//-----------------------------------------------------------


class X2Action_MoveTurnCRF extends X2Action_MoveTurn config(Game);

var config float Tolerance;

simulated state Executing
{
	simulated function bool ShouldTurn()
	{
		local float fDot;

		m_vFaceDir = m_vFacePoint - UnitPawn.Location;
		m_vFaceDir.Z = 0;
		m_vFaceDir = normal(m_vFaceDir);

		fDot = m_vFaceDir dot vector(UnitPawn.Rotation);

		return fDot < Tolerance;
	}
}
