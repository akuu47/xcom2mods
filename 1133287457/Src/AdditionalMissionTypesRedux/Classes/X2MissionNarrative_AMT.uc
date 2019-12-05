
class X2MissionNarrative_AMT extends X2MissionNarrative;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2MissionNarrativeTemplate> Templates;

    // Resistance Ops
        Templates.AddItem(AddEmergencyDefenseTemplarNarrativeTemplate());
        Templates.AddItem(AddEmergencyDefenseSkirmisherNarrativeTemplate());
        Templates.AddItem(AddEmergencyDefenseReapersNarrativeTemplate());

	//Sabotage
		Templates.AddItem(AddRMSabotageVIPNeutralizeTemplate());

	//Retaliation
		Templates.AddItem(AddTerrorEscapeTemplate());

	//GOps
		Templates.AddItem(AddOperativeEscortTemplate());

    return Templates;
}


static function X2MissionNarrativeTemplate AddOperativeEscortTemplate()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'RM_OperativeEscort');

    Template.MissionType = "RM_OperativeEscort";
    Template.NarrativeMoments[0]="X2NarrativeMoments.TACTICAL.Hack.Hack_TacIntro";
    Template.NarrativeMoments[1]="X2NarrativeMoments.TACTICAL.General.GenTactical_SecureRetreat";
    Template.NarrativeMoments[2]="X2NarrativeMoments.TACTICAL.General.GenTactical_ConsiderRetreat";
    Template.NarrativeMoments[3]="X2NarrativeMoments.TACTICAL.General.GenTactical_AdviseRetreat";
    Template.NarrativeMoments[4]="X2NarrativeMoments.TACTICAL.General.GenTactical_PartialEVAC";
    Template.NarrativeMoments[5]="X2NarrativeMoments.TACTICAL.General.GenTactical_FullEVAC";
    Template.NarrativeMoments[6]="X2NarrativeMoments.TACTICAL.Hack.Hack_TerminalSpotted";
    Template.NarrativeMoments[7]="X2NarrativeMoments.TACTICAL.Hack.Hack_TimerNagThree";
    Template.NarrativeMoments[8]="X2NarrativeMoments.TACTICAL.Hack.Hack_TimerNagLast";
    Template.NarrativeMoments[9]="X2NarrativeMoments.TACTICAL.Hack.Hack_TimerBurnout";
    Template.NarrativeMoments[10]="X2NarrativeMoments.TACTICAL.Hack.Hack_TerminalDestroyedEnemyRemain";
    Template.NarrativeMoments[11]="X2NarrativeMoments.TACTICAL.Hack.Hack_TerminalDestroyedMissionOver";
    Template.NarrativeMoments[12]="X2NarrativeMoments.TACTICAL.General.CEN_Gen_AreaSecured_02";
    Template.NarrativeMoments[13]="X2NarrativeMoments.TACTICAL.Hack.Central_Hack_TerminalHackedWithRNF";
    Template.NarrativeMoments[14]="X2NarrativeMoments.TACTICAL.Hack.CEN_Hack_TerminalHacked";
    Template.NarrativeMoments[15]="X2NarrativeMoments.TACTICAL.General.CEN_Gen_BurnoutSecured_02";
    Template.NarrativeMoments[16]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
    Template.NarrativeMoments[17]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroFailure";
    Template.NarrativeMoments[18]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroPartialSuccess";
    Template.NarrativeMoments[19]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroTotalSuccess";
    Template.NarrativeMoments[20]="X2NarrativeMoments.TACTICAL.General.GenTactical_TacWinOnly";
    Template.NarrativeMoments[21]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
	Template.NarrativeMoments[22]="X2NarrativeMoments.TACTICAL.RescueVIP.CEN_RescGEN_STObjAcquired"; //firebrand is unavailable for AO, clear out the area

    return Template;
}

// XPACK
static function X2MissionNarrativeTemplate AddTerrorEscapeTemplate()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'TerrorEscape');

    Template.MissionType = "TerrorEscape";
    Template.NarrativeMoments[0]="XPACK_NarrativeMoments.X2_XP_CEN_T_Covert_Escape_Squad Wipe";
    Template.NarrativeMoments[1]="XPACK_NarrativeMoments.X2_XP_CEN_T_Covert_Escape_Squad Extracted";
    Template.NarrativeMoments[2]="XPACK_NarrativeMoments.X2_XP_CEN_T_Covert_Escape_Partial Squad Recovery";
    Template.NarrativeMoments[3]="XPACK_NarrativeMoments.X2_XP_CEN_T_Covert_Escape_Operative Down";
    Template.NarrativeMoments[4]="XPACK_NarrativeMoments.X2_XP_CEN_T_Covert_Escape_Operative Dead";
    Template.NarrativeMoments[5]="XPACK_NarrativeMoments.X2_XP_CEN_T_Covert_Escape_Objective Indicated";
    Template.NarrativeMoments[6]="XPACK_NarrativeMoments.X2_XP_CEN_T_Covert_Escape_Mission Intro";
    Template.NarrativeMoments[7]="XPACK_NarrativeMoments.X2_XP_CEN_T_Covert_Escape_Many Enemies Reminder";
    Template.NarrativeMoments[8]="XPACK_NarrativeMoments.X2_XP_CEN_T_Covert_Escape_Last Operative";
    Template.NarrativeMoments[9]="XPACK_NarrativeMoments.X2_XP_CEN_T_Covert_Escape_Kill Captain";
    Template.NarrativeMoments[10]="XPACK_NarrativeMoments.X2_XP_CEN_T_Covert_Escape_Captain Dead";
    Template.NarrativeMoments[11]="X2NarrativeMoments.TACTICAL.Terror.Terror_SaveCompleteT1";
	Template.NarrativeMoments[12]="X2NarrativeMoments.TACTICAL.AvengerDefense.AvengerDefense_RNFFirst";

    return Template;
}


static function X2MissionNarrativeTemplate AddRMSabotageVIPNeutralizeTemplate()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'RM_Sabotage_Neutralize');

	Template.MissionType = "RM_Sabotage_Neutralize";
    Template.NarrativeMoments[0]="X2NarrativeMoments.TACTICAL.Neutralize.Neutralize_TacIntro";
    Template.NarrativeMoments[1]="X2NarrativeMoments.TACTICAL.Neutralize.Neutralize_VIPSpotted";
    Template.NarrativeMoments[2]="X2NarrativeMoments.TACTICAL.General.SKY_ExtrGEN_STObjSecured";
    Template.NarrativeMoments[3]="X2NarrativeMoments.TACTICAL.Neutralize.Neutralize_VIPKilledAfterCapture";
    Template.NarrativeMoments[4]="X2NarrativeMoments.TACTICAL.Neutralize.Neutralize_VIPExecuted";
    Template.NarrativeMoments[5]="X2NarrativeMoments.TACTICAL.Neutralize.CEN_Neut_TargetInCustody";
    Template.NarrativeMoments[6]="X2NarrativeMoments.TACTICAL.RescueVIP.Central_Rescue_VIP_TimerNagThree";
    Template.NarrativeMoments[7]="X2NarrativeMoments.TACTICAL.RescueVIP.Central_Rescue_VIP_TimerNagSix";
    Template.NarrativeMoments[8]="X2NarrativeMoments.TACTICAL.RescueVIP.Central_Rescue_VIP_TimerNagLast";
    Template.NarrativeMoments[9]="X2NarrativeMoments.TACTICAL.RescueVIP.Central_Rescue_VIP_TimerExpired";
    Template.NarrativeMoments[10]="X2NarrativeMoments.TACTICAL.RescueVIP.Central_Rescue_VIP_RNFInbound";
    Template.NarrativeMoments[11]="X2NarrativeMoments.TACTICAL.Neutralize.Neutralize_AdviseRetreat";
    Template.NarrativeMoments[12]="X2NarrativeMoments.TACTICAL.General.GenTactical_ConsiderRetreat";
    Template.NarrativeMoments[13]="X2NarrativeMoments.TACTICAL.Neutralize.Neutralize_SecureRetreat";
    Template.NarrativeMoments[14]="X2NarrativeMoments.TACTICAL.RescueVIP.Central_Rescue_VIP_EvacDestroyed";
    Template.NarrativeMoments[15]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
    Template.NarrativeMoments[16]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroFailure";
    Template.NarrativeMoments[17]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroPartialSuccess";
    Template.NarrativeMoments[18]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroTotalSuccess";
    Template.NarrativeMoments[19]="X2NarrativeMoments.TACTICAL.General.GenTactical_TacWinOnly";
    Template.NarrativeMoments[20]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
	Template.NarrativeMoments[21]="X2NarrativeMoments.TACTICAL.support.T_Support_Reminder_Knock_Out_VIP_Central_01";
    
    return Template;
}
static function X2MissionNarrativeTemplate AddEmergencyDefenseTemplarNarrativeTemplate()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'EmergencyDefense_Templars');

    Template.MissionType = "EmergencyDefense_Templars";
    Template.NarrativeMoments[0]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_VIP_Linked_Up";
    Template.NarrativeMoments[1]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_VIP_Extracted";
    Template.NarrativeMoments[2]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_VIP_Dead_Hold_For_EVAC";
    Template.NarrativeMoments[3]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_VIP_Dead_EVAC_Now";
    Template.NarrativeMoments[4]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_Squad_Wipe";
    Template.NarrativeMoments[5]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_Squad_Secure_VIP_Lost";
    Template.NarrativeMoments[6]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_Secured_VIP_Squad_Lost";
    Template.NarrativeMoments[7]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_Reinforcements_Dropping";
    Template.NarrativeMoments[8]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_No_EVAC_Reminder_Warning";
    Template.NarrativeMoments[9]="X2NarrativeMoments.TACTICAL.General.CEN_ExtrGEN_Intro_01";
    Template.NarrativeMoments[10]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_Mission_Accomplished";
    Template.NarrativeMoments[11]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_Faction_Soldier_Linked";
    Template.NarrativeMoments[12]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_EVAC_Remaining_Squad";
    Template.NarrativeMoments[13]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_EVAC_Is_Ready";
    Template.NarrativeMoments[14]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_EVAC_Compromised";
    Template.NarrativeMoments[15]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_Ambush_Begins";
    Template.NarrativeMoments[16]="X2NarrativeMoments.TACTICAL.Blacksite.Blacksite_SecureRetreat";

    return Template;
}


static function X2MissionNarrativeTemplate AddEmergencyDefenseReapersNarrativeTemplate()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'EmergencyDefense_Reapers');

    Template.MissionType = "EmergencyDefense_Reapers";
    Template.NarrativeMoments[0]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_VIP_Linked_Up";
    Template.NarrativeMoments[1]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_VIP_Extracted";
    Template.NarrativeMoments[2]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_VIP_Dead_Hold_For_EVAC";
    Template.NarrativeMoments[3]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_VIP_Dead_EVAC_Now";
    Template.NarrativeMoments[4]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_Squad_Wipe";
    Template.NarrativeMoments[5]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_Squad_Secure_VIP_Lost";
    Template.NarrativeMoments[6]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_Secured_VIP_Squad_Lost";
    Template.NarrativeMoments[7]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_Reinforcements_Dropping";
    Template.NarrativeMoments[8]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_No_EVAC_Reminder_Warning";
    Template.NarrativeMoments[9]="X2NarrativeMoments.TACTICAL.General.CEN_ExtrGEN_Intro_01";
    Template.NarrativeMoments[10]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_Mission_Accomplished";
    Template.NarrativeMoments[11]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_Faction_Soldier_Linked";
    Template.NarrativeMoments[12]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_EVAC_Remaining_Squad";
    Template.NarrativeMoments[13]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_EVAC_Is_Ready";
    Template.NarrativeMoments[14]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_EVAC_Compromised";
    Template.NarrativeMoments[15]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_Ambush_Begins";
    Template.NarrativeMoments[16]="X2NarrativeMoments.TACTICAL.Blacksite.Blacksite_SecureRetreat";

    return Template;
}


static function X2MissionNarrativeTemplate AddEmergencyDefenseSkirmisherNarrativeTemplate()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'EmergencyDefense_Skirmishers');

    Template.MissionType = "EmergencyDefense_Skirmishers";
    Template.NarrativeMoments[0]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_VIP_Linked_Up";
    Template.NarrativeMoments[1]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_VIP_Extracted";
    Template.NarrativeMoments[2]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_VIP_Dead_Hold_For_EVAC";
    Template.NarrativeMoments[3]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_VIP_Dead_EVAC_Now";
    Template.NarrativeMoments[4]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_Squad_Wipe";
    Template.NarrativeMoments[5]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_Squad_Secure_VIP_Lost";
    Template.NarrativeMoments[6]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_Secured_VIP_Squad_Lost";
    Template.NarrativeMoments[7]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_Reinforcements_Dropping";
    Template.NarrativeMoments[8]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_No_EVAC_Reminder_Warning";
    Template.NarrativeMoments[9]="X2NarrativeMoments.TACTICAL.General.CEN_ExtrGEN_Intro_01";
    Template.NarrativeMoments[10]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_Mission_Accomplished";
    Template.NarrativeMoments[11]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_Faction_Soldier_Linked";
    Template.NarrativeMoments[12]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_EVAC_Remaining_Squad";
    Template.NarrativeMoments[13]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_EVAC_Is_Ready";
    Template.NarrativeMoments[14]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_EVAC_Compromised";
    Template.NarrativeMoments[15]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_Ambush_Begins";
    Template.NarrativeMoments[16]="X2NarrativeMoments.TACTICAL.Blacksite.Blacksite_SecureRetreat";

    return Template;
}