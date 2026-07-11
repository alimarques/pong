push = require 'push'

SCREEN_WIDTH = 1280
SCREEN_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200 -- pixels por frame

RACKET_WIDTH = 5
RACKET_HEIGHT = 20

-- Configuracoes iniciais de load
function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true -- taxa de atualizacao da tela sincronizada com a sua tela
    })

    smallFont = love.graphics.newFont('font.ttf', 8)
    regularFont = love.graphics.newFont('font.ttf', 12)

    scoreP1 = 0
    scoreP2 = 0

    player1Y = 30
    player2Y = VIRTUAL_HEIGHT - 50
end

-- Movimentos
function love.update(dt)
    if love.keyboard.isDown('w') then
        player1Y = math.max(0, player1Y - PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('s') then
        player1Y = math.min(VIRTUAL_HEIGHT - RACKET_HEIGHT, player1Y + PADDLE_SPEED * dt)
    end

    if love.keyboard.isDown('up') then
        player2Y = math.max(0, player2Y - PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('down') then
        player2Y = math.min(VIRTUAL_HEIGHT - RACKET_HEIGHT, player2Y + PADDLE_SPEED * dt)
    end
end

-- Sair do jogo
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()
    push:apply('start')

    love.graphics.setFont(regularFont)
    love.graphics.printf(scoreP1, -30, 30, VIRTUAL_WIDTH, "center")
    love.graphics.printf(scoreP2, 30, 30, VIRTUAL_WIDTH, "center")

    love.graphics.rectangle('fill', 10, player1Y, RACKET_WIDTH, RACKET_HEIGHT) -- Player 1
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 15, player2Y, RACKET_WIDTH, RACKET_HEIGHT) -- Player 2
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4) -- Bola

    push:apply('end')
end