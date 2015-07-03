Water = require 'water'
box = require 'box'
Camera = require 'camera'

love.graphics.setDefaultFilter('nearest', 'nearest')

function love.load()
	box.load()
	water = Water.new(0, 400, love.graphics.getWidth(), 80)
	bg = love.graphics.newImage('bg2.png')
	cam = Camera:new()
	cam:lookAt(box.x, box.y)
	-- cam:zoom(0.5)
    -- water:setFilter('linear')
	water:setTurbulence(1, 1)
end

function love.update(dt)
	if love.keyboard.isDown('escape') then
		love.event.push('quit')
	end
	box.update(dt)
	water:update(dt)
	local cx, cy = cam:pos()
    local dx, dy = box.x+32 - cx, box.y-32 - cy
    dx, dy = dx/20, dy/20
	if math.abs(dx) > 0.01 or math.abs(dy) > 0.01 then
	    cam:move(dx, dy)
	else
		cam:lookAt(box.x+32, box.y-32)
	end
end

function drawWorld()
	love.graphics.draw(bg)
	box.draw()
end

function drawAll()
	drawWorld()
	water:draw(drawWorld)
end

function love.draw()
	cam:draw(drawAll)
end
