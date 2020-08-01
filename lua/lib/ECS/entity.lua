local class = _G.class

return class {
    name = "entity",
    __entity = true,
    extend = function (self, rsl, parent, name)
        rsl.name = rsl.name or name
        rsl.parent = parent or nil
        if parent then
            rsl:setParent(parent)
        end
        rsl.component = {}
        rsl.eventManager = {}
        rsl.active = true
        rsl.children = {}
        return rsl
    end,
    getComponents = function (self)
        return self.component
    end,
    existComponent = function (self, name)
        return self.component[name] ~= nil
    end,
    getComponent = function (self, name)
        assert(self:existComponent(name), ("The component \"%s\" doesn't exist"):format(name))
        return self.component[name]
    end,
    getParent = function (self)
        return self.parent
    end,
    setParent = function (self, parent)
        self:getParent():removeChild(self.name)
        self.parent = parent
        parent:addChild(self)
    end,
    addChild = function (self, child)
        assert(child.__entity, "Trying to set a unknown class to entity's children")
        self.children[child.name] = child
    end,
    removeChild = function (self, name)
        assert(self.children[name], "Trying to remove a nil child")
        local child = self.component[name]
        self.children[name] = nil
        return child
    end,
    addComponent = function (self, ...)
        local arg = {...}
        for _, v in pairs(arg) do
            self.component[v.name] = v
        end
    end,
    removeComponent = function (self, ...)
        local removed = {}
        local first = select(1, ...)
        local arg = type(first) == "table" and first or {...}
        for _, name in pairs(arg) do
            local r = self.component[name]
            removed[#removed + 1] = r
            self.component[name] = nil
        end
        return removed
    end
}