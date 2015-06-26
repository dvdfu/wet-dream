local water = {}

function water.load()
    x, y = 100, 100
    spr = love.graphics.newImage('water.png')
    -- canvas = love.graphics.newCanvas(80, 32)
    shader = love.graphics.newShader([[
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
			vec4 pixel = Texel(texture, vec2(texture_coords.x, 1.0-texture_coords.y));
            return pixel * color * (1.0-texture_coords.y);
        }
    ]], [[
        vec4 position(mat4 transform_projection, vec4 vertex_position) {
            return transform_projection * vertex_position;
        }
    ]])
end

function water.update(dt)
    y = y + dt*10
end

function water.draw()
    love.graphics.draw(spr, x, y)
    love.graphics.setBlendMode('additive')
	love.graphics.setShader(shader)
    love.graphics.draw(spr, x, y+32)
	love.graphics.setShader()
    love.graphics.setBlendMode('alpha')
    -- canvas:clear()
	-- love.graphics.setCanvas(canvas)
    -- love.graphics.setShader(shader)
    -- love.graphics.draw(spr)
    -- love.graphics.draw(spr, x, y + 36)
    -- love.graphics.setShader()
	-- love.graphics.setCanvas()
end

return water
