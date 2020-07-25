local class = _G.class

return class {
    funcArray = nil,
    name = "event",
    __event = true,
    active = true,
    connect = function (self, func)
        self.funcArray[1] = func
        return 1
    end,
    bind = function (self, func, key)
        local funcArray = self.funcArray
        local rkey = (key ~= nil) and key or (#funcArray + 1)
        self.funcArray[rkey] = func
        return rkey
    end,
    unbind = function (self, idx)
        local f = self.funcArray[idx]
        assert(f, ("Event functions index \"%s\" doesn't exist!"):format(tostring(idx)))
        self.funcArray[idx] = nil
        return f
    end,
    extend = function (self, rsl, name, func)
        rsl.funcArray = (type(func) == "function" and {func} or func) or {}
        rsl.name = name
        return rsl
    end,
    fire = function (self)
        if not self.active then return end
        for i = 1, #self.funcArray do
            local f = self.funcArray[i]
            if f then
                f()
            end
        end
    end
}
