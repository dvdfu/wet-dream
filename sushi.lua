local sushi = {}

function sushi.load()
    sushi.x, sushi.y = 0, 20
    sushi.spr = love.graphics.newImage('sushi3.png')
end

function sushi.update(dt)
    if love.keyboard.isDown('w') then
        sushi.y = sushi.y - 2
    end
    if love.keyboard.isDown('a') then
        sushi.x = sushi.x - 2
    end
    if love.keyboard.isDown('s') then
        sushi.y = sushi.y + 2
    end
    if love.keyboard.isDown('d') then
        sushi.x = sushi.x + 2
    end
end

function sushi.draw()
    love.graphics.draw(sushi.spr, sushi.x, sushi.y, 0, 2, 2)
end

return sushi
