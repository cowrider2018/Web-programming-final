scoreboard objectives add log_searching dummy
scoreboard objectives add cut_down_trees_check dummy

execute unless entity @e[distance=..1,tag=1stlog] run kill @e[type=armor_stand,tag=log]

execute if block ~ ~ ~ minecraft:oak_log run summon armor_stand ~ ~ ~ {Tags:["1stlog","log"],Small:1,NoGravity:1,Invisible:1}
execute if block ~ ~ ~ minecraft:birch_log run summon armor_stand ~ ~ ~ {Tags:["1stlog","log"],Small:1,NoGravity:1,Invisible:1}
execute if block ~ ~ ~ minecraft:spruce_log run summon armor_stand ~ ~ ~ {Tags:["1stlog","log"],Small:1,NoGravity:1,Invisible:1}
execute if block ~ ~ ~ minecraft:jungle_log run summon armor_stand ~ ~ ~ {Tags:["1stlog","log"],Small:1,NoGravity:1,Invisible:1}
execute if block ~ ~ ~ minecraft:acacia_log run summon armor_stand ~ ~ ~ {Tags:["1stlog","log"],Small:1,NoGravity:1,Invisible:1}
execute if block ~ ~ ~ minecraft:dark_oak_log run summon armor_stand ~ ~ ~ {Tags:["1stlog","log"],Small:1,NoGravity:1,Invisible:1}
execute if block ~ ~ ~ minecraft:mangrove_log run summon armor_stand ~ ~ ~ {Tags:["1stlog","log"],Small:1,NoGravity:1,Invisible:1}
execute if block ~ ~ ~ minecraft:cherry_log run summon armor_stand ~ ~ ~ {Tags:["1stlog","log"],Small:1,NoGravity:1,Invisible:1}

scoreboard players set @e[tag=1stlog] cut_down_trees_check 0

execute if block ~ ~ ~ minecraft:oak_log run function cut_down_trees:oak_marking
execute if block ~ ~ ~ minecraft:birch_log run function cut_down_trees:birch_marking
execute if block ~ ~ ~ minecraft:spruce_log run function cut_down_trees:spruce_marking
execute if block ~ ~ ~ minecraft:jungle_log run function cut_down_trees:jungle_marking
execute if block ~ ~ ~ minecraft:acacia_log run function cut_down_trees:acacia_marking
execute if block ~ ~ ~ minecraft:dark_oak_log run function cut_down_trees:dark_oak_marking
execute if block ~ ~ ~ minecraft:mangrove_log run function cut_down_trees:mangrove_marking
execute if block ~ ~ ~ minecraft:cherry_log run function cut_down_trees:cherry_marking





