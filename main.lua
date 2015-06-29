water = require 'water'
box = require 'box'
Camera = require 'camera'

love.graphics.setDefaultFilter('nearest', 'nearest')
love.graphics.setBackgroundColor(100, 100, 100, 255)

function love.load()
	box.load()
	water.load()
	bg = love.graphics.newImage('bg.png')
	cam = Camera:new()
	cam:lookAt(box.x, box.y)
end

function love.update(dt)
	if love.keyboard.isDown('escape') then
		love.event.push('quit')
	end
	box.update(dt)
	water.update(dt)
	-- local cx, cy = cam:pos()
    -- local dx, dy = box.x+32 - cx, box.y-32 - cy
    -- dx, dy = dx/10, dy/10
    -- cam:move(dx, dy)
	cam:lookAt(box.x, box.y)
end

function drawWorld()
	love.graphics.setColor(220, 255, 180)
	love.graphics.draw(bg, 0, 0, 0, 2, 2)
	love.graphics.setColor(255, 255, 255)
	box.draw()
end

function love.draw()
	drawWorld()
	water.draw(drawWorld)
	-- cam:draw(drawWorld)
	-- for i=1, 8 do
	-- 	love.graphics.line(0, 100*i, love.graphics.getWidth(), 100*i)
	-- end
end
