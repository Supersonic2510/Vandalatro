-- Register the sprite atlas for your Joker cards
SMODS.Atlas {
    key = "jokers",
    path = "jokers.png",
    px = 71,
    py = 95
}

-- Load your custom Joker module
SMODS.load_file("jokers/choese.lua")()

-- Register all sounds in assets/sounds/ directory
-- SMODS.Sound:register_global()

SMODS.handle_loc_file("localization")