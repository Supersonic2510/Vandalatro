-- Register the sprite atlas for your Joker cards
SMODS.Atlas {
    key = "jokers",
    path = "jokers.png",
    px = 71,
    py = 95
}

-- Register the sprite atlas for your Spectral cards
SMODS.Atlas {
    key = "spectrals",
    path = "spectrals.png",
    px = 71,
    py = 95
}

-- Register the sprite atlas for your Seals
SMODS.Atlas {
    key = "seals",
    path = "seals.png",
    px = 71,
    py = 95
}

-- Load your custom Joker module
SMODS.load_file("jokers/choese.lua")()

SMODS.load_file("consumables/prescribed_memory.lua")()

SMODS.load_file("seals/grandpas_pill.lua")()

SMODS.load_file("editions/old_age.lua")()

SMODS.handle_loc_file("localization")

SMODS.current_mod.optional_features = function()
    return {
        retrigger_joker = true,
    }
end
