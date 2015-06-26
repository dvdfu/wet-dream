water = require 'water'
sushi = require 'sushi'
Camera = require 'camera'

love.graphics.setDefaultFilter('nearest', 'nearest')

function love.load()
	love.graphics.setBackgroundColor(100, 100, 100, 255)
	sushi.load()
	water.load()
	bg = love.graphics.newImage('bg.png')

    shader = love.graphics.newShader([[
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
			vec4 pixel = Texel(texture, texture_coords);
			pixel.a *= 0.3;//texture_coords.y;
            return pixel * color;
        }
    ]], [[
		extern float surface;
        vec4 position(mat4 transform_projection, vec4 vertex_position) {
			vec4 pos = transform_projection * vertex_position;
			float hsy = love_ScreenSize.y/2.0;
			float water = (hsy-surface)/hsy*2.0;
			pos.y = (pos.y - water) * -1.0;
            return pos;
        }
    ]])
	shader:send('surface', water.y);
	cam = Camera:new()
	cam:lookAt(sushi.x, sushi.y)
end

function love.update(dt)
	if love.keyboard.isDown('escape') then
		love.event.push('quit')
	end
	sushi.update(dt)
	-- water.update(dt)

	local cx, cy = cam:pos()
    local dx, dy = sushi.x+32 - cx, sushi.y-32 - cy
    dx, dy = dx/10, dy/10
    cam:move(dx, dy)
end

function drawWater()
	love.graphics.setColor(255, 255, 255, 200)
	water.draw()
	love.graphics.setColor(255, 255, 255, 255)
end

function drawAll()
	sushi.draw()
	drawWater()
	love.graphics.setStencil(drawWater)
	love.graphics.setShader(shader)
	sushi.draw()
	love.graphics.setShader()
	love.graphics.setStencil()
	-- for i=1, 8 do
	-- 	love.graphics.line(0, 100*i, love.graphics.getWidth(), 100*i)
	-- end
end

function love.draw()
	drawAll()
	-- cam:draw(drawAll)
end
