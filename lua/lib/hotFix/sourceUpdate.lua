--! Load All Files

local lf = _G.love.filesystem

local function iterDic(dic, func)
    local files = lf.getDirectoryItems(dic)
    for _, name in ipairs(files) do
        if not (name:match"%.") then
            iterDic(dic .. "/" .. name, func)
        else
            func(dic, name:match(".+[%.$]"):sub(1, -2))
        end
    end
end

return function ()
    local tbl = {}
    iterDic("Lua", function (dic, name)
        package.loaded[name] = nil
        local rsl = require(dic .. "/" .. name)
        tbl[name] = rsl
    end)
    collectgarbage"collect"
    return tbl
end
