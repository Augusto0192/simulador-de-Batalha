
-- Dependencies
local utils = require("utils")
local playerActions = require("player.actions")
local colossus = require("boss.colossus")
local colossusActions = require("boss.actions")
local player = require("player.hamerHand")
utils.enableUtf8()

print("escolha seu Guerreiro:", "1- Trovão", "2- Mão de Martelo")
choiser = utils.ask()
if choiser == 1 then
    player = require("player.thunder")
else
    print("então vai de martelo")
end
-- Habilitar UTF-8 no terminal


-- Header
utils.printHeader()

-- Obter definição do monstro
local boss = colossus
local bossActions = colossusActions

-- Apresentar o monstro
utils.printCreature(boss)

-- Build actions
playerActions.build()
bossActions.build()

-- Começar o loop de batalha
while true do

    -- Mostrar ações para o jogador
    print()
    print(string.format("Qual será o próximo movimento de %s?", player.name))
    local validPlayerActions = playerActions.getValidActions(player, boss)
    for i, action in pairs(validPlayerActions) do
        print(string.format("%d. %s", i, action.description))
    end
    local chosenIndex = utils.ask()
    local chosenAction = validPlayerActions[chosenIndex]
    local isActionValid = chosenAction ~= nil

    -- Simular o turno do jogador
    if isActionValid then
        chosenAction.execute(player, boss)
    else
        print(string.format("Sua escolha é inválida. %s perdeu a vez.", player.name))
    end

    -- Ponto de saída: Criatura ficou sem vida
    if boss.health <= 0 then
        break
    end

    -- Simular turno da criatura
    print()
    local validBossActions = bossActions.getValidActions(player, boss)
    local bossAction = validBossActions[math.random(#validBossActions)]
    bossAction.execute(player, boss)

    -- Ponto de saída: Jogador ficou sem vida
    if player.health <= 0 then
        break
    end
end

-- Processar condições de vitória e derrota
if player.health <= 0 then
    print()
    print("---------------------------------------------------------------------")
    print()
    print("😭")
    print(string.format("%s não foi capaz de vencer %s.", player.name, boss.name))
    print("Quem sabe na próxima vez...")
    print()
elseif boss.health <= 0 then
    print()
    print("---------------------------------------------------------------------")
    print()
    print("🥳")
    print(string.format("%s prevaleceu e venceu %s.", player.name, boss.name))
    print("Parabéns!!!")
    print()

end
