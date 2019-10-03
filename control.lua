require "constants"
require "state"
require "utils"
require "functions"

script.on_init(function()        
    safe(onInit) 
end)

script.on_event(defines.events.on_lua_shortcut, function(event)
    safe(onToggleEnable, event.player_index)
end)

script.on_event(on_toggle_enable, function(event)
    safe(onToggleEnable, event.player_index)
end)

script.on_event(defines.events.on_built_entity, function(event)
    safe(onBuildGhostEntity, event)
end)

script.on_event(on_toggle_debug, function()
    safe(onToggleDebug)
end)
