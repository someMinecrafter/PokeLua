# PokeLua

 A completely shameless attempt to port Pokemon Showdowns simulator and dex to Lua (I will remove the CAP mons once this actually works since those were made for pokemon showdown.)
 
 The goal of this repository is to allow one to simulate most things that are possible in the games normally, in Lua.
 
 The reason for this is because Lua is easy and my use-case for the simulator would be as a script add-on to another game, since I was unhappy with the existing alternatives for it.
 
 I want to be able to do something like pokemon:create("Name/ID/name:space", specs...) to create any vanilla pokemon or any custom pokemon (defined in pokemon/mods/*).
 
 Then I want to be able to do something like pokemon:levelup() which would then do whatever happens on levelup, pokemon:attack(slot,target), pokemon:teach(tm/tr), pokemon:exp(int), pokemon:evs(ints), pokemon:use(item), pokemon:give(item), pokemon:take(), pokemon:deposit(), pokemon:withdraw(), pokemon:move(position), pokemon:breed(pokemon), pokemon:hatch(), pokemon:step() etc... (roughly)
 Very little thought has been put into this whole thing, feel free to leave any and all advice.
