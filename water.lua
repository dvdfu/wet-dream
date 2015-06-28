local water = {}

function water.load()
    water.level = 300
    water.x, water.y = 0, water.level
    water.w, water.h = love.graphics.getWidth(), love.graphics.getHeight()
    water.t = 0
    water.spr = love.graphics.newImage('water.png')
end

function water.update(dt)
    water.t = water.t + dt
    water.y = water.level + 5*math.sin(water.t)
end

function water.draw()
    love.graphics.draw(water.spr, water.x, water.y, 0, water.w/80, water.h/32)
end

function water.stencil()
    love.graphics.draw(water.spr, water.x, water.y-water.h, 0, water.w/80, water.h/32)
end

return water
