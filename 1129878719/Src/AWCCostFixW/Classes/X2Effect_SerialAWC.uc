//---------------------------------------------------------------------------------------
//  CLASS:   X2Effect_SerialAWC
//  AUTHOR:  Mr. Nice
//           
//---------------------------------------------------------------------------------------

class X2Effect_SerialAWC extends X2Effect_Serial;

`define CORRECTMCM `GETMCMVAR(FIX_SERIAL_TRIGGER)

`include(AWCCostFixW\src\AWCCostFixW\classes\PostAbilityCostPaid.uci);

DefaultProperties
{
	EffectName = "SerialKillerRF"
}