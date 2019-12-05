class X2MissionNarrative_NarrativeSet_PrisonBreak extends X2MissionNarrative;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2MissionNarrativeTemplate> Templates;

    Templates.AddItem(AddDefaultPrisonBreakRescueNarrativeTemplate());  

    return Templates;
}

static function X2MissionNarrativeTemplate AddDefaultPrisonBreakRescueNarrativeTemplate(optional name TemplateName = 'DefaultCompoundPrisonBreak')
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, TemplateName);

    Template.MissionType = "CompoundPrisonBreak";
    Template.NarrativeMoments[0]="XPACK_NarrativeMoments.X2_XP_CEN_T_Comp_Rescue_Transport_Inbound";
    Template.NarrativeMoments[1]="XPACK_NarrativeMoments.X2_XP_CEN_T_Comp_Rescue_Squad_Wipe";
    Template.NarrativeMoments[2]="XPACK_NarrativeMoments.X2_XP_CEN_T_Comp_Rescue_Operative_Recovered_Squad_Wipe";
    Template.NarrativeMoments[3]="XPACK_NarrativeMoments.X2_XP_CEN_T_Comp_Rescue_Operative_Recovered_Heavy_Losses";
    Template.NarrativeMoments[4]="XPACK_NarrativeMoments.X2_XP_CEN_T_Comp_Rescue_Operative_Not_Recovered";
    Template.NarrativeMoments[5]="XPACK_NarrativeMoments.X2_XP_CEN_T_Comp_Rescue_Mission_Intro";
    Template.NarrativeMoments[6]="XPACK_NarrativeMoments.X2_XP_CEN_T_Comp_Rescue_Mission_Accomplished";
    Template.NarrativeMoments[7]="XPACK_NarrativeMoments.X2_XP_CEN_T_Comp_Rescue_Firebrand_In_Position";
    Template.NarrativeMoments[8]="XPACK_NarrativeMoments.X2_XP_CEN_T_Comp_Rescue_Firebrand_On_Standby";
    Template.NarrativeMoments[9]="XPACK_NarrativeMoments.X2_XP_CEN_T_Comp_Rescue_Comp_On_Alert";
    Template.NarrativeMoments[10]="XPACK_NarrativeMoments.X2_XP_CEN_T_Comp_Rescue_Comp_Maximum_Alert";
    Template.NarrativeMoments[11]="XPACK_NarrativeMoments.X2_XP_CEN_T_Comp_Rescue_Alert_Status_Increaing";
    Template.NarrativeMoments[12]="X2NarrativeMoments.TACTICAL.AvengerDefense.AvengerDefense_RNFFirst";
    Template.NarrativeMoments[13]="XPACK_NarrativeMoments.X2_XP_CEN_T_Swarm_EVAC_Is_Ready";
    Template.NarrativeMoments[14]="XPACK_NarrativeMoments.X2_XP_CEN_T_Gather_Survivors_EVAC_Point_Indicated";

    return Template;
}