execute as @e[tag=log] at @s run tag @s add leaf

execute at @e[tag=leaf] run execute run summon armor_stand ~1 ~-1 ~ {Tags:["check"],Small:1,NoGravity:1,Invisible:1}
execute at @e[tag=leaf] run execute run summon armor_stand ~1 ~-1 ~1 {Tags:["check"],Small:1,NoGravity:1,Invisible:1}
execute at @e[tag=leaf] run execute run summon armor_stand ~1 ~-1 ~-1 {Tags:["check"],Small:1,NoGravity:1,Invisible:1}
execute at @e[tag=leaf] run execute run summon armor_stand ~ ~-1 ~ {Tags:["check"],Small:1,NoGravity:1,Invisible:1}
execute at @e[tag=leaf] run execute run summon armor_stand ~ ~-1 ~1 {Tags:["check"],Small:1,NoGravity:1,Invisible:1}
execute at @e[tag=leaf] run execute run summon armor_stand ~ ~-1 ~-1 {Tags:["check"],Small:1,NoGravity:1,Invisible:1}
execute at @e[tag=leaf] run execute run summon armor_stand ~-1 ~-1 ~ {Tags:["check"],Small:1,NoGravity:1,Invisible:1}
execute at @e[tag=leaf] run execute run summon armor_stand ~-1 ~-1 ~1 {Tags:["check"],Small:1,NoGravity:1,Invisible:1}
execute at @e[tag=leaf] run execute run summon armor_stand ~-1 ~-1 ~-1 {Tags:["check"],Small:1,NoGravity:1,Invisible:1}
execute at @e[tag=leaf] run execute run summon armor_stand ~ ~ ~1 {Tags:["check"],Small:1,NoGravity:1,Invisible:1}
execute at @e[tag=leaf] run execute run summon armor_stand ~ ~ ~-1 {Tags:["check"],Small:1,NoGravity:1,Invisible:1}
execute at @e[tag=leaf] run execute run summon armor_stand ~1 ~ ~ {Tags:["check"],Small:1,NoGravity:1,Invisible:1}
execute at @e[tag=leaf] run execute run summon armor_stand ~-1 ~- ~ {Tags:["check"],Small:1,NoGravity:1,Invisible:1}

execute as @e[type=armor_stand,tag=leaf] at @s run execute if entity @e[type=armor_stand,distance=..0.5,tag=check] run tag @s remove leaf

kill @e[type=armor_stand,tag=check]

execute as @e[tag=leaf] at @s run execute unless block ~ ~1 ~ minecraft:mangrove_leaves run kill @e[tag=log]

execute as @e[tag=leaf] at @s run execute if block ~ ~1 ~ minecraft:mangrove_leaves run function cut_down_trees:mangrove_destroy
