# Ambient Modules
By IR0NSIGHT
## Overview
Steam Workshop Link: https://steamcommunity.com/sharedfiles/filedetails/?id=2816705133 <br>
This mod adds modules to the ZEUS interface:
- Single airstrike
- Artillery barrage
- Cruise missile strike

### Single Airstrike
Place the module, select your parameters from the popup-dialog. A single plane will spawn at the edge of the map, flying over the modules position and releasing (scripted) bombs. The plane doesn't have to be able to carry the bombs. Flying altitude will cause a greater spread of the bombs, except if the bombcount = 1. Then the bomb is a guided one and will always precisely hit the target. The target position is selected once and not updated. 
The spawned plane will be engaged by enemies, select civilian to avoid that. After the target was bombed, the plane will return to the edge of the map and despawn.

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

### Ambient Airtraffic (planned)
This module will spawn ambient flybys, flying over the head of a random (non-flying) player. The flybys consist of 1 to 3 aircraft, the aircraft type is chosen randomly from a weighted list. These aircraft are 100% ambient, they will not engage anyone and will not be engaged by AI. 

### Ambient FLAK (planned)
This module will turn an AA vehicle into ambient FLAK fire. The unit will engage any enemy aircraft with a given radius with large volleys of anti-air fire. The shots will miss the aircraft on purpose. This way player controlled aircraft are suppressed but not endangered. It can always be used to provide authentic background scenery for nearby groundtroops.
The module offers a "hybrid" mode. In hybrid mode, the AA gun will switch to deadly fire if the aircraft comes to close.
The AA volleys are real bullets, and can still be dangerous. Flying right towards the AA gun might cause loss of aircraft, even in ambient mode.

### Instant explosion (planned)
This module will spawn a 50m kill-radius explosion right at the modules position.


## Editor modules (planned)
all zeus modules are available as editor modules.

## Scripting interface
All functions are documented in @Ambient Modules workspace\addons\IRN_AmbientModules\functions
