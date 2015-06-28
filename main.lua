water = require 'water'
box = require 'box'
Camera = require 'camera'

love.graphics.setDefaultFilter('nearest', 'nearest')

function love.load()
	love.graphics.setBackgroundColor(100, 100, 100, 255)
	box.load()
	water.load()
	bg = love.graphics.newImage('bg.png')

	canvas = love.graphics.newCanvas();
    shader = love.graphics.newShader([[
		extern float surface;
		//extern float time;
		varying vec2 hs;
		varying float altitude;
		uniform float cutoff = 300.0;
		#ifdef VERTEX
        vec4 position(mat4 transform_projection, vec4 vertex_position) {
			vec4 pos = transform_projection * vertex_position;
			hs = love_ScreenSize.xy/2.0;
			vec4 s = (hs.y-surface)*2.0/hs.y*vec4(0.0, 1.0, 0.0, 1.0);
			s = transform_projection * s;
			pos.y = s.y-pos.y;
			altitude = -pos.y*hs.y;
            return pos;
        }
		#endif
		#ifdef PIXEL
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
			//vec2 uv = texture_coords;
			//vec2 offset = vec2(cos(time*3.0+200.0*uv.y), 0.0)*10.0*uv.y/hs;

			//vec4 pixel = Texel(texture, vec2(uv.x+offset.x, uv.y+offset.y));
			//pixel.a *= 0.7*(1.0 - height);
			vec4 pixel = Texel(texture, texture_coords);
			pixel.a *= 1.0-altitude/cutoff;
			pixel.rgb *= vec3(0.6, 0.8, 1.0);
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
	-- shader:send('time', os.clock()*10);
	-- local cx, cy = cam:pos()
    -- local dx, dy = box.x+32 - cx, box.y-32 - cy
    -- dx, dy = dx/10, dy/10
    -- cam:move(dx, dy)
	cam:lookAt(box.x, box.y)
end

function drawAll()
	love.graphics.draw(bg, 0, 0, 0, 2, 2)
	box.draw()

	-- draw reflection
	love.graphics.setCanvas(canvas)
	canvas:clear()
	love.graphics.setStencil(water.stencil)
	love.graphics.draw(bg, 0, 0, 0, 2, 2)
	box.draw()
	love.graphics.setStencil()
	love.graphics.setCanvas()
	-- render reflection
	love.graphics.setShader(shader)
	love.graphics.draw(canvas);
	love.graphics.setShader()

	-- for i=1, 8 do
	-- 	love.graphics.line(0, 100*i, love.graphics.getWidth(), 100*i)
	-- end
end

function love.draw()
	drawAll()
	-- cam:draw(drawAll)
end
