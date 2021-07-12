# PokeLua

 A completely shameless attempt to port Pokemon Showdowns simulator and data to Lua (I will remove the CAP mons once this actually works since those were made for pokemon showdown.)
 
 The goal of this repository is to allow one to simulate most things that are possible in the games normally, in Lua.
 
 The reason for this is because Lua is easy and my use-case for the simulator would be as a script add-on to another game, since I was unhappy with the existing alternatives for it (pokemon).
 
 I want to be able to do something like pokemon:create("Name/ID/name:space", specs...) to create any vanilla pokemon or any custom pokemon (defined in pokemon/mods/*).
 
 Then I want to be able to do something like pokemon:levelup() which would then do whatever happens on levelup, pokemon:attack(slot,target), pokemon:teach(tm/tr), pokemon:onvictory(), pokemon:ondefeat(), pokemon:exp(int), pokemon:evs(ints), pokemon:use(item), pokemon:give(item), pokemon:take(), pokemon:deposit(), pokemon:withdraw(), pokemon:move(position), pokemon:breed(pokemon), pokemon:hatch(), pokemon:step() etc... (roughly, maybe party or pc in some of them)
 Very little thought has been put into this whole thing, feel free to leave any and all advice.
 
 I might as well start a list of features I want:
	.pk8 serializer/deserializer/reader/writer whatever, I want to be able to both import and export pokemon, and ideally I want pokemon generated with this program to be legal as of the version of RNG in use (or as close to it as I can sensibly get). At a minimum it should be able to import a legal pokemon, level it up, then export it exactly as it was, only with the level having gone up. (or any other stat/move changes).
	
	full battle/levelling/daycare/contest/shadow/etc system
	
	custom definable mons
	
	models and sounds to pull from (even just ms paint drawings as placeholders would be good enough, just have to get the naming convention to be good enough)
	
