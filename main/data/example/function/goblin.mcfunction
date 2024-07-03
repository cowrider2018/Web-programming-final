scoreboard objectives add goblin_life dummy
team add goblin
team join goblin @s

scoreboard objectives add motion_x dummy
scoreboard objectives add motion_y dummy
scoreboard objectives add motion_z dummy

scoreboard objectives add pos_x dummy
scoreboard objectives add pos_y dummy
scoreboard objectives add pos_z dummy

execute as @e[type=minecraft:arrow,distance=..5,nbt=!{inGround:true}] store result score @s motion_x run data get entity @s Motion[0] 10000
execute as @e[type=minecraft:arrow,distance=..5,nbt=!{inGround:true}] store result score @s motion_y run data get entity @s Motion[1] 10000
execute as @e[type=minecraft:arrow,distance=..5,nbt=!{inGround:true}] store result score @s motion_z run data get entity @s Motion[2] 10000

execute as @e[type=minecraft:arrow,distance=..5,nbt=!{inGround:true}] store result score @s pos_x run data get entity @s Pos[0] 10000
execute as @e[type=minecraft:arrow,distance=..5,nbt=!{inGround:true}] store result score @s pos_y run data get entity @s Pos[1] 10000
execute as @e[type=minecraft:arrow,distance=..5,nbt=!{inGround:true}] store result score @s pos_z run data get entity @s Pos[2] 10000

execute as @e[type=minecraft:arrow,distance=..5,nbt=!{inGround:true}] run scoreboard players operation @s motion_x += @s pos_x
execute as @e[type=minecraft:arrow,distance=..5,nbt=!{inGround:true}] run scoreboard players operation @s motion_y += @s pos_y
execute as @e[type=minecraft:arrow,distance=..5,nbt=!{inGround:true}] run scoreboard players operation @s motion_z += @s pos_z

execute at @e[type=minecraft:arrow,distance=..5,nbt=!{inGround:true}] run summon minecraft:piglin ~ ~-2 ~ {IsBaby:false,Tags:["goblin"],attributes:[{id:"minecraft:generic.scale",base:0.6}],DeathLootTable:"empty",Team:"goblin",ArmorItems:[{},{Count:1b,id:"leather_leggings"},{},{}],Brain:{memories:{"minecraft:admiring_disabled":{value:1,ttl:200}}},HandItems:[{id:"minecraft:stick"},{}]}

execute as @e[type=minecraft:arrow,distance=..5,nbt=!{inGround:true}] store result entity @e[type=piglin,tag=goblin,limit=1,sort=nearest] Pos[0] double 0.0001 run scoreboard players get @s motion_x
execute as @e[type=minecraft:arrow,distance=..5,nbt=!{inGround:true}] store result entity @e[type=piglin,tag=goblin,limit=1,sort=nearest] Pos[1] double 0.0001 run scoreboard players get @s motion_y
execute as @e[type=minecraft:arrow,distance=..5,nbt=!{inGround:true}] store result entity @e[type=piglin,tag=goblin,limit=1,sort=nearest] Pos[2] double 0.0001 run scoreboard players get @s motion_z

execute as @e[type=minecraft:arrow,distance=..5,nbt=!{inGround:true}] at @e[type=piglin,tag=goblin,limit=1,sort=nearest] run particle block{block_state:{Name:dirt}} ~ ~-1 ~ 0.2 0.75 0.2 1 100 normal @a

scoreboard players add @e[type=piglin,tag=goblin] goblin_life 1
tag @e[type=piglin] remove goblin
scoreboard players set @s goblin_life 0
function example:goblin_loop