local cfgLoader = {}

local lf = _G.love.filesystem

function cfgLoader.load(path)
    local fileError = ("File \"%s\" "):format(path)
    local file = lf.getInfo(path)
    assert(file, (fileError .. "doesn't exist!"):format(path))
    local rsl = {}
    local iter = lf.read(path):gmatch("[^\f\t\v]+[(\r|\n)$]")
    for stmt in iter do
        if stmt then
            local pos = stmt:find(":")
            assert(pos, fileError .. "misses \":\"")
            local k, v = stmt:sub(1, pos - 1), stmt:sub(pos + 1)
            v = tonumber(v) or v
            rsl[k] = v
        end
    end
    return rsl
end

function cfgLoader.save(path, tbl)
    local rsl = {}
    for k, v in pairs(tbl) do
        local str = ("%s: %s"):format(k, tostring(v))
        rsl[#rsl + 1] = str
    end
    local rstr = table.concat(rsl, "\r\n") .. "\r\n"
    lf.write(path, rstr)
end

return cfgLoader