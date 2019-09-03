data:extend({
    {
        type = "custom-input",
        name = "dont-touch-my-ghost-debug",
        key_sequence = "CONTROL + SHIFT + D",
    },
    {
        type = "custom-input",
        name = "dont-touch-my-ghost-enable",
        key_sequence = "CONTROL + SHIFT + G",
    },
    {
        type = "shortcut",
        name = "dont-touch-my-ghost-enable-shortcut",
        order = "zzz",
        action = "lua",
        toggleable = true,
        icon =
        {
            filename = "__dont-touch-my-ghost__/icons/enable-icon.png",
            priority = "extra-high-no-scale",
            size = 32,
            scale = 1,
            flags = { "icon" }
        },
        small_icon =
        {
            filename = "__dont-touch-my-ghost__/icons/enable-icon-small.png",
            priority = "extra-high-no-scale",
            size = 24,
            scale = 1,
            flags = {"icon"}
        },
        disabled_small_icon =
        {
            filename = "__dont-touch-my-ghost__/icons/enable-icon-small.png",
            priority = "extra-high-no-scale",
            size = 24,
            scale = 1,
            flags = {"icon"}
        },
    },    
})
