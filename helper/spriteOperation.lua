local sprOper = {}
local lg = _G.love.graphics
local cfgLoader = _G.lua.cfgLoader

function sprOper.split(inputPath, output, cfgPath, range)
    local origin = lg.newImage(inputPath)
    local quad = lg.newQuad(0, 0, 0, 0, origin:getDimensions())
    local spr = {}
    for k, v in pairs(range) do
        local x, y, w, h = unpack(v)
        local path = output .. "/" .. k .. ".png"
        spr[k] = path
        local canvas = lg.newCanvas(w, h)
        lg.setCanvas(canvas)
        quad:setViewport(x, y, w, h)
        lg.draw(origin, quad)
        lg.setCanvas()
        local data = canvas:newImageData()
        canvas:release()
        local fileData = data:encode("png")
        lua.file.write(path, fileData, "lfs")
        fileData:release()
    end
    origin:release()
    quad:release()
    cfgLoader.save(cfgPath, spr)
end

function sprOper.pack(inputs, output, cfgPath)
    local sprites = {}
    for i = 1, #inputs do
        sprites[i] = lg.newImage(inputs[i])
    end
    local cfg = {}
    local sprX, sprY, sprMaxY = 0, 0, 0
    local canvas = lg.newCanvas()
    lg.setCanvas(canvas)
    for i = 1, #sprites do
        local spr = sprites[i]
        lg.draw(spr, sprX, sprY)
        cfg[inputs[i]] = {sprX, sprY, spr:getDimensions()}
        sprX = sprX + spr:getWidth()
        sprMaxY = math.max(sprMaxY, spr:getHeight())
        if sprX > canvas:getWidth() then
            sprX = 0
            sprY = sprMaxY
            sprMaxY = 0
        end
    end
    lg.setCanvas()
    local data = canvas:newImageData()
    cfg.WIDTH, cfg.HEIGHT = canvas:getDimensions()
    canvas:release()
    data:encode("png", output)
    data:release()
    cfgLoader.save(cfgPath, cfg)
end

return sprOper