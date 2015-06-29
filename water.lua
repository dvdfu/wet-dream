local water = {}

function water.load()
    water.level = 360
    water.x, water.y = 0, water.level
    water.w, water.h = 960, 360--love.graphics.getWidth(), love.graphics.getHeight()
    water.t = 0

    reflection = love.graphics.newCanvas(water.w, water.h);
    shader = love.graphics.newShader([[
		extern float surface;
		extern float time;
		varying vec2 hs;
		varying float altitude;
		uniform float cutoff = 300.0;

		#ifdef VERTEX
        vec4 position(mat4 transform_projection, vec4 vertex_position) {
			vec4 pos = transform_projection * vertex_position;
			hs = love_ScreenSize.xy/2.0;
			vec4 s = (hs.y-surface)*2.0/hs.y*vec4(0.0, 1.0, 0.0, 1.0);
			s = transform_projection * s;
			altitude = (s.y-pos.y)*hs.y;
			pos.y = s.y-pos.y;
            return pos;
        }
		#endif

		#ifdef PIXEL
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
			vec2 uv = texture_coords;
			vec2 offset = vec2(10.0*cos(10.0*time+150.0*uv.y)*uv.y, 0.0)*uv.y/hs;

			vec4 pixel = Texel(texture, vec2(uv.x+offset.x, uv.y+offset.y));

			pixel.a *= 0.75;//1.0-altitude/cutoff;
			//pixel.rgb *= vec3(0.5, 1.0, 1.5);
            pixel.rgb *= 0.75;
            if (uv.y > 0.99) {
                pixel = vec4(1.0);
            }
			return pixel * color;
        }
		#endif
    ]])
end

function water.update(dt)
    -- water.t = water.t + dt
    -- water.y = water.level + 5*math.sin(water.t)
    if love.keyboard.isDown('up') then
        water.y = water.y - 0.5
    end
    if love.keyboard.isDown('down') then
        water.y = water.y + 0.5
    end
	shader:send('surface', water.y);
	shader:send('time', os.clock()*10);
end

function water.draw(drawWorld)
    love.graphics.rectangle('fill', water.x, water.y, water.w, water.h)
    -- draw reflection
    love.graphics.setCanvas(reflection)
    reflection:clear()
    love.graphics.setStencil(stencil)
    drawWorld()
    love.graphics.setStencil()
    love.graphics.setCanvas()
    -- render reflection
    love.graphics.setShader(shader)
    love.graphics.draw(reflection);
    love.graphics.setShader()
end

function stencil()
    love.graphics.rectangle('fill', water.x, water.y-water.h, water.w, water.h)
end

return water
