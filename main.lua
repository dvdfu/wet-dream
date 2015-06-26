water = require 'water'

love.graphics.setDefaultFilter('nearest', 'nearest')

function love.load()
	love.graphics.setBackgroundColor(100, 100, 100, 255)
	water.load()
	bg = love.graphics.newImage('bg.png')
end

function love.update(dt)
	if love.keyboard.isDown('escape') then
		love.event.push('quit')
	end
	water.update(dt)
end

function waterStencil()
	-- love.graphics.setShader(shader)
    water.draw()
	-- love.graphics.setShader()
end

function love.draw()
	-- love.graphics.draw(bg)
    water.draw()
    -- love.graphics.setStencil(waterStencil)
	-- love.graphics.setStencil()
end
