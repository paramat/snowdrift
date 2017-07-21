#Snowdrift

Summary
1. Presentation
2. Current version
3. Licenses
4. Features
5. Technique
6. Dependencies
7. Installation
8. Bug and feedback


##1 Presentation

Snowdrift is a server friendly mod that add weather effects with their sound effects.
It avoid abm and useless calculations.


##2 Current version

**Your on a devellopement branch.**
**Perhaps your looking for the last release ?**
**Last release : v0.6.0**
**Tested with Minetest 0.4.13**
https://github.com/Spirita/snowdrift/releases/tag/v0.6.0


##3 Licenses
See license.md

* Source code
MIT by paramat
MIT by bell07
LGPL by Jeija (from minetest-mod-weather)
WTFPL by Spirita

* Media
1. Textures
All : CC BY-SA (3.0) by paramat

2. Sounds
  - snowdrift_rain : CC BY (3.0) by inchadney (http://freesound.org/people/inchadney/sounds/58835/)
  - cobratronik_wind_artic_cold : cc0 by cobratronik (https://freesound.org/people/cobratronik/sounds/117136/)


##4 Features

- Sometimes it rains !
- It will be snow if you are in a cold biome.
- Rain and snow make sound.


##5 Technique
- No abm, calculations proceed only if need
-> server friendly

- Calcul for each player using their position, not a global weather
-> more realistic

- Use the heat and the humidity of biomes, not the biomes names
-> compatible with mods that add biomes


##6 Dependencies
- default


##7 Installation

* Choose your version
 - Release (stable and tested version)
Try on paramat depot
https://github.com/paramat/snowdrift/releases

Or on Spirita depot
https://github.com/Spirita/snowdrift/releases/

 - Other version (at your own risk)
https://github.com/paramat/snowdrift/
https://github.com/Spirita/snowdrift/
Or on the other user branch or pull request.

* Instalation

2 ways :
 - with the zip
Download the zip of the release.
Uncompress it in your mods folder fot Minetest.
Rename it "snowdrift".

 - with git clone
Open a terminal and go in your mods folder fot Minetest.

'git clone <url>'


##8 Bug and feedback
https://forum.minetest.net/viewtopic.php?f=11&t=6854


