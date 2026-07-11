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

FINAL_SCORE = 3

-- Configuracoes iniciais de load
function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true -- taxa de atualizacao da tela sincronizada com a sua tela
    })

    smallFont = love.graphics.newFont('font.ttf', 20)
    regularFont = love.graphics.newFont('font.ttf', 32)

    servingPlayer = 0 -- Define quem vai comecar a rodada
    winningPlayer = 0

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

    if ball:collide(player1) or ball:collide(player2) then
        ball.dx = -ball.dx
        ball.dx = ball.dx * 1.05
    end

    if ball.x < 0 then
        scoreP2 = scoreP2 + 1
        ball:reset()

        if scoreP2 >= FINAL_SCORE then
            gameState = 'done'
            winningPlayer = 2
        else
            gameState = 'serve'
            servingPlayer = 1
        end
    elseif ball.x > VIRTUAL_WIDTH then
        scoreP1 = scoreP1 + 1
        ball:reset()
        servingPlayer = 2

        if scoreP1 >= FINAL_SCORE then
            gameState = 'done'
            winningPlayer = 1
        else
            gameState = 'serve'
            servingPlayer = 2
        end
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
        if gameState == 'start' then
            gameState = 'play'
            ball:reset()
        elseif gameState == 'serve' then
            gameState = 'play'
            ball:reset()
            if servingPlayer == 1 then
                ball.dx = -100
            else
                ball.dx = 100
            end
        elseif gameState == 'done' then
            gameState = 'start'
            scoreP1 = 0
            scoreP2 = 0
        end
    end
end

function love.draw()
    push:apply('start')

    if gameState == 'done' then
        love.graphics.setFont(regularFont)
        love.graphics.printf("Player " .. tostring(winningPlayer) .. " ganhou!", 0, VIRTUAL_HEIGHT / 2 - 20, VIRTUAL_WIDTH, "center")
        love.graphics.setFont(smallFont)
        love.graphics.printf("Aperte Enter para reiniciar", 0, VIRTUAL_HEIGHT / 2 + 20, VIRTUAL_WIDTH, "center")
    else
        love.graphics.setFont(regularFont)
        love.graphics.printf(scoreP1, -30, 30, VIRTUAL_WIDTH, "center")
        love.graphics.printf(scoreP2, 30, 30, VIRTUAL_WIDTH, "center")
        
        player1:render()
        player2:render()
        ball:render()
    end

    push:apply('end')
end