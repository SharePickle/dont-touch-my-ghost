function printerror(err)
    game.print("DTMG: Oops, looks like Don't touch my ghost just crashed: " .. err)
end

dtmg = {
    references = {
        entities = {},
    },
    events = {
        on_toggle_debug = "dont-touch-my-ghost-debug",
        on_toggle_enable = "dont-touch-my-ghost-enable",
        on_toggle_enable_shortcut = "dont-touch-my-ghost-enable-shortcut",
    },
    settings = {
        isDebug = false,
        enabled = {},        
    },
    utils = {
        write = function (message)
            xpcall(function() 
                if (not dtmg.settings.isDebug) then
                    log(message)
                else
                    game.print(message)            
                end
            end, printerror)       
        end        
    },
    handlers = {        
        -- player-specific enable/disable
        isEnabled = function(pid) 
            if (not dtmg.settings.enabled[pid]) then
                dtmg.settings.enabled[pid] = false
            end
            return dtmg.settings.enabled[pid]
        end,

        -- handle shortcuts
        shortcut = function(event)
            xpcall(function() 
                dtmg.utils.write("shortcut")
                if (event.prototype_name == dtmg.events.on_toggle_enable_shortcut) then
                    dtmg.handlers.on_toggle_enable(event)
                end
            end, printerror)      
        end,

        -- when entity-ghost building is being placed in "planning mode" - change it's force to neutral
        on_built_entity = function(event)   
            xpcall(function() 
                dtmg.utils.write("on_built_entity")
                local pid = event.player_index
                if (not dtmg.handlers.isEnabled(pid)) then
                    dtmg.utils.write("Planning mode is disabled")
                    return
                end    

                -- only if building ghost entity and it has a force
                local entity = event.created_entity                         
                if (event.created_entity.name == "entity-ghost" and entity.force) then                      
                    local force = entity.force -- orignal force
                    dtmg.utils.write("entity: " .. entity.ghost_name)                    
                    entity.force = "neutral"                                                
                    dtmg.handlers.save_entity({ e = entity, f = force  }, pid)
                end
            end, printerror)            
        end,

        -- toggles debug mode
        on_toggle_debug = function()
            xpcall(function() 
                dtmg.utils.write("on_toggle_debug")   

                dtmg.settings.isDebug = not dtmg.settings.isDebug    
            end, printerror)                         
        end,

        -- toggles Planning mode
        on_toggle_enable = function(event)
            xpcall(function() 
                dtmg.utils.write("on_toggle_enable") 
                local pid = event.player_index                
                local isEnabledNow = dtmg.handlers.isEnabled(pid)                
                dtmg.settings.enabled[pid] = not dtmg.settings.enabled[pid]
                if (dtmg.handlers.isEnabled(pid)) then
                    game.players[pid].print({"dtmg-messages.dont-touch-my-ghost-enabled"})              
                else
                    game.players[pid].print({"dtmg-messages.dont-touch-my-ghost-disabled"})                                  
                    dtmg.handlers.restore_entities(pid)
                end
                game.players[pid].set_shortcut_toggled(dtmg.events.on_toggle_enable_shortcut, dtmg.handlers.isEnabled(pid))
            end, printerror) 
        end,

        -- adds entity reference to a player's references list
        save_entity = function(entity, pid)
            xpcall(function() 
                dtmg.utils.write("save_entity") 
                if (not dtmg.references.entities[pid]) then
                    dtmg.references.entities[pid] = {}
                end
                table.insert(dtmg.references.entities[pid], entity)
            end, printerror)    
        end,

        -- restores entities back to a normal states allowing robots to finish the job
        restore_entities = function(pid)
            xpcall(function() 
                dtmg.utils.write("clear_entities") 
                if (dtmg.references.entities[pid]) then
                    for key,value in pairs(dtmg.references.entities[pid]) do
                        xpcall(function() -- try catch for every item just in case
                            local item = dtmg.references.entities[pid][key]
                            if (item ~= nil and item.e ~= nil and item.f ~= nil and item.e.valid and item.f.valid) then
                                item.e.force = item.f -- assign original force to an entity                                
                            end
                        end, printerror)      
                    end
                    dtmg.references.entities[pid] = {} -- remove all references                   
                end                
            end, printerror)               
        end,
    }
}
