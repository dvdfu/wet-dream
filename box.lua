local box = {}

function box.load()
    box.x, box.y = 0, 0
    box.spr = love.graphics.newImage('sushi.png')
end

function box.update(dt)
    if love.keyboard.isDown('w') then
        box.y = box.y - 3
    end
    if love.keyboard.isDown('a') then
        box.x = box.x - 3
    end
    if love.keyboard.isDown('s') then
        box.y = box.y + 3
    end
    if love.keyboard.isDown('d') then
        box.x = box.x + 3
    end
end

function box.draw()
    love.graphics.draw(box.spr, box.x, box.y, 0, 2, 2)
end

return box
