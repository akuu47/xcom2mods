class Helmet_Tinter extends Object;

static function ApplyTint(XComHumanPawn Pawn, int iColorIndex) {
	local int i;
	local MaterialInstanceConstant MIC;
	local LinearColor Col;
	local XComLinearColorPalette Palette;

	// Get the Palette
	Palette = GetPalette();

	// Get the color
	Col = Palette.Entries[iColorIndex].Primary;

    for(i = 0; i < Pawn.m_kHelmetMC.Materials.Length; i++) {
        MIC = MaterialInstanceConstant(Pawn.HelmetContent.SkeletalMesh.Materials[i]);
		Switch(Mic.Name) {
			Case 'AAMAT_Visor':
			Case 'CommandoMat_Visor': 
			Case 'CQBMat_Visor':
			Case 'CQCMat_Visor':
			Case 'EODMat_Visor':
			Case 'EVA_SkullMat_Visor':
			Case 'EVAMat_Visor':
			Case 'GrenadierMat_Visor':
			Case 'GungnirMat_Visor':
			Case 'HazopMat_Visor':
			Case 'JFOMat_Visor':
			Case 'MKVBMat_Visor':
			Case 'MKVIMat_Visor':
			Case 'MKVMat_Visor':
			Case 'MPMat_Visor':
			Case 'ODSTMat_Visor':
			Case 'ODSTMat_VisorTransp':
			Case 'OperatorMat_Visor':
			Case 'PilotMat_Visor':
			Case 'ReconMat_Visor':
			Case 'ScoutMat_Visor':
			Case 'SecurityMat_Visor':
				SetNewMic(MIC, Pawn, Col, i);
				break;
			Default:
				break;
		}
	}
}

static function SetNewMic(MaterialInstanceConstant MIC, XComHumanPawn Pawn, LinearColor Col, int i) {
    local MaterialInstanceConstant NewMIC;
	
    NewMIC = new (Pawn) class'MaterialInstanceConstant';
    NewMIC.SetParent(MIC);
    Pawn.m_kHelmetMC.SetMaterial(i, NewMIC);
    MIC = NewMIC;          
    MIC.SetVectorParameterValue('VSRCLR', Col);
}

	static function XComLinearColorPalette GetPalette() {
		return XComLinearColorPalette(`CONTENT.LoadObjectFromContentPackage("HRHelmets.VisorColor"));
	}