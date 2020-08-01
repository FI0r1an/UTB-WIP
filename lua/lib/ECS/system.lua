local class = _G.class

return class {
    entities = {},
    active = true,
    name = "system",
    __system = true,
    extend = function (self, rsl, name)
        rsl.name = name
        rsl.load = nil
        return rsl
    end,
    load = function (self, path)
        local sys = require(path)
        sys.__system = true
        local rsl = self(self, sys.name)
        for k, v in pairs(sys) do
            rsl[k] = v
        end
        return rsl
    end,
    requires = function (self) return {} end,
    addEntity = function (self, entity, group)
        if group then
            assert(not self.entities[group], ("The group \"%s\" does exist"):format(tostring(group)))
            if not self.entities[group] then
                self.entities[group] = {}
            end
        else
            self.entities[entity.name] = entity
        end
    end,
    removeEntity = function (self, name, group)
        if group then
            assert(self.entities[group], ("The group \"%s\" doesn't exist"):format(tostring(group)))
            local r = self.entities[group][name]
            self.entities[group][name] = nil
            return r
        else
            assert(self.entities[name], ("The entity \"%s\" doesn't exist"):format(tostring(name)))
            local r = self.entities[name]
            self.entities[name] = nil
            return r
        end
    end,
    removeGroup = function (self, group)
        local r = self.entities[group]
        assert(r, ("The group \"%s\" doesn't exist"):format(tostring(group)))
        self.entities[group] = nil
        return r
    end,
    addGroup = function (self, name, group)
        self.entities[name] = group
    end,
    filter = function (self, tbl, group)
        local r = {}
        for _, v in pairs(group or self.entities) do
            if not v.__entity then
                local filtered = self:filter(tbl, v)
                for i = 1, #filtered do
                    r[#r + 1] = filtered[i]
                end
            else
                local isOK = true
                for i = 1, #tbl do
                    local k = tbl[i]
                    if not v[k] then
                        isOK = false
                        break
                    end
                end
                if isOK then
                    r[#r + 1] = v
                end
            end
        end
        return r
    end
}