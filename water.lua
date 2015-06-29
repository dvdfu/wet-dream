local water = {}
water.__index = water

function water.new(x,y,w,h)
    local self = {}
    setmetatable(self, water)
    self.level = y
    self.x, self.y = x, self.level
    self.w, self.h = w, h

    self.diffraction = love.graphics.newCanvas(self.w, self.h);
    self.reflection = love.graphics.newCanvas(self.w, self.h);
    self.shader = love.graphics.newShader([[
		extern float time;
        extern vec2 size;
        extern Image reflection;
		varying vec2 hs;
        uniform float cutoff = 200.0;
        uniform Image displacement;
        uniform vec3 tint = vec3(0.5, 0.7, 0.9);

		#ifdef VERTEX
        vec4 position(mat4 transform_projection, vec4 vertex_position) {
            hs = love_ScreenSize.xy/2.0;
			return transform_projection * vertex_position;
        }
		#endif

		#ifdef PIXEL
        vec4 effect(vec4 color, Image texture, vec2 tc, vec2 screen_coords) {
            vec2 pc = tc * size;

            // displacement
            vec4 disp_pixel = Texel(displacement, tc);
            vec2 offset = vec2(1.0/hs);
            offset.x *= 1.5*cos(2.0*time+pc.y/4.0)*disp_pixel.y;
            offset.y *= 4.0*sin(1.0*time+pc.x/40.0+disp_pixel.x);
            if (pc.y < offset.y*size.y+4.0) {
                discard;
            }

            // diffraction
            vec4 out_pixel = Texel(texture, tc+offset);
            out_pixel.rgb *= tint;

            // reflection
            vec4 ref_pixel = Texel(reflection, vec2(tc.x+offset.x, 1.0-(tc.y+offset.y)));
            ref_pixel.a = max(1.0-tc.y*size.y/cutoff, 0.0);
            if (pc.y < offset.y*size.y+8.0) {
                out_pixel.rgb = tint;
            } else {
                out_pixel.rgb = mix(out_pixel.rgb, ref_pixel.rgb, ref_pixel.a);
            }

            return out_pixel * color;
        }
		#endif
    ]])
    self.shader:send('displacement', love.graphics.newImage('displacement.png'))
    self.shader:send('size', {self.w, self.h})
    return self
end

function water:update(dt)
    if love.keyboard.isDown('up') then
        self.y = self.y - 1
    end
    if love.keyboard.isDown('left') then
        self.x = self.x - 1
    end
    if love.keyboard.isDown('down') then
        self.y = self.y + 1
    end
    if love.keyboard.isDown('right') then
        self.x = self.x + 1
    end
	self.shader:send('time', os.clock()*10);
end

function water:draw(drawWorld)
    -- draw reflection
    self.reflection:clear()
    love.graphics.setCanvas(self.reflection)
    love.graphics.push()
    love.graphics.translate(-self.x, -(self.y-self.h))
    drawWorld()
    love.graphics.pop()
    love.graphics.setCanvas()
    self.shader:send('reflection', self.reflection)

    -- draw diffraction
    self.diffraction:clear()
    love.graphics.setCanvas(self.diffraction)
    love.graphics.push()
    love.graphics.translate(-self.x, -self.y)
    drawWorld()
    love.graphics.pop()
    love.graphics.setCanvas()

    -- render reflection
    love.graphics.setShader(self.shader)
    love.graphics.draw(self.diffraction, self.x, self.y);
    love.graphics.setShader()
end

return water
