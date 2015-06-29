local water = {}

function water.load()
    water.level = 400
    water.x, water.y = 200, water.level
    water.w, water.h = 400, 200--love.graphics.getWidth(), love.graphics.getHeight()

    reflection = love.graphics.newCanvas(water.w, water.h);
    shader = love.graphics.newShader([[
		extern float time;
		varying vec2 hs;
		varying float altitude;
		uniform float cutoff = 300.0;

		#ifdef VERTEX
        vec4 position(mat4 transform_projection, vec4 vertex_position) {
            hs = love_ScreenSize.xy/2.0;
			vec4 pos = transform_projection * vertex_position;
            return pos;
        }
		#endif

		#ifdef PIXEL
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
			vec2 uv = texture_coords;
            float offset = 4.0*cos(4.0*time+80.0*uv.y)*uv.y/hs.y;
            vec4 pixel = Texel(texture, vec2(uv.x+offset, 1.0-uv.y));
			pixel.a *= 0.9*(1.0-uv.y);
			pixel.rgb *= vec3(0.5, 1.0, 1.25);
            if (uv.y < 0.01) {
                pixel = vec4(1.0);
            }
			return pixel * color;
        }
		#endif
    ]])
end

function water.update(dt)
    if love.keyboard.isDown('up') then
        water.y = water.y - 1
    end
    if love.keyboard.isDown('left') then
        water.x = water.x - 1
    end
    if love.keyboard.isDown('down') then
        water.y = water.y + 1
    end
    if love.keyboard.isDown('right') then
        water.x = water.x + 1
    end
	-- shader:send('surface', water.y);
	shader:send('time', os.clock()*10);
end

function water.draw(drawWorld)
    -- draw reflection
    reflection:clear()
    love.graphics.setCanvas(reflection)
    love.graphics.push()
    love.graphics.translate(-water.x, -(water.y-water.h))
    drawWorld()
    love.graphics.pop()
    love.graphics.setCanvas()
    -- render reflection
    love.graphics.setShader(shader)
    love.graphics.draw(reflection, water.x, water.y);
    love.graphics.setShader()
end

return water
