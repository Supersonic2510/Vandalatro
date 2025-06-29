SMODS.Seal {
    key = "grandpas_pill",
    badge_colour = HEX("2C2C2C"),

    -- Sprite sheet position (based on seals.png at 71x95 grid)
    atlas = "seals",
    pos = { x = 0, y = 0 },

    unlocked = true,
    discovered = true,

    config = {
        extra = {
            repetitions = 1
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                (card.ability and card.ability.seal and card.ability.seal.repetitions)
                or self.config.extra.repetitions or 1
            },
            key = "se_vandal_grandpas_pill",
            set = "Other",
        }
    end,

    calculate = function(self, card, context)
        -- TODO: Fix, now retrigger all jokers uppon scoring
        if context.retrigger_joker_check and not context.retrigger_joker then
            return {
                retrigger_joker = card,
                repetitions = (card.ability and card.ability.seal and card.ability.seal.repetitions)
                                or self.config.extra.repetitions or 1,
            }
        end
    end
}
