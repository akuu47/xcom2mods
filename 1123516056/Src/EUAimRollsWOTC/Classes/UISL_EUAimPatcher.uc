class UISL_EUAimPatcher extends UIScreenListener config(AimRoll);

var config array<name> ABILITY_AIM;
var config array<name> ABILITY_AIM_OWNERONMISS;
var config array<name> MELEE_AIM;

var bool isPatched;

event OnInit(UIScreen Screen)
{
	local X2AbilityTemplateManager			AbilityTemplateManager;
	local X2AbilityTemplate					AbilityTemplate;
	local name								AbilityName;

	if (isPatched)
		return;
	
	// Locate each ability template
	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	foreach ABILITY_AIM(AbilityName)
	{
		AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(AbilityName);
		if (AbilityTemplate == none)
		{
			`log("Ability not found:" @ AbilityName,, 'EUAimRoll');
			continue;
		}
		else
		{
			`log("Ability patched:" @ AbilityName,, 'EUAimRoll');
		}
		AbilityTemplate.AbilityToHitCalc = new class'OldAimRoll';
	}
	`log("AbilityToHitCalc patched",, 'EUAimRoll');

	foreach ABILITY_AIM_OWNERONMISS(AbilityName)
	{
		AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(AbilityName);
		if (AbilityTemplate == none)
		{
			`log("Ability not found:" @ AbilityName,, 'EUAimRoll');
			continue;
		}
		else
		{
			`log("Ability patched:" @ AbilityName,, 'EUAimRoll');
		}
		AbilityTemplate.AbilityToHitOwnerOnMissCalc = new class'OldAimRoll';
	}
	`log("AbilityToHitOwnerOnMissCalc patched",, 'EUAimRoll');

	isPatched = true;
	`log("All abilities patched",, 'EUAimRoll');

	foreach MELEE_AIM(AbilityName)
	{
		AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(AbilityName);
		if (AbilityTemplate == none)
		{
			`log("Ability not found:" @ AbilityName,, 'EUAimRoll');
			continue;
		}
		else
		{
			`log("Ability patched:" @ AbilityName,, 'EUAimRoll');
		}
		AbilityTemplate.AbilityToHitCalc = new class'OldAimRoll_Melee';
	}

	if (class'OldAimRoll'.default.DIRTY_CINEMATIC && class'OldAimRoll'.default.SHOW_CHANCES)
	{
		foreach class'OldAimRoll'.default.OVERWATCH_ABILITIES(AbilityName)
		{
			AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(AbilityName);
			if (AbilityTemplate == none)
			{
				`log("Ability not found:" @ AbilityName,, 'EUAimRoll');
				continue;
			}
			else
			{
				`log("Ability patched for PI:" @ AbilityName,, 'EUAimRoll');
			}
			AbilityTemplate.ActionFireClass = class'X2Action_FIrePI';
		}
	}

	// Making all abilities notify OnHit
	//foreach AbilityTemplateManager.IterateTemplates(Template, none)
	//{
		//AbilityTemplate = X2AbilityTemplate(Template);
		//if (AbilityTemplate != none && (OldAimRoll(AbilityTemplate.AbilityToHitCalc) != none || OldAimRoll_Melee(AbilityTemplate.AbilityToHitCalc) != none))
		//{
			//AbilityTemplate.AddShooterEffect(new class'X2Effect_DisplayHitChance');
			//`log("Patched notifier Effect" @ AbilityTemplate.DataName,, 'EUAimRoll');
		//}
	//}

	`log("AbilityToHitCalc_Melee patched",, 'EUAimRoll');
}

defaultproperties
{
	isPatched = false;
    ScreenClass = none;
}

