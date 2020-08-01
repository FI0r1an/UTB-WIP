local cfgLoader = {}

local lf = _G.love.filesystem

function cfgLoader.load(path)
    local fileError = ("File \"%s\" "):format(path)
    local file = lf.getInfo(path)
    assert(file, (fileError .. "doesn't exist!"):format(path))
    local rsl = {}
    local content = lf.read(path)
    content:gsub("[^(\r|\n)$]+", function (w)
        local pos = w:find(":")
        assert(pos)
        local v = w:sub(pos + 1)
        local rv
        if v:sub(1, 1) == "!" then
            local arg = {}
            v:sub(2):gsub("[^ $]+", function (w) arg[#arg + 1] = tonumber(w) or w return w end)
            rv = arg
        else
            rv = tonumber(v) or v
        end
        rsl[w:sub(1, pos-1)] = rv
        return w
    end)
    return rsl
end

function cfgLoader.save(path, tbl, mode)
    local rsl = {}
    for k, v in pairs(tbl) do
        local str
        if type(v) == "table" then
            str = "!" .. table.concat(v, " ")
        else
            str = tostring(v)
        end
        rsl[#rsl + 1] = ("%s:%s"):format(k, str)
    end
    local rstr = table.concat(rsl, "\n") .. "\n"
    lua.file.write(path, rstr, mode or "io")
end

return cfgLoader