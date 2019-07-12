# Minerva

The *Multiplatform Interface that Notably Enhances the Research of Videogame Attributes* (or **Minerva**) is a Lua project that is meant to assist the process of reverse-engineering and live debugging of classic videogames by running existing or custom scripts in emulators that support Lua scripting (such as Gens or Bizhawk). 

In-built standard scripts are included as `std_*.lua` files in `\scripts\` and include:
* Object Status Table display.
* Precise pixel/subpixel manipulation.
* Seamless activation/deactivation of in-game debugging functions.
* Rewinding.

Native support is provided for the following games:
* Sonic the Hedgehog (16-bit) (`scr_s1`)
* Sonic the Hedgehog 2 (16-bit) (`scr_s2`)
* Sonic 3 & Knuckles (`scr_s3k`)

As well as the following emulators:
* Bizhawk (`emu_bizhawk`)
* Gens (`emu_gens`)

To load a particular game script, open `environment.lua` and replace the line `game = scr_...` with the name of the file of the game you want to run, usually a `scr_` file. Please do not include `.lua`.

To load a particular emulator, open `environment.lua` and replace the line `emu = emu_...` with the name of the file of the emulator you want to run, usually a `emu_` file. Please do not include `.lua`.

If you have any questions, please contact the author on Discord (Chrezm#2889).

Happy sciencing!