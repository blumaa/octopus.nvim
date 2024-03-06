local Octopus = {}

-- List to store octopuses
Octopus.octopusList = {}

-- Default octopus configuration
local defaultConfig = {
    character = "🐙",
    speed = 10,
    width = 2,
    height = 1,
    color = "none",
    blend = 100
}

-- Function to move an octopus in a random direction
local function moveOctopus(octopus, speed)
    local timer = vim.loop.new_timer()
    local newOctopus = { name = octopus, timer = timer }
    table.insert(Octopus.octopusList, newOctopus)

    local movePeriod = 1000 / (speed or defaultConfig.speed)
    vim.loop.timer_start(timer, 1000, movePeriod, vim.schedule_wrap(function()
        if vim.api.nvim_win_is_valid(octopus) then
            local config = vim.api.nvim_win_get_config(octopus)
            local col, row = config["col"][false], config["row"][false]

            math.randomseed(os.time() * octopus)
            local angle = 2 * math.pi * math.random()
            local s = math.sin(angle)
            local c = math.cos(angle)

            -- Update row and col based on direction
            config["row"] = row + 0.5 * s
            config["col"] = col + 1 * c

            -- Move the octopus to the new position
            vim.api.nvim_win_set_config(octopus, config)
        end
    end))
end

-- Function to spawn a new octopus
Octopus.spawn = function(character, speed, color)
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, 1, true, { character or defaultConfig.character })

    local octopus = vim.api.nvim_open_win(buf, false, {
        relative = 'cursor',
        style = 'minimal',
        row = 1,
        col = 1,
        width = defaultConfig.width,
        height = defaultConfig.height
    })

    vim.cmd("hi Octopus" .. octopus .. " guifg=" .. (color or defaultConfig.color) .. " guibg=none blend=" .. defaultConfig.blend)
    vim.api.nvim_win_set_option(octopus, 'winhighlight', 'Normal:Octopus' .. octopus)

    -- Start moving the octopus
    moveOctopus(octopus, speed)
end

-- Function to remove the last octopus
Octopus.removeLastOctopus = function()
    local lastOctopus = Octopus.octopusList[#Octopus.octopusList]

    if not lastOctopus then
        vim.notify("No octopus to remove!")
        return
    end

    local octopus = lastOctopus['name']
    local timer = lastOctopus['timer']
    table.remove(Octopus.octopusList, #Octopus.octopusList)
    timer:stop()

    vim.api.nvim_win_close(octopus, true)
end

-- Function to remove all octopuses
Octopus.removeAllOctopuses = function()
    if #Octopus.octopusList <= 0 then
        vim.notify("No octopus to remove!")
        return
    end

    while (#Octopus.octopusList > 0) do
        Octopus.removeLastOctopus()
    end
end

-- Function to set up octopus configurations
Octopus.setup = function(opts)
    defaultConfig = vim.tbl_deep_extend('force', defaultConfig, opts or {})
end

return Octopus

