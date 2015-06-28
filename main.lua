water = require 'water'
box = require 'box'
Camera = require 'camera'

love.graphics.setDefaultFilter('nearest', 'nearest')

function love.load()
	love.graphics.setBackgroundColor(100, 100, 100, 255)
	box.load()
	water.load()
	bg = love.graphics.newImage('bg.png')

	-- float hsy = love_ScreenSize.y/2.0;
	-- vec4 s = transform_projection * vec4(0.0, surface/love_ScreenSize.y, 0.0, 1.0);
	-- float water = (hsy-s.y)/hsy*2.0;

    shader = love.graphics.newShader([[
		#ifdef VERTEX
		extern float surface;
		varying float height;
        vec4 position(mat4 transform_projection, vec4 vertex_position) {
			vec4 pos = transform_projection * vertex_position;
			float hsy = love_ScreenSize.y/2.0;
			float s = (hsy-surface)/hsy;
			vec4 water = vec4(0.0, s, 0.0, s);
			height = pos.y - water.y;
			pos.y = water.y - height;
            return pos;
        }
		#endif
		#ifdef PIXEL
		varying float height;
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
			vec4 pixel = Texel(texture, texture_coords);
			pixel.a *= 0.7*(1.0 - height);
            return pixel * color;
        }
		#endif
    ]])
	cam = Camera:new()
	cam:lookAt(box.x, box.y)
end

function love.update(dt)
	if love.keyboard.isDown('escape') then
		love.event.push('quit')
	end
	box.update(dt)
	water.update(dt)
	shader:send('surface', water.y);

	-- local cx, cy = cam:pos()
    -- local dx, dy = box.x+32 - cx, box.y-32 - cy
    -- dx, dy = dx/10, dy/10
    -- cam:move(dx, dy)
	cam:lookAt(box.x, box.y)
end

function drawWater()
	love.graphics.setColor(255, 255, 255, 80)
	water.draw()
	love.graphics.setColor(255, 255, 255, 255)
end

function drawAll()
	love.graphics.draw(bg, 0, 0, 0, 2, 2)
	box.draw()
	drawWater()
	love.graphics.setStencil(drawWater)
	love.graphics.setShader(shader)
	love.graphics.draw(bg, 0, 0, 0, 2, 2)
	box.draw()
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
