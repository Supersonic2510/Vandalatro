-- Register the custom sound "choese" (must exist at assets/sounds/choese.ogg)
SMODS.Sound {
    key = "choese_sound",
    path = "choese.ogg"
}

-- Define the custom Joker card "Choese"
SMODS.Joker {
    -- Internal identifier (must be unique)
    key = "choese",

    -- Sprite sheet position (based on jokers.png at 71x95 grid)
    atlas = "jokers",
    pos = { x = 0, y = 0 },

    -- Rarity level: 3 = Rare
    rarity = 3,

    -- Set cost to $3
    cost = 3,

    -- Add this Joker to the general Joker pool
    pools = {
        ["Joker"] = true
    },

    -- Make it availabe from start
    unlocked = true,
    discovered = true,

    -- Optional config (not used)
    config = {},

    -- Compatibility flags
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,

    -- Called once when the Joker is first added to the player's deck
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.choese_bonus = 1               -- Total accumulated multiplier
        card.ability.this_discard_bonus = 0         -- Cards discarded during current discard
        card.ability.three_counter = 0              -- Count of 3s discarded during current discard
    end,

    -- Provides dynamic tooltip variable substitution
    loc_vars = function(self, info_queue, card)
        -- TODO: Add info_queue to credit Joker artist
        -- info_queue[#info_queue+1] = 
        return {
            vars = {
                card.ability.choese_bonus or 1       -- Replaces {#1#} in description
            },
            key = "j_vandal_choese",
            set = "Joker",
        }
    end,

    -- Called automatically by the game in many gameplay contexts
    calculate = function(self, card, context)

        -- Reset bonus when transitioning to a new round (new level)
        if context.round_resets then
            card.ability.choese_bonus = 1
            card.ability.this_discard_bonus = 0
            card.ability.three_counter = 0
        end

        -- Called for each card discarded
        if context.discard and context.other_card then
            -- Add each discarted card
            card.ability.this_discard_bonus = card.ability.this_discard_bonus + 0.25

            if tonumber(context.other_card.base.value) == 3 then
                card.ability.three_counter = card.ability.three_counter + 1
            end

            -- If last hand's card
            local all = context.full_hand or {}
            if #all > 0 and context.other_card == all[#all] then
                local n = card.ability.this_discard_bonus
                local t = card.ability.three_counter
                local base_bonus = card.ability.choese_bonus + n

                card.ability.choese_bonus = base_bonus * (2 ^t)

                -- Partial reset (keep choese bonus for scoring)
                card.ability.this_discard_bonus = 0
                card.ability.three_counter = 0

                return {
                    message = localize{
                        type = "variable",
                        key = "j_vandal_k_choese_calc",
                        vars = { 
                            card.ability.choese_bonus or 1,
                        },
                    },
                    sound = "generic1"
                }
            end
        end

        -- Apply bonus during scoring
        if context.joker_main and card.ability.choese_bonus > 1 then
            -- Apply multiplier only
            local final_mult = card.ability.choese_bonus

            -- Reset
            card.ability.choese_bonus = 1

            return { 
                xmult = final_mult,
                message = localize{
                    type = "variable",
                    key = "j_vandal_k_choese_triggered",
                },
                sound = "vandal_choese_sound",
            }
          
            end
    end,
}
