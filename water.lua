local water = {}

function water.load()
    water.level = 100
    water.x, water.y = 200, water.level
    water.w, water.h = 400, 200--love.graphics.getWidth(), love.graphics.getHeight()
    water.t = 0

    reflection = love.graphics.newCanvas();
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
			vec2 offset = vec2(10.0*cos(10.0*time+200.0*uv.y)*uv.y, 0.0)*uv.y/hs;

			vec4 pixel = Texel(texture, vec2(uv.x+offset.x, uv.y+offset.y));
			//vec4 pixel = Texel(texture, texture_coords);
			pixel.a *= 0.75;//1.0-altitude/cutoff;
			pixel.rgb *= vec3(0.6, 0.8, 1.0);
			return pixel * color;
        }
		#endif
    ]])
	shader:send('surface', water.y);
end

function water.update(dt)
    -- water.t = water.t + dt
    -- water.y = water.level + 5*math.sin(water.t)
	shader:send('time', os.clock()*10);
end

function water.draw(drawWorld)
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
