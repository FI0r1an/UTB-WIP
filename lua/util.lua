return {
    getRealName = function (name, dic)
        local rsl = name
        for i = 1, #rsl do
            rsl[i] = dic .. "/" .. rsl[i]
        end
        return rsl
    end
}