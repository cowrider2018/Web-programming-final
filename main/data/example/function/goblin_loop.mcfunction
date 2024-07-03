scoreboard players add @a[scores={goblin_life=0..}] goblin_life 1
scoreboard players add @e[type=piglin,scores={goblin_life=1..}] goblin_life 1

execute at @e[type=piglin,scores={goblin_life=60..}] run particle block{block_state:{Name:dirt}} ~ ~-1 ~ 0.2 0.75 0.2 1 100 normal @a
execute as @e[type=piglin,scores={goblin_life=60..}] at @s run tp @s ~ ~-1 ~
kill @e[type=piglin,scores={goblin_life=65..}]

team leave @a[team=goblin,scores={goblin_life=2..}]
scoreboard players reset @a[scores={goblin_life=2..}] goblin_life

schedule function example:goblin_loop 1