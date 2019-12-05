An unchained AI for the Chosen. As usual, this also includes some gameplay changes to accomodate balance and smarten up the AI.

Please note that this AI is unfair in a sense, it is considered a difficulty mod. It does not cheat however.

-= ALL CHOSEN =-
- All chosen have 3 Action Points like a Sectopod.
- All Chosen now behave very intelligently in battle, expect to be punished for playing badly (dont stay flanked).
- Most chosen do not end their turn when firing.
- The Chosen have a chance to daze you then abduct you in the same round. This is not systematic, you'd have to make great tactical mistakes for this to happen. Keep a good distance at all times. You could also be unlucky, but then again, this is XCOM.

-= CHOSEN HUNTER =-
- No longer uses the lame Tracking Shot. Instead, the Hunter now gets to use Longwatch. Since he has unlimited vision, this means the entire board is threatened if there are no walls (which is almost never the case).
- Chosen pistol actions do not end the turn (Quickdraw). This includes Tranq Shot.
- The hunter gets Cool Under Pressure and Guardian. I strongly suggest while he is on the map and semi-active to watch your step. The flyover will show where he is however to give you a generic sense of where not to step. You should adapt to this change.
- The Chosen Sniper requires 2 AP to operate, whether its held by XCOM or the Hunter.
- The Chosen Sniper will hang back, but not in a stupid inactive way.
- The Chosen Sniper IS CAPABLE of firing from the fog of war instead of Longwatching, mostly if you leave yourself WITHOUT COVER. This is a normal punishment mechanism.

-= CHOSEN ASSASSIN =-
- Parting silk no longer automatically hits. It does however have a strong positive bonus to hit, which means you can defend against it.
- The assassin will start the game and then immediately chase you down. She is the most aggressive of all 3.
- The assassin now remembers that she is carrying a giant shotgun, and will start using it accordingly.
- The assassin has no qualms with just starting the round invisible, swording an XCOM unit, moving to cover then shotguning it. Youve been warned.
- Parting Silk has a 1 turn cooldown, the Assassin cannot melee multiple times in the same round (that would be crazy overpowered).

-= CHOSEN WARLOCK =-
- The Warlock just realized he is carring a gigantic rifle, and will start to use it intelligently.
- The Warlock no longer just stands back and zombies you to death, he will chase you down from the start (at about half the rate of the assassin). He will still zombie occasionally.
- The Warlock was given Cool Under Pressure and Guardian. Honestly if you get hit by his Overwatch, you deserve to just die right there. It's easy to counter, stay attentive.

-= LIMITATIONS AND BUGS =-
- Vanish sometimes does not remove itself when the Assassin is flanked before she makes her speech. This is somewhat alleviated with my "reveal at the start" code which forces the Engaged behavior. It can still happen.
- The Chosen have the same behavior against The Lost than before. This is likely going to be fixed in future releases if the Chosen are found to behave poorly in a 3-team scenario.

-= SOME COUNTERS =-
Need advice to fight the new AI?

Chosen Assassin: Scanning Protocol, Battlescanners, Bladestorm. She is very aggressive and hot headed just like the videos, you can bait her to come to you. I'm sure you can lay an Overwatch trap, but you have to be clever because she will not simply walk into an overwatching squad. She's very fragile because of her melee and is easy to flank.
Chosen Hunter: Shadowstep, Lightning Reflexes, Aid Protocol + Dash. The Hunter is weak against a full XCOM team, but is strong acompanied. Clean up the soldiers first before taking him on. Also, keep high ground and stay out of sight, force him to move.
Chosen Warlock: Mind Shield. The Warlock is straightforward, dont make big mistakes and you should be fine. He is the most average of the 3. When the Warlock finishes Spectral Army or Sustain ends, you really shouldnt stay close to him or risk getting kidnapped. Stay one and a half movement away minimum at all times.

-= BUGFIXES =-
- The Warlock will (hopefully) no longer teleport a unit that is suppressed or is suppressing something.
- The targeting AOE of all chosen is mostly improved.

-= BUG REPORTS =-
- It is very difficult to playtest the chosen properly, please report any weird behavior or anything that doesnt work.

-= KNOWN ISSUES =-
HUNTER SHOOTS PISTOL FROM WAY TOO FAR
This is a base game bug with Farsight and the game not checking correctly if it has non-zero aim also. This cannot be fixed with an AI patch. I have however tried my best to make the Hunter not fire from outside his range in my New Range Tables mod by giving him -100 at 18 or more tiles. He will still shoot civilians with his pistol 2 screens away. Firaxis attempted to fix this by giving the Pistol a fixed range, but from tests this value is totally ignored. If the Hunter is Pistol Overwatching, it will trigger from outside of his range also (and miss probably).

CHOSEN IN GENERAL DO NOT BENEFIT FROM HEADSHOT THE LOST
Can't be fixed here, it's unfortunate. Headshot is also not a separate ability, it's been implemented in a hacky way which makes it not fixable easily by simply giving the Headshot ability to the Chosen (because that ability doesnt exist).

HELP I GET KIDNAPPED/EXTRACTED A LOT
This is actually not an issue, it's just that the base game Chosen didn't do it much. You should be prepared at all times and keep your distance. In order to help you just a bit, the Chosen Hunter doesn't have 100% chance to hit with Tranq Shot anymore (but it's still pretty high) and the Warlock will not open with MindScorch on his first action always. Also, bring some Mind Shields or Solace. Abductions are an integral part of the Chosen mechanism, and they are not much of a threat if it never happens.

-= MOD REQUIREMENTS =-
The list mods are not OBLIGATORY, but they all work in synergy. You can use this mod independently, but i listed the mods for completeness.

-= COMPATIBILITY =-
Not compatible with other Chosen AI mods. 
Probably compatible with ABA, i dont think it has Chosen AI in it.
Compatible with my Additional Enemy Perks, this further increases Chosen power.
Incompatible with Dynamic Pod Activation.

-= VERSION =-
ChosenAI V1.24 15-11-2017 Assassin Fixes