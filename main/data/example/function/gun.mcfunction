tag @a add shot

execute as @p[tag=shot] at @s run summon minecraft:arrow ^ ^ ^0.1 {Tags:[bullet,shot],PierceLevel:5,Color:-1}

execute as @a store result score @s x run data get entity @s Pos[0] 10000
execute as @a store result score @s y run data get entity @s Pos[1] 10000
execute as @a store result score @s z run data get entity @s Pos[2] 10000

execute as @e[type=arrow,tag=shot] store result score @s x run data get entity @s Pos[0] 10000
execute as @e[type=arrow,tag=shot] store result score @s y run data get entity @s Pos[1] 10000
execute as @e[type=arrow,tag=shot] store result score @s z run data get entity @s Pos[2] 10000

execute as @e[type=arrow,tag=shot] store result score @s x run scoreboard players operation @s x -= @p[tag=shot] x
execute as @e[type=arrow,tag=shot] store result score @s y run scoreboard players operation @s y -= @p[tag=shot] y
execute as @e[type=arrow,tag=shot] store result score @s z run scoreboard players operation @s z -= @p[tag=shot] z

execute as @e[type=arrow,tag=shot] at @s run tp @s ~ ~1.62 ~

execute as @e[type=arrow,tag=shot] store result entity @s Motion[0] double 0.01 run scoreboard players get @s x
execute as @e[type=arrow,tag=shot] store result entity @s Motion[1] double 0.01 run scoreboard players get @s y
execute as @e[type=arrow,tag=shot] store result entity @s Motion[2] double 0.01 run scoreboard players get @s z

scoreboard players reset @e[tag=shot] x
scoreboard players reset @e[tag=shot] y
scoreboard players reset @e[tag=shot] z
scoreboard players reset @a gun
tag @e remove shot

kill @e[tag=bullet,nbt={inGround:1b}]

schedule function main:gun 1