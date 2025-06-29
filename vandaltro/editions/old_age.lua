-- Register the custom sound "old_age" (must exist at assets/sounds/old_age.ogg)
SMODS.Sound {
    key = "old_age_sound",
    path = "old_age.ogg",
}

SMODS.Shader{
    key = "sepia",
    path = "sepia.fs",
}

SMODS.Edition {
    key = "old_age",
    badge_colour = HEX("9B6025"),
    shader = "sepia",
    sound = false, --{ sound = "foil1", per = 1.2, vol = 0.4 },

    unlocked = true,
    discovered = true,
    in_shop = false,

    config = {
        extra = {
            odds = 10,
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                G.GAME.probabilities.normal,
                self.config.extra.odds,
            },
            key = "ed_vandal_old_age",
            set = "Edition",
        }
    end,

    calculate = function(self, card, context)
        -- Not triggered
        if context.after then
            if pseudorandom("old") < (G.GAME.probabilities.normal / self.config.extra.odds) then
                return {
                    colour = G.C.BLACK,
                    message = localize{
                        type = "variable",
                        key = "ed_vandal_k_old_age_destroy",
                        vars = { 
                            card.label or "Joker",
                        },
                    },
                    sound = "vandal_old_age_sound",
                    remove = true,
                    destroy_card = card,
                    SMODS.destroy_cards({card}),
                }
            end
        end
    end,
}