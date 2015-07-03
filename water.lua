local water = {}
water.__index = water

function water.new(x,y,w,h)
    local self = {}
    setmetatable(self, water)
    self.x, self.y = x, y
    self.w, self.h = w, h
    self.diffraction = love.graphics.newCanvas(self.w, self.h)
    self.reflection = love.graphics.newCanvas(self.w, self.h)
    self.waterShader = love.graphics.newShader([[
        extern float time;
        extern float cutoff = 64.0;
        extern vec2 turbulence = vec2(1.0);
        extern vec2 size;
        extern vec4 tint = vec4(0.5, 0.7, 0.9, 0.2);
        extern Image reflection;
        varying vec2 hs;

        #ifdef VERTEX
        vec4 position(mat4 transform_projection, vec4 vertex_position) {
            hs = love_ScreenSize.xy/2.0;
            return transform_projection * vertex_position;
        }
        #endif

        #ifdef PIXEL
        float rand(vec2 co) {
            return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
        }

        vec4 effect(vec4 color, Image texture, vec2 tc, vec2 screen_coords) {
            vec2 pc = tc*size;
            vec2 offset = turbulence/size;
            offset.x *= 1.0*cos(80.0*time+pc.y/4.0);
            offset.y *= 2.0*sin(40.0*time+pc.x/40.0);
            if (pc.y < (offset*size+turbulence*2.0).y) {
                discard;
            }

            // diffraction
            vec4 out_pixel = Texel(texture, tc+offset);
            out_pixel.a = 1.0;

            // reflection
            vec4 ref_pixel = Texel(reflection, vec2((tc+offset).x, 1.0-(tc+offset).y));
            ref_pixel.a = max(1.0-(tc*size).y/cutoff, 0.0);
            if (pc.y < (offset*size+turbulence*2.0).y+2.0) {
                out_pixel.rgb = tint.rgb;
            } else {
                out_pixel.rgb = mix(out_pixel.rgb, ref_pixel.rgb, ref_pixel.a);
                //out_pixel.rgb += ref_pixel.rgb*ref_pixel.a;
            }
            out_pixel.rgb = mix(out_pixel.rgb, tint.rgb, tint.a);

            return out_pixel * color;
        }
        #endif
    ]])
    self.waterShader:send('size', {self.w, self.h})
    self.stencilShader = love.graphics.newShader([[
        vec4 effect(vec4 color, Image texture, vec2 tc, vec2 screen_coords) {
            float alpha = Texel(texture, tc).a;
            if (alpha == 0.0) {
                discard;
            }
            return vec4(vec3(1.0), alpha);
        }
    ]])
    return self
end

function water:update(dt)
    self.waterShader:send('time', os.clock())
end

function water:draw(drawWorld, stencil)
    function render(canvas, x, y)
        canvas:clear()
        love.graphics.setCanvas(canvas)
        love.graphics.push()
        love.graphics.origin()
        love.graphics.translate(-x, -y)
        drawWorld()
        love.graphics.pop()
        love.graphics.setCanvas()
    end
    render(self.diffraction, self.x, self.y)
    render(self.reflection, self.x, self.y-self.h)
    self.waterShader:send('reflection', self.reflection)

    love.graphics.setShader(self.stencilShader)
    love.graphics.setInvertedStencil(stencil)
    love.graphics.setShader(self.waterShader)
    love.graphics.draw(self.diffraction, self.x, self.y);
    love.graphics.setShader()
    love.graphics.setStencil()
end

function water:setFilter(filter)
    self.diffraction:setFilter(filter, filter)
    self.reflection:setFilter(filter, filter)
end

function water:setTurbulence(x, y)
    self.waterShader:send('turbulence', {x, y})
end

function water:setTint(r, g, b, a)
    self.waterShader:send('tint', {r, g, b, a})
end

function water:setCutoff(cutoff)
    self.waterShader:send('cutoff', cutoff)
end

return water
