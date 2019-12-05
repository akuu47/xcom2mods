//---------------------------------------------------------------------------------------
//  CLASS:    X2Effect_DeathFromAboveAWC
//  AUTHOR:  Mr. Nice
//           
//---------------------------------------------------------------------------------------

class X2Effect_DeathFromAboveAWC extends X2Effect_DeathFromAbove;

`define CORRECTMCM `GETMCMVAR(FIX_DEATHFROMABOVE_TRIGGER)

`include(AWCCostFixW\src\AWCCostFixW\classes\PostAbilityCostPaid.uci);
