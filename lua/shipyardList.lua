local p = {}
local shipcard = require('Module:ShipCard')

function p.list(frame)
    local shCargo = mw.ext.cargo.query(
        'ships',
        '_pageName,Name,Rarity,Type,ShipID',
        {
            where = "ships.ShipGroup='Research'",
            limit = 1000
        }
    )

    local shList = {}
    for _, sh in ipairs(shCargo) do
        sh.ShipID = tonumber(sh.ShipID) or 0
        table.insert(shList, sh)
    end

    table.sort(shList, function(a, b)
        return a.ShipID < b.ShipID
    end)

    local ships = mw.html.create('div')
        :wikitext(shipcard.templatestyles(frame))

    local count = 0
    -- PR1 and PR2 have 6 ships
    local break_after = { 6, 6 }
    local batch_index = 1

    for i, ship in ipairs(shList) do
        count = count + 1
        ship.Small = true
        ship.Link = ship._pageName
        ships:shipCard(ship)

        -- break after every season
        local break_at = break_after[batch_index] or 5
        if count == break_at then
            ships:tag('br')
            count = 0
            batch_index = batch_index + 1
        end
    end

    return tostring(ships)
end

return p
