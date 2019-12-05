class X2Action_LostColor extends X2Action;

simulated state Executing
{
	function ColorLost()
	{
		local int i;
		local XComLinearColorPalette Palette, HairPalette;
		local LinearColor PrimaryColor, SecondaryColor, HairColor;
		Palette = XComLinearColorPalette(`CONTENT.RequestGameArchetype("Lost_Color_Palette.Lost_Palette"));
		HairPalette = `CONTENT.GetColorPalette(ePalette_HairColor);

		// Trick: To make sure the color stays the same when saving and loading,
		// just use the Unit's ObjectID as a pseudo-random source
		PrimaryColor = Palette.Entries[Unit.ObjectID % Palette.Entries.Length].Primary;
		SecondaryColor = Palette.Entries[(Unit.ObjectID + 30) % Palette.Entries.Length].Primary;
		HairColor = HairPalette.Entries[(Unit.ObjectID + 40) % HairPalette.Entries.Length].Primary;

		UpdateMaterials(UnitPawn.Mesh, PrimaryColor, SecondaryColor, HairColor);
		for (i = 0; i < UnitPawn.Mesh.Attachments.Length; i++)
		{
			if (MeshComponent(UnitPawn.Mesh.Attachments[i].Component) != none)
			{
				UpdateMaterials(MeshComponent(UnitPawn.Mesh.Attachments[i].Component), PrimaryColor, SecondaryColor, HairColor);
			}
		}
	}

	function UpdateMaterials(MeshComponent MeshComp, LinearColor Primary, LinearColor Secondary, LinearColor Hair)
	{
		local int i;
		local MaterialInstanceConstant MIC, NewMIC;
		for (i = 0; i < MeshComp.GetNumElements(); i++)
		{
			MIC = MaterialInstanceConstant(MeshComp.GetMaterial(i));
			if (MIC != none)
			{
				NewMIC = new (MIC) class'MaterialInstanceConstant';
				NewMIC.SetParent(MIC);
				MeshComp.SetMaterial(i, NewMIC);
				NewMIC.SetVectorParameterValue('Primary Color', Primary);
				NewMIC.SetVectorParameterValue('Secondary Color', Secondary);
				NewMIC.SetVectorParameterValue('HairColor', Hair);
				NewMIC.SetVectorParameterValue('Hair Color', Hair); // Beards
			}
		}
	}

Begin:
	ColorLost();
	CompleteAction();
}