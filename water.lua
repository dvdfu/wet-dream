local water = {}

function water.load()
    water.x, water.y = 0, 400
    water.spr = love.graphics.newImage('water.png')
end

function water.update(dt)
    water.y = water.y + dt*10
end

function water.draw()
    -- love.graphics.draw(water.spr, water.x, water.y, 0, 6, 6)
    love.graphics.draw(water.spr, water.x, water.y, 0, love.graphics.getWidth()/80, (love.graphics.getHeight()-water.y)/32)
end

return water
