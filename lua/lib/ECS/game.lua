local class = _G.class

return class {
    systems = {},
    entities = {},
    callback = {},
    extend = function (_, rsl)
        local onAddEntity = _G.lua.event("onAddEntity")
        onAddEntity:connect(function ()
            print"\"onAddEntity\" Event Fired"
        end)
        rsl.eventManager = _G.lua.eventManager()
        rsl.eventManager:addEvent(onAddEntity)
        return rsl
    end,
    createEntity = function (self, parent, name)
        local rsl = _G.lua.entity(parent, name)
        return rsl, self:addEntity(rsl, #self.entities+1)
    end,
    addEntity = function (self, entity, idx, group)
        self.eventManager:fire("onAddEntity")
        local key = idx or entity.name
        if group then
            self.entities[group] = self.entities[group] or {}
            assert(not self.entities[group][key], ("Entity \"%s\" in group \"%s\" does exist!"):format(tostring(key), tostring(group)))
            self.entities[group][key] = entity
        else
            assert(not self.entities[key], ("Entity \"%s\" does exist!"):format(tostring(key)))
            self.entities[key] = entity
        end
        for _, sys in pairs(self.systems) do
            self:insertRequiredEntities(sys, {entity})
        end
        return entity, key, group
    end,
    removeEntity = function (self, key, group)
        local rsl
        if group then
            rsl = self.entities[group][key]
            assert(rsl, ("Entity \"%s\" in group \"%s\" doesn't exist!"):format(tostring(key), tostring(group)))
            self.entities[group][key] = nil
        else
            rsl = self.entities[key]
            assert(rsl, ("Entity \"%s\" doesn't exist!"):format(tostring(key)))
            self.entities[key] = nil
        end
        for _, sys in pairs(self.systems) do
            if group then
                if sys.entities[group] and sys.entities[group][key] then
                    sys:removeEntity(key, group)
                end
            else
                if sys.entities[key] then
                    sys:removeEntity(key)
                end
            end
        end
        return rsl
    end,
    addSystem = function (self, system)
        assert(not self.systems[system.name], ("System \"%s\" does exist!"):format(system.name))
        self.systems[system.name] = system
        self:insertRequiredEntities(system, self.entities)
    end,
    insertRequiredEntities = function (self, system, entities)
        local req = system:requires()
        for _, e in pairs(entities) do
            local isOK = true
            for c in pairs(req) do
                if not e:existComponent(c) then
                    isOK = false
                    break
                end
            end
            if isOK then
                system:addEntity(e)
            end
        end
    end,
    removeSystem = function (self, system)
        local rsl
        if type(system) == "string" then
            rsl = self.systems[system]
            assert(rsl, ("System \"%s\" doesn't exist!"):format(system))
            self.systems[system] = nil
        else
            rsl = self.systems[system.name]
            assert(rsl, ("System \"%s\" doesn't exist!"):format(system.name))
            self.systems[system.name] = nil
        end
        return rsl
    end,
    registerCallback = function (self, key)
        if not self.callback[key] then
            self.callback[key] = {}
        end
        _G.love[key] = function (...)
            for _, func in pairs(self.callback[key]) do
                func(...)
            end
            for _, v in pairs(self.systems) do
                if v.active then
                    v[key](v, ...)
                end
            end
        end
    end,
    addCallback = function (self, name, callback, idx)
        local list = self.callback[name]
        if not list then
            self.callback[name] = {}
        end
        self.callback[name][idx or #list + 1] = callback
        return idx or #list
    end,
    removeCallback = function (self, name, idx)
        local cb = self.callback[name]
        assert(cb, ("Callback \"%s\" doesn't exist!"):format(name))
        local rsl = cb[idx] or cb[#cb]
        if idx then
            cb[idx] = nil
        else
            cb[#cb] = nil
        end
        return rsl
    end
}
