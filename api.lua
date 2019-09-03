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
        isEnabled = false
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
                if (not dtmg.settings.isEnabled) then
                    dtmg.utils.write("Planning mode is disabled")
                    return
                end    

                -- only if building ghost entity and it has a force
                local entity = event.created_entity                         
                if (event.created_entity.name == "entity-ghost" and entity.force) then                      
                    local pid = event.player_index
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
                dtmg.settings.isEnabled = not dtmg.settings.isEnabled                            
                if (dtmg.settings.isEnabled) then
                    game.print("DTMG: Planning mode enabled.")              
                else
                    game.print("DTMG: Planning mode disabled.")                                  
                    dtmg.handlers.restore_entities(event.player_index)
                end
                game.players[event.player_index].set_shortcut_toggled(dtmg.events.on_toggle_enable_shortcut, dtmg.settings.isEnabled)
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
