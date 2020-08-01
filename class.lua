local function deepCopy(tbl, rsl)
    for k, v in pairs(tbl) do
        local vt = type(v)
        if vt == "table" then
            rsl[k] = {}
            deepCopy(v, rsl[k])
        else
            rsl[k] = v
        end
    end
end

local mt

mt = {
    __call = function (self, ...)
        local arg = {...}
        local rsl = { __class = true }
        deepCopy(self, rsl)
        if self.extend then
            rsl = self:extend(rsl, ...)
        else
            local argf = arg[1]
            local argft = type(argf)
            if argft == "function" then
                rsl.init = argf
            elseif argft == "table" then
                deepCopy(argf, rsl)
            end
        end
        return setmetatable(rsl, mt)
    end
}

return function (init)
    local rsl = { __class = true }
    local initType = type(init)
    if initType == "function" then
        rsl.init = init
        init(rsl)
    elseif initType == "table" then
        deepCopy(init, rsl)
    end
    return setmetatable(rsl, mt)
end