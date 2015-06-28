local water = {}

function water.load()
    water.level = 360
    water.x, water.y = 0, water.level
    water.t = 0
    water.spr = love.graphics.newImage('water.png')
end

function water.update(dt)
    water.t = water.t + dt
    water.y = water.level + 10*math.sin(water.t)
end

function water.draw()
    -- love.graphics.draw(water.spr, water.x, water.y, 0, 6, 6)
    love.graphics.draw(water.spr, water.x, water.y, 0, love.graphics.getWidth()/80, (love.graphics.getHeight()-water.y)/32)
end

return water
