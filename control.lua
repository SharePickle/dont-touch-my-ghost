require "api"

script.on_event(defines.events.on_lua_shortcut, dtmg.handlers.shortcut)
script.on_event(defines.events.on_built_entity, dtmg.handlers.on_built_entity)

script.on_event(dtmg.events.on_toggle_debug, dtmg.handlers.on_toggle_debug)
script.on_event(dtmg.events.on_toggle_enable, dtmg.handlers.on_toggle_enable)
