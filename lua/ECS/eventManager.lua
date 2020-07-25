local class = _G.class

return class {
    events = {},
    addEvent = function (self, event)
        assert(event.__event, "The event must be inherited from event class")
        local name = event.name
        assert(not self.events[name], ("The event \"%s\" does exist"):format(name))
        self.events[name] = event
        return event
    end,
    removeEvent = function (self, name)
        assert(self.events[name], ("The event \"%s\" doesn't exist"):format(name))
        local rsl = self.events[name]
        self.events[name] = nil
        collectgarbage"collect"
        return rsl
    end,
    replaceEvent = function (self, event)
        local old = self:removeEvent(event.name)
        self:addEvent(event)
        return old
    end,
    fire = function (self, name)
        local event = self.events[name]
        assert(event, ("The event \"%s\" doesn't exist"):format(name))
        event:fire()
    end,
    tryFire = function (self, name)
        local event = self.events[name]
        if event then
            event:fire()
        end
    end
}