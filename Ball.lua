Ball = Class{}

function Ball:init(x, y, size)
    self.x = x
    self.y = y
    self.size = size

    math.randomseed(os.time())
    self.dx = math.random(2) == 1 and 100 or -100
    self.dy = math.random(-50, 50)
end

function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2

    self.dx = math.random(2) == 1 and 100 or -100
    self.dy = math.random(-50, 50)    
end

function Ball:collide(player)
    if (self.x >= player.x + player.width) or (player.x >= self.x + self.size) then
        return false
    end

    if (self.y >= player.y + player.height) or (player.y >= self.y + self.size) then
        return false
    end

    return true
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    if self.y <= 0 or self.y >= (VIRTUAL_HEIGHT - self.size) then
        self.dy = -self.dy
    end
end

function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.size, self.size)
end