
local function getUniqueName(entity)
    if #entity.surface.get_train_stops({ name = entity.backer_name }) > 1 then
        entity.surface.print("Same name as existing train stop")
        local length = string.len(entity.backer_name)
        local suffix = tonumber(string.sub(entity.backer_name, length - 1, length))
        if suffix ~= nil then
            local suffixLength = string.len(suffix)
            suffix = suffix + 1
            entity.backer_name = string.sub(entity.backer_name, 1, length - suffixLength) .. tostring(suffix)
        else
            suffix = "01"
            entity.backer_name = entity.backer_name .. tostring(suffix)
        end
        getUniqueName(entity)
    end
end

for _,surface in pairs(game.surfaces) do
    outpostStations = surface.find_entities_filtered{name = "outpost-train-stop"}
    meStations = surface.find_entities_filtered{name = "me-train-stop"}
    meCombinators = surface.find_entities_filtered{name = "me-combinator"}
    ghostCombinators = surface.find_entities_filtered{name = "rp-combinator"}

    for _,station in pairs(meStations) do
        getUniqueName(station)
        global.me_stops = global.me_stops or {}
        global.me_stops[station.unit_number] = global.me_stops[station.unit_number] or {}
        global.me_stops[station.unit_number].entity = station
    end

    for _,station in pairs(outpostStations) do
        global.outpost_stops = global.outpost_stops or {}
        getUniqueName(station)
        global.outpost_stops[station.unit_number] = global.outpost_stops[station.unit_number] or {}
        global.outpost_stops[station.unit_number].entity = station
        global.outpost_stops[station.unit_number].tick = game.tick + (3600 * settings.global["ghost-refresh"].value)
    end

    for _,combinator in pairs(meCombinators) do
        global.me_combinators = global.me_combinators or {}
        global.me_combinators[combinator.unit_number] = global.me_combinators[combinator.unit_number] or {}
        global.me_combinators[combinator.unit_number].entity = combinator
        update_me_combo()
    end

    for _,combinator in pairs(ghostCombinators) do
        global.rp_combinators = global.ep_combinators or {}
        global.rp_combinators[combinator.unit_number] = global.rp_combinators[combinator.unit_number] or {}
        global.rp_combinators[combinator.unit_number].entity = combinator
        refresh_ghost_count(combinator)
    end
end