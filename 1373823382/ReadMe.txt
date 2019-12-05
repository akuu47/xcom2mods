[h1] [WOTC] Extended Explosive Tweaks [/h1]
This is my personal mod for explosive environmental damage falloff, based on those mechanics from Long War 2. The core feature of this mod is that all explosive abilities that deal damage to an area will now do less damage to the environment based on distance from the center of the explosion. The WOTC Community Highlander is required. I recommend using this mod with the Precision Explosives advanced option, [WOTC] LW2 Classes and Perks, and [WOTC] LW2 Secondary Weapons to get the most out of it, but none of them are required.

[h1] Perks [/h1]
Adds two perks to the game, which may appear as Training Center abilities:
[list]
[*] Combat Engineer: Soldiers with this ability will deal the full amount of environment damage to an explosive's entire area of effect.
[*] Tandem Warheads: Soldiers with this ability will deal the full amount of damage to an explosive's entire area of effect. Will have no effect if Precision Explosives is not enabled.
[/list]

[h1] Features [/h1]
With the default settings, this mod will have the following effects:
[list]
[*] Environment damage falloff will be applied to all explosive abilities and items, in addition to the Shredder Gun, Shredstorm Cannon, and the Andromedon's Acid Blomb
[*] Environment damage falloff will be applied to the Gauntlet (from [WOTC] LW2 Secondary Weapons)
[*] Frag and Plasma grenades will destroy small cover on the tile that they are centered around, but will not destroy cover in the rest of the radius
[*] With the Sapper perk (from [WOTC] LW2 Classes and Perks), Frag and Plasma grenades will destroy medium cover on the tile that they are centered around, small cover in one tile beyond that, but will not destroy cover in the rest of the radius
[*] With the Combat Engineer perk, Frag and Plasma grenades will destory small cover in the entire area of effect
[*] With both Sapper and Combat Engineer, Frag and Plasma grenades will destory medium cover in the entire area of effect
[/list]

[h1] Installation [/h1]
This mod is best used when starting a new capaign, but will work on existing campaigns. However, the mod may not work properly until the next mission if the first save you load is during a mission. Also, Training Center abilities are rolled when a soldier is first created, so you probably won't see the Combat Engineer and Tandem Warheads perks on existing campaigns.

[h1] Configuration [/h1]
The .ini files have detailed comments describing how this mod can be configured. By reading the configs, you can set this mod up to function very closely to the damage falloff mechanics of LW2. They are located at TODO.

This DOES NOT port the unit damage falloff from LW2; it instead relies on Precision Explosives for that. The only change is that perks can be made that ignore the setting.

[h1] Compatibility [/h1]
Contains no class overrides, so no major conflicts there. This mod works by replacing the X2Effect_ApplyWeaponDamage effect of explosive area of effect abilities with a new X2Effect_ApplyExplosiveEnvironmentFalloffWeaponDamage effect. To my knowledge there aren't any other mods that are doing this, however if you do use another mod that replaces or makes changes to abilities' X2Effect_ApplyWeaponDamage effects, then this may not function correctly.

[h1] FAQs [/h1]
[b] Does this add the Combat Engineer and Tandem Warheads perks to the Grenadier and Technical classes in [WOTC] LW2 Classes and Perks? [/b]
No. This is easy to do yourself by modifying that mod's XComClassData.ini, and I do not want either of these mods to be dependant on one another. I may release a new class mod to bridge the gap if there's a lot of demand, but if I do, it will NOT be compatible with existing campaigns.

[h1] Usage [/h1]
Anyone is free to use anything in this mod for any project they'd like, as long as credit is given and money is not involved.

[h1] Credits [/h1]
Original design and implementation: Pavonis Interactive
War of the Chosen port and additional modifications: Favid
Preview image: .vhs
