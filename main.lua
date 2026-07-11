Class = require 'class'
require 'Paddle'
require 'Ball'

push = require 'push'

SCREEN_WIDTH = 1280
SCREEN_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200 -- pixels por frame

PADDLE_WIDTH = 5
PADDLE_HEIGHT = 20

BALL_SIZE = 4

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
    gameState = 'start' -- Enquanto nao comecar, o update nao roda

    player1 = Paddle(10, 30, PADDLE_WIDTH, PADDLE_HEIGHT)
    player2 = Paddle(VIRTUAL_WIDTH - 15, VIRTUAL_HEIGHT - 50, PADDLE_WIDTH, PADDLE_HEIGHT)

    ball = Ball(VIRTUAL_WIDTH / 2 - BALL_SIZE/2, VIRTUAL_HEIGHT / 2 - BALL_SIZE/2, BALL_SIZE)

end

-- Movimentos
function love.update(dt)
    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end

    if gameState == 'play' then
        ball:update(dt)
    end

    player1:update(dt)
    player2:update(dt)
end

-- Estados do jogo
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        gameState = 'play' -- Comeca o jogo
        ball:reset()
    end
end

function love.draw()
    push:apply('start')

    love.graphics.setFont(regularFont)
    love.graphics.printf(scoreP1, -30, 30, VIRTUAL_WIDTH, "center")
    love.graphics.printf(scoreP2, 30, 30, VIRTUAL_WIDTH, "center")

    player1:render()
    player2:render()
    ball:render()

    push:apply('end')
end