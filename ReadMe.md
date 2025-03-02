# Ambient Modules
By IR0NSIGHT
## Overview
Steam Workshop Link: https://steamcommunity.com/sharedfiles/filedetails/?id=2816705133
[url=https://github.com/IR0NSIGHT/AmbientModules]GITHUB[/url]

This mod adds modules to the ZEUS interface and the 3den Editor:
- Single airstrike
- Artillery barrage
- Cruise missile strike
- Ambient Airtraffic
- Ambient Anti-Air fire
- Sniper Anti-Air fire (eden only)
- random Anti-Air fire
- stabilize patient

### Single Airstrike
Place the module, select your parameters from the popup-dialog. A single plane will spawn at the edge of the map, flying over the modules position and releasing (scripted) bombs. The plane doesn't have to be able to carry the bombs. Flying altitude will cause a greater spread of the bombs, except if the bombcount = 1. Then the bomb is a guided one and will always precisely hit the target. The target position is selected once and not updated. 
The spawned plane will be engaged by enemies, select civilian to avoid that. After the target was bombed, the plane will return to the edge of the map and despawn.
If you experience your planes refusing to leave the area, it might be because the plane detected enemies and tries to engage them. use side civilian next time to avoid that.

### Artillery Barrage
This module allows to bombard a circular or rectangular area around the module position. You can select from a variety of projectile type, choose the duration, radius and intensity of the bombardment. The impact positions are distributed randomly but uniformly across the area. Choose a delay time to simulated far away artillery firing.
The outline arrows only appear to the zeus and only if the anchor object is selected. Delete the anchor to end the artillery fire immediately.
Possible usage: illuminate a battlefield; high intensity bursts of mortar fire; Smoke an area to cover an attack; Bombard a city; Suppress/Slow an enemy attack with widespread mortar fire; etc 
Showcase video:
https://youtu.be/vF5dLML7H18

### Cruise missile
This module will spawn a cruise missile, targetting the modules position. The missile will follow terrain and impact precisely at the modules position. Extreme terrain, like high, vertical cliffs, might prove difficult for the missile to cross when flying at low altitudes. 
Altitudes below 200m will skim the terrain at given altitude and skim the sea at 1/4 altitude. Altitudes above 200m will fly at constant height above sea level, and only skim terrain if necessary to avoid collision.
The missile will launch vertically upwards from its spawn position. The spawn position should be 10 meters away from any obstacles to avoid explosion of the missile upon spawning.
Showcase Video:
https://www.youtube.com/watch?v=qHyAr0hJ_2A

### Ambient Airtraffic 
This module will spawn ambient flybys, flying over the head of a random (slow-moving, <15m/s) player. 
In the Zeus dialog, the planeclasses, weights and maximum squadsizes can be chosen. the aircraft type is chosen randomly from a weighted list. These aircraft are 100% ambient, they will not engage anyone and will not be engaged by AI. 
The airtraffic will stop after the selected amount of minutes, or if the helper object is deleted.
Intended use: Bring life to the skies on missions where one side has total air-superiority, f.e. Afghanistan Patrol Missions

Eden module: find class names of planes (rightclick plane, log class, requires eden enhanced mod). put into string array.
module is trigger activated or directly active if no trigger is synced.

### Ambient Anti Air fire
Place the module on a AA unit that uses cannons (missiles not supported). The unit will now engage all enemy aircraft with wild and aggressive fire, but will not hit them.
Optional: Set a lethal range where the AA unit switches to deadly fire if the aircraft get to close.
Meant to create immersive fire, mostly for hot heli insertions/extractions without endangering the pilots
https://youtu.be/VccGZs8KudA

### Sniper Anti Air fire
Eden module will make synched units instantly detect all aircraft within 2kms. Units will try to engage asap.
Works for all types of units: Missiles, Cannon, etc.

### Random Anti Air fire
Place the module in 3den Editor and sync it to your AA units. Can be anything that can shoot. Each unit will spawn their own invisible target that moves and will try to engage it. The target is NOT a radar target, so radar guided missiles cant engage it.

## Stabilize patient
heals the unit, then deals 5 bullet damage. Use for players who got totally shredded in order to save them from death and save time for the medic without anyone noticing.
