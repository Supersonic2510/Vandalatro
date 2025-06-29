SMODS.Consumable {
    key = "prescribed_memory", 
    set = "Spectral",
    cost = 4,
    unlocked = true,
    discovered = true,

    -- Sprite sheet position (based on spectrals.png at 71x95 grid)
    atlas = "spectrals",
    pos = { x = 0, y = 0 },

    -- Add this Consumable to the general Spectral pool
    pools = {
        ["Spectral"] = true
    },

    config = {
        max_highlighted = 1,
    },

    -- Provides dynamic tooltip variable substitution
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_SEALS.vandal_grandpas_pill
        info_queue[#info_queue+1] = G.P_CENTERS.e_vandal_old_age
        return {
            vars = {
                colours = {
                    SMODS.Seals["vandal_grandpas_pill"].badge_colour,
                }
            },
            key = "s_vandal_prescribed_memory",
            set = "Spectral",
        }
    end,

    can_use = function(self, card)
        local sel = G.jokers.highlighted or {}
        -- Solo permite si hay entre 1 y max_highlighted Jokers seleccionados y todos son Jokers
        if #sel == 0 or #sel > (card.ability.max_highlighted or 1) then
            return false
        end

        -- Si hemos llegado hasta aquí, es válido
        return true
    end,

    use = function(self, card, area, copier)
        for i = 1, math.min(#G.jokers.highlighted, card.ability.max_highlighted) do
            G.E_MANAGER:add_event(Event({func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true end }))
            
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                G.jokers.highlighted[i]:set_seal("vandal_grandpas_pill", true, true)
                G.jokers.highlighted[i]:set_edition("e_vandal_old_age", true, true)
                return true end }))
            
            delay(0.5)
        end
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.jokers:unhighlight_all(); return true end }))
    end,
}