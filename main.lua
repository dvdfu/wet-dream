Water = require 'water'
box = require 'box'
Camera = require 'camera'

love.graphics.setDefaultFilter('nearest', 'nearest')

function love.load()
	box.load()
	water = Water.new(0, 400, love.graphics.getWidth(), love.graphics.getHeight())
	bg = love.graphics.newImage('bg2.png')
	cam = Camera:new()
	cam:lookAt(box.x, box.y)
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
    cam:move(dx, dy)
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
