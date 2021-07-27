--[[
	What is in a Trainer?
		Trainer Name
		ID
		Secret ID
		Badges
		Pokedollars
		Pokedex
		Various Gizmos to-be-listed (Pokenav, Pokegear, P*DA, C-Gear)
		Bag
		Party
		PC
		Purification Chamber
		Daycare Center
		
	What is in a Bag?
		Items
		Medicine
		Power-Up Pocket
		Candy Jar
		Poke Balls
		TMs/HMs/TRs
		Berries
		Mail
		Battle Items
		Key Items
		Mega Stones
		Z-Crystals
		Rotom Powers
		Treasure
		Free Space
		
		
	What is in a Party?
		Zero-Six ordered Pokemon
		
	What is in a PC?
		n Boxes
		Box names
		Box wallpapers
		30 Spaces for pokemon per box (ordered)
		
	What is in a purification chamber?
		n Purification slots
		Four normal pokemon per slot (ordered)
		One shadow pokemon per slot
		Tempo
		Progress
	
	What is in a daycare center?
		Cost to withdraw pokemon
		Two pokemon
		Egg

    What is in a Pokemon?
        Dex ID
        Pokemon Species
        Pokemon Subspecies (alternate forms)
        Type(s)
        Abilities
        Learnsets
        
        What about a specific pokemon (owned)?
            Checksum
            Personality Value
            Language
            Original Trainer
            Trainer ID
            Hidden ID
            Ball
            Nickname
            Markings
            Date Egg Received
            Date Met
            Met location
            Met level
            Caught/Hatched/Received
            Encounter Type
            Original Game
            Obedience
            Coolness
            Beauty
            Cuteness
            Smartness
            Toughness
            Feel
            Sheen
            Ribbons
            Nature
            IVs (Determines Hidden Power)
            IVs (Hypertrained)
            EVs
            Current Ability
            Current Moves
            Current Moves Max PP
            Shininess
            Friendship
            Level
            Experience
            Dynamax Level
            Pokerus status
            Held Item
            Status Condition
            Current HP
            Gender
            Shadow
			Heart Gauge
            Shiny Leaves
            Seals
            Seal Coordinates
--]]

local pokemon_pkhex_mappings = {
	["encryption_constant"] = "EncryptionConstant",
	["sanity"] = "Sanity",
	["checksum"] = "Checksum",
	["species"] = "Species",
	["held_item"] = "HeldItem",
	["trainer_id"] = "TID",
	["secret_id"] = "SID",
	["experience"] = "EXP",
	["ability"] = "Ability",
	["ability_number"] = "AbilityNumber",
	["favorite"] = "Favorite",
	["can_gigantamax"] = "CanGigantamax",
	["unused_23"] = "Unused_23",
	["mark_value"] = "MarkValue",
	["unused_26"] = "Unused_26",
	["unused_27"] = "Unused_27",
	["pokemon_id"] = "PID",
	["nature"] = "Nature",
	["stat_nature"] = "StatNature",
	["gender"] = "Gender",
	["fateful_encounter"] = "FatefulEncounter",
	["flag_2"] = "Flag2",
	["unused_35"] = "Unused_35",
	["form"] = "Form",
	["ev_hp"] = "EV_HP",
	["ev_attack"] = "EV_ATK",
	["ev_defense"] = "EV_DEF",
	["ev_speed"] = "EV_SPE",
	["ev_special_attack"] = "EV_SPA",
	["ev_special_defense"] = "EV_SPD",
	["contest_cool"] = "CNT_Cool",
	["contest_beauty"] = "CNT_Beauty",
	["contest_cute"] = "CNT_Cute",
	["contest_smart"] = "CNT_Smart",
	["contest_tough"] = "CNT_Tough",
	["contest_sheen"] = "CNT_Sheen",
	["pokerus_strain"] = "PKRS_Strain",
	["pokerus_days"] = "PKRS_Days",
	["pokerus"] = "PKRS",
	["unused_51"] = "Unused_51",
	["ribbon_training"] = "RibbonTraining",
	["ribbon_best_friends"] = "RibbonBestFriends",
	["ribbon_champion_gen_3"] = "RibbonChampionG3",
	["ribbon_champion_sinnoh"] = "RibbonChampionSinnoh",
	["ribbon_effort"] = "RibbonEffort",
	["ribbon_battler_expert"] = "RibbonBattlerExpert",
	["ribbon_battler_skillful"] = "RibbonBattlerSkillful",
	["ribbon_champion_kalos"] = "RibbonChampionKalos",
	["ribbon_gorgeous"] = "RibbonGorgeous",
	["ribbon_relax"] = "RibbonRelax",
	["ribbon_shock"] = "RibbonShock",
	["ribbon_careless"] = "RibbonCareless",
	["ribbon_smile"] = "RibbonSmile",
	["ribbon_alert"] = "RibbonAlert",
	["ribbon_downcast"] = "RibbonDowncast",
	["ribbon_snooze"] = "RibbonSnooze",
	["ribbon_country"] = "RibbonCountry",
	["ribbon_royal"] = "RibbonRoyal",
	["ribbon_gorgeous_royal"] = "RibbonGorgeousRoyal",
	["ribbon_footprint"] = "RibbonFootprint",
	["ribbon_artist"] = "RibbonArtist",
	["ribbon_record"] = "RibbonRecord",
	["ribbon_legend"] = "RibbonLegend",
	["ribbon_national"] = "RibbonNational",
	["ribbon_special"] = "RibbonSpecial",
	["ribbon_birthday"] = "RibbonBirthday",
	["ribbon_premier"] = "RibbonPremier",
	["ribbon_event"] = "RibbonEvent",
	["ribbon_classic"] = "RibbonClassic",
	["ribbon_world"] = "RibbonWorld",
	["ribbon_souvenir"] = "RibbonSouvenir",
	["ribbon_earth"] = "RibbonEarth",
	["ribbon_champion_battle"] = "RibbonChampionBattle",
	["ribbon_champion_world"] = "RibbonChampionWorld",
	["ribbon_champion_national"] = "RibbonChampionNational",
	["has_battle_memory_ribbon"] = "HasBattleMemoryRibbon",
	["ribbon_champion_regional"] = "RibbonChampionRegional",
	["has_contest_memory_ribbon"] = "HasContestMemoryRibbon",
	["ribbon_wishing"] = "RibbonWishing",
	["ribbon_champion_gen_6_hoenn"] = "RibbonChampionG6Hoenn",
	["ribbon_master_coolness"] = "RibbonMasterCoolness",
	["ribbon_champion_alola"] = "RibbonChampionAlola",
	["ribbon_contest_star"] = "RibbonContestStar",
	["ribbon_battle_royale"] = "RibbonBattleRoyale",
	["ribbon_master_cuteness"] = "RibbonMasterCuteness",
	["ribbon_master_cleverness"] = "RibbonMasterCleverness",
	["ribbon_master_toughness"] = "RibbonMasterToughness",
	["ribbon_master_beauty"] = "RibbonMasterBeauty",
	["ribbon_mark_sleepy_time"] = "RibbonMarkSleepyTime",
	["ribbon_master_rank"] = "RibbonMasterRank",
	["ribbon_battle_tree_master"] = "RibbonBattleTreeMaster",
	["ribbon_battle_tree_great"] = "RibbonBattleTreeGreat",
	["ribbon_mark_lunchtime"] = "RibbonMarkLunchtime",
	["ribbon_champion_galar"] = "RibbonChampionGalar",
	["ribbon_mark_dusk"] = "RibbonMarkDusk",
	["ribbon_tower_master"] = "RibbonTowerMaster",
	["ribbon_mark_dry"] = "RibbonMarkDry",
	["ribbon_mark_sandstorm"] = "RibbonMarkSandstorm",
	["ribbon_mark_cloudy"] = "RibbonMarkCloudy",
	["ribbon_mark_snowy"] = "RibbonMarkSnowy",
	["ribbon_mark_stormy"] = "RibbonMarkStormy",
	["ribbon_mark_rainy"] = "RibbonMarkRainy",
	["ribbon_mark_blizzard"] = "RibbonMarkBlizzard",
	["ribbon_mark_dawn"] = "RibbonMarkDawn",
	["ribbon_count_memory_contest"] = "RibbonCountMemoryContest",
	["ribbon_count_memory_battle"] = "RibbonCountMemoryBattle",
	["unused_62"] = "Unused_62",
	["unused_63"] = "Unused_63",
	["ribbon_mark_rowdy"] = "RibbonMarkRowdy",
	["ribbon_mark_absent_minded"] = "RibbonMarkAbsentMinded",
	["ribbon_mark_curry"] = "RibbonMarkCurry",
	["ribbon_mark_fishing"] = "RibbonMarkFishing",
	["ribbon_mark_uncommon"] = "RibbonMarkUncommon",
	["ribbon_mark_rare"] = "RibbonMarkRare",
	["ribbon_mark_destiny"] = "RibbonMarkDestiny",
	["ribbon_mark_misty"] = "RibbonMarkMisty",
	["ribbon_mark_intense"] = "RibbonMarkIntense",
	["ribbon_mark_excited"] = "RibbonMarkExcited",
	["ribbon_mark_calmness"] = "RibbonMarkCalmness",
	["ribbon_mark_angry"] = "RibbonMarkAngry",
	["ribbon_mark_zoned_out"] = "RibbonMarkZonedOut",
	["ribbon_mark_jittery"] = "RibbonMarkJittery",
	["ribbon_mark_joyful"] = "RibbonMarkJoyful",
	["ribbon_mark_charismatic"] = "RibbonMarkCharismatic",
	["ribbon_mark_crafty"] = "RibbonMarkCrafty",
	["ribbon_mark_smiley"] = "RibbonMarkSmiley",
	["ribbon_mark_peeved"] = "RibbonMarkPeeved",
	["ribbon_mark_teary"] = "RibbonMarkTeary",
	["ribbon_mark_upbeat"] = "RibbonMarkUpbeat",
	["ribbon_mark_ferocious"] = "RibbonMarkFerocious",
	["ribbon_mark_intellectual"] = "RibbonMarkIntellectual",
	["ribbon_mark_scowling"] = "RibbonMarkScowling",
	["ribbon_mark_pumped_up"] = "RibbonMarkPumpedUp",
	["ribbon_mark_unsure"] = "RibbonMarkUnsure",
	["ribbon_mark_humble"] = "RibbonMarkHumble",
	["ribbon_mark_zero_energy"] = "RibbonMarkZeroEnergy",
	["ribbon_mark_thorny"] = "RibbonMarkThorny",
	["ribbon_mark_prideful"] = "RibbonMarkPrideful",
	["ribbon_mark_kindly"] = "RibbonMarkKindly",
	["ribbon_mark_flustered"] = "RibbonMarkFlustered",
	["ribbon_mark_vigor"] = "RibbonMarkVigor",
	["ribbon_mark_slump"] = "RibbonMarkSlump",
	["ribbon_44_2"] = "RIB44_2",
	["ribbon_44_3"] = "RIB44_3",
	["ribbon_44_4"] = "RIB44_5",
	["ribbon_44_5"] = "RIB44_4",
	["ribbon_44_6"] = "RIB44_6",
	["ribbon_44_7"] = "RIB44_7",
	["ribbon_45_0"] = "RIB45_0",
	["ribbon_45_1"] = "RIB45_1",
	["ribbon_45_2"] = "RIB45_2",
	["ribbon_45_3"] = "RIB45_3",
	["ribbon_45_4"] = "RIB45_4",
	["ribbon_45_5"] = "RIB45_5",
	["ribbon_45_6"] = "RIB45_6",
	["ribbon_45_7"] = "RIB45_7",
	["ribbon_46_0"] = "RIB46_0",
	["ribbon_46_1"] = "RIB46_1",
	["ribbon_46_2"] = "RIB46_2",
	["ribbon_46_3"] = "RIB46_3",
	["ribbon_46_4"] = "RIB46_4",
	["ribbon_46_5"] = "RIB46_5",
	["ribbon_46_6"] = "RIB46_6",
	["ribbon_46_7"] = "RIB46_7",
	["ribbon_47_0"] = "RIB47_0",
	["ribbon_47_1"] = "RIB47_1",
	["ribbon_47_2"] = "RIB47_2",
	["ribbon_47_3"] = "RIB47_3",
	["ribbon_47_4"] = "RIB47_4",
	["ribbon_47_5"] = "RIB47_5",
	["ribbon_47_6"] = "RIB47_6",
	["ribbon_47_7"] = "RIB47_7",
	["sociability"] = "Sociability",
	["unused_"] = "Unused_76",
	["unused_"] = "Unused_77",
	["unused_"] = "Unused_78",
	["unused_"] = "Unused_79",
	["height_scalar"] = "HeightScalar", -- use for height?
	["weight_scalar"] = "WeightScalar", -- use for width?
	["unused_82"] = "Unused_82",
	["unused_83"] = "Unused_83",
	["unused_84"] = "Unused_84",
	["unused_85"] = "Unused_85",
	["unused_86"] = "Unused_86",
	["unused_87"] = "Unused_87",
	["nickname"] = "Nickname",
	["move_1"] = "Move1",
	["move_2"] = "Move2",
	["move_3"] = "Move3",
	["move_4"] = "Move4",
	["move_1_pp"] = "Move1_PP",
	["move_2_pp"] = "Move2_PP",
	["move_3_pp"] = "Move3_PP",
	["move_4_pp"] = "Move4_PP",
	["move_1_pp_ups"] = "Move1_PPUps",
	["move_2_pp_ups"] = "Move2_PPUps",
	["move_3_pp_ups"] = "Move3_PPUps",
	["move_4_pp_ups"] = "Move4_PPUps",
	["relearn_move_1"] = "RelearnMove1",
	["relearn_move_2"] = "RelearnMove2",
	["relearn_move_3"] = "RelearnMove3",
	["relearn_move_4"] = "RelearnMove4",
	["stat_HP_current"] = "Stat_HPCurrent",
	["iv32"] = "IV32",
	["iv_hp"] = "IV_HP",
	["iv_attack"] = "IV_ATK",
	["iv_defense"] = "IV_DEF",
	["iv_speed"] = "IV_SPE",
	["iv_special_attack"] = "IV_SPA",
	["iv_special_defense"] = "IV_SPD",
	["is_egg"] = "IsEgg",
	["is_nicknamed"] = "IsNicknamed",
	["dynamax_level"] = "DynamaxLevel",
	["unused_145"] = "Unused_145",
	["unused_146"] = "Unused_146",
	["unused_147"] = "Unused_147",
	["status_condition"] = "Status_Condition",
	["unknown_98"] = "Unk98",
	["unused_156"] = "Unused_156",
	["unused_157"] = "Unused_157",
	["unused_158"] = "Unused_158",
	["unused_159"] = "Unused_159",
	["unused_160"] = "Unused_160",
	["unused_161"] = "Unused_161",
	["unused_162"] = "Unused_162",
	["unused_163"] = "Unused_163",
	["unused_164"] = "Unused_164",
	["unused_165"] = "Unused_165",
	["unused_166"] = "Unused_166",
	["unused_167"] = "Unused_167",
	["previous_trainer_name"] = "HT_Name",
	["previous_trainer_gender"] = "HT_Gender",
	["previous_trainer_language"] = "HT_Language",
	["current_trainer"] = "CurrentHandler",
	["unused_197"] = "Unused_197",
	["previous_trainer_trainer_id"] = "HT_TrainerID",
	["previous_trainer_friendship"] = "HT_Friendship",
	["previous_trainer_intensity"] = "HT_Intensity",
	["previous_trainer_memory"] = "HT_Memory",
	["previous_trainer_feeling"] = "HT_Feeling",
	["previous_trainer_text_variant"] = "HT_TextVar",
	["unused_206"] = "Unused_206",
	["unused_207"] = "Unused_207",
	["unused_208"] = "Unused_208",
	["unused_209"] = "Unused_209",
	["unused_210"] = "Unused_210",
	["unused_211"] = "Unused_211",
	["unused_212"] = "Unused_212",
	["unused_213"] = "Unused_213",
	["unused_214"] = "Unused_214",
	["unused_215"] = "Unused_215",
	["unused_216"] = "Unused_216",
	["unused_217"] = "Unused_217",
	["unused_218"] = "Unused_218",
	["unused_219"] = "Unused_219",
	["fullness"] = "Fullness",
	["unused_220"] = "Unused_220",
	["enjoyment"] = "Enjoyment",
	["unused_221"] = "Unused_221",
	["version"] = "Version",
	["battle_version"] = "BattleVersion",
	["unused_224"] = "Unused_224",
	["unused_225"] = "Unused_225",
	["language"] = "Language",
	["unknown_3"] = "Unk3",
	["form_argument"] = "FormArgument",
	["form_argument_remain"] = "FormArgumentRemain",
	["form_argument_elapsed"] = "FormArgumentElapsed",
	["form_argument_maximum"] = "FormArgumentMaximum",
	["affixed_ribbon"] = "AffixedRibbon",
	["unused_233"] = "Unused_233",
	["unused_234"] = "Unused_234",
	["unused_235"] = "Unused_235",
	["unused_236"] = "Unused_236",
	["unused_237"] = "Unused_237",
	["unused_238"] = "Unused_238",
	["unused_239"] = "Unused_239",
	["unused_240"] = "Unused_240",
	["unused_241"] = "Unused_241",
	["unused_242"] = "Unused_242",
	["unused_243"] = "Unused_243",
	["unused_244"] = "Unused_244",
	["unused_245"] = "Unused_245",
	["unused_246"] = "Unused_246",
	["unused_247"] = "Unused_247",
	["original_trainer_name"] = "OT_Name",
	["original_trainer_friendship"] = "OT_Friendship",
	["original_trainer_intensity"] = "OT_Intensity",
	["original_trainer_memory"] = "OT_Memory",
	["unused_277"] = "Unused_277",
	["original_trainer_text_variant"] = "OT_TextVar",
	["original_trainer_feeling"] = "OT_Feeling",
	["egg_year"] = "Egg_Year",
	["egg_month"] = "Egg_Month",
	["egg_day"] = "Egg_Day",
	["met_year"] = "Met_Year",
	["met_month"] = "Met_Month",
	["met_day"] = "Met_Day",
	["unused_287"] = "Unused_287",
	["egg_location"] = "Egg_Location",
	["met_location"] = "Met_Location",
	["ball"] = "Ball",
	["met_level"] = "Met_Level",
	["original_trainer_gender"] = "OT_Gender",
	["hyper_training_flags"] = "HyperTrainFlags",
	["hyper_trained_hp"] = "HT_HP",
	["hyper_trained_attack"] = "HT_ATK",
	["hyper_trained_defense"] = "HT_DEF",
	["hyper_trained_speed"] = "HT_SPE",
	["hyper_trained_special_attack"] = "HT_SPA",
	["hyper_trained_special_defense"] = "HT_SPD",
	["move_record_flag"] = "MoveRecordFlag",
	["tracker"] = "Tracker",
	["unused_317"] = "Unused_317",
	["unused_318"] = "Unused_318",
	["unused_319"] = "Unused_319",
	["unused_320"] = "Unused_320",
	["unused_321"] = "Unused_321",
	["unused_322"] = "Unused_322",
	["unused_323"] = "Unused_323",
	["unused_324"] = "Unused_324",
	["unused_325"] = "Unused_325",
	["unused_326"] = "Unused_326",
	["unused_327"] = "Unused_327",
	["stat_level"] = "Stat_Level",
	["stat_hp_max"] = "Stat_HPMax",
	["stat_attack"] = "Stat_ATK",
	["stat_defense"] = "Stat_DEF",
	["stat_speed"] = "Stat_SPE",
	["stat_special_attack"] = "Stat_SPA",
	["stat_special_defense"] = "Stat_SPD",
	["dynamax_type"] = "DynamaxType",
}
