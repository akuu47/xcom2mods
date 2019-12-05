[h1]𝐒𝐓𝐄𝐀𝐋𝐓𝐇𝐒 𝐌𝐄𝐂𝐇𝐀𝐍𝐈𝐂𝐒 𝐅𝐎𝐑 𝐀𝐋𝐋![/h1]

Musashis Stealth Overhaul is a meta mod that provides stealths gameplay mechanics for several of my mods.

Other mod authors are welcome to plugin in their mods if they want to provide stealth abilities/mechanics for their mods.

[h1]𝐇𝐎𝐖 𝐃𝐎𝐄𝐒 𝐓𝐇𝐄 𝐒𝐓𝐄𝐀𝐋𝐓𝐇 𝐌𝐄𝐂𝐇𝐀𝐍𝐈𝐂 𝐖𝐎𝐑𝐊?[/h1]

If the soldier is concealed and activates a valid stealth ability he has a chance to retain concealment.
This chance can be modified by a wide range of factors. Typically the ability has a base chance value.
E.g. Tactical Suppressors also get modified by the tier of the supressor and the weapon category.
Special abilities can also have an impact on the concealment loss chance.
The result of the test will be visualized via the reaper hud.

[h1]𝐒𝐎 𝐅𝐀𝐑 𝐓𝐇𝐈𝐒 𝐒𝐎𝐔𝐍𝐃𝐒 𝐋𝐈𝐊𝐄 𝐓𝐇𝐄 𝐑𝐄𝐀𝐏𝐄𝐑 𝐌𝐄𝐂𝐇𝐀𝐍𝐈𝐂. 𝐀𝐑𝐄 𝐓𝐇𝐄𝐑𝐄 𝐀𝐍𝐘 𝐃𝐈𝐅𝐅𝐄𝐑𝐄𝐍𝐂𝐄𝐒?[/h1]

Yes there are. 
For one there is [i]no[/i] reduced detection radius which shadow concealment grants reapers.

After determining all static concealment loss chance modifiers there are two dynamic components.
1.) When the stealth ability results in a kill the chance is halved.
2.) When the stealth ability results in a kill and there are no enemies around observing the kill the chance is flat 10%. 

Then there is another big difference: All squad members share a concealment loss value.
That means the last rolled concealment loss chance will be added as a base value for the next stealth attempt even if that is made by another soldier.

[h1]𝐒𝐓𝐄𝐀𝐋𝐓𝐇 𝐎𝐕𝐄𝐑𝐇𝐀𝐔𝐋 𝐅𝐎𝐑 𝐌𝐎𝐃𝐃𝐄𝐑𝐒[/h1]

I am a modder and want to use the Stealth Overhaul for a class/ability/whatever! How do i do that?

First you need to assign an effect with the name 'SilentKillEffect' to the unit.

This can be done within your own code or you simply can assign the Ability 'SilentKillPassive' to your class/weapon/item/whatever.

To make a special special stealth ability (e.g MyFancyStealthAbility) you need to create a XComStealthOverhaul.ini in your mod with the following entry:

[code]
[WotCStealthOverhaul.X2StealthOverhaul]
+StealthAbilities=(AbilityName=MyFancyStealthAbility)
[/code]

This is the minimum you need to define to make a stealth ability.
Per default it would use the ability templates 'SuperConcealmentLoss' value as base concealment loss chance for the stealth mechanic
However the StealthAbilities struct has some more properties you can define:

[code]
[table]
	[tr]
		[th]Type[/th]
        [th]Property[/th]
        [th]Description[/th]
		[th]default[/th]
    [/tr]
    [tr]
		[td]name[/td]
        [td]AbilityName[/td]
        [td]Name of the Ability Template[/td]
		[td]none[/td]
    [/tr]
	[tr]
		[td]int[/td]
        [td]ConcealmentLossOverride[/td]
        [td]Override SuperConcealmentLoss value of the ability template with this value[/td]
		[td]-1 (No override)[/td]
    [/tr]
	[tr]
		[td]bool[/td]
        [td]bIncreasesConcealmentLoss[/td]
        [td]Should the concealment check result be the new conceal base value[/td]
		[td]true[/td]
    [/tr]
	[tr]
		[td]bool[/td]
        [td]bAlwaysBreakConcealment[/td]
        [td]Should this ability always break concealment (no concealment loss check)*[/td]
		[td]false[/td]
    [/tr]
	[tr]
		[td]bool[/td]
        [td]bAlwaysKeepConcealment[/td]
        [td]Should this ability always retain concealment (no concealment loss check)*[/td]
		[td]false[/td]
    [/tr]
	[tr]
		[td]array<name>[/td]
        [td]ItemRequirements[/td]
        [td]Array of item template names that this ability need to be present[/td]
		[td]none[/td]
    [/tr]
	[tr]
		[td]array<name>[/td]
        [td]WeaponCategoryRequirements[/td]
        [td]Source Weapon must be one from this categories[/td]
		[td]none[/td]
    [/tr]
	[tr]
		[td]array<name>[/td]
        [td]WeaponAttachementRequirements[/td]
        [td]Special attachement(s) are needed to be present on the source weapon[/td]
		[td]none[/td]
    [/tr]
[/table]
[/code]

* Remark the Ability's EConcealmentRule and EAbilityHostility are respected, this switch is used for hard overrides of the normal behavior.

ATTENTION
THIS MODS NEEDS THE [b]X2WOTCCommunityHighlander[/b] TO WORK! WITHOUT IT YOUR GAME WILL CRASH!