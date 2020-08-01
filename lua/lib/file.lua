return {
    write = function (path, content, mode, wmode)
        if mode == "io" then
            local f, err = io.open(path, wmode or "w+")
            assert(f, err)
            f:write(content)
            f:close()
        elseif mode == "lfs" then
            _G.love.filesystem.write(path, content)
        end
    end,
    read = function (path)
        return _G.love.filesystem.read(path)
    end
}