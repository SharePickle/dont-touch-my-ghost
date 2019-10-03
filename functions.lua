function onInit()        
    echo("DTMG: onInit")
    for i, player in pairs(game.players) do        
        local pstate = getPlayerState(player.index)    
        if player.is_shortcut_available(on_toggle_enable_shortcut) then
            player.set_shortcut_toggled(on_toggle_enable_shortcut, pstate.enabled)
        end
    end    
end

function onToggleEnable(pid) 
    echo("DTMG: onToggleEnable")
    echo_var(event)
    local pstate = getPlayerState(pid)
    pstate.enabled = not pstate.enabled
    if (pstate.enabled) then
        echo("DTMG: onToggleEnable - enabled")
    else 
        echo("DTMG: onToggleEnable - disabled")
        restoreGhosts(pid)
    end
    game.players[pid].set_shortcut_toggled(on_toggle_enable_shortcut, pstate.enabled)
end

function restoreGhosts(pid)  
    echo("DTMG: restoreGhosts")
    echo_var(event)
    local pstate = getPlayerState(pid)
    for key,value in pairs(pstate.ghosts) do                
        local item = pstate.ghosts[key]
        if (item ~= nil and item.e ~= nil and item.f ~= nil and item.e.valid and item.f.valid) then
            item.e.force = item.f -- restore original force                    
        end                      
    end
    pstate.ghosts = {} -- remove all references            
    echo("DTMG: restoreGhosts - restored")                     
end

function onBuildGhostEntity(event)
    echo("DTMG: onBuildGhostEntity")
    echo_var(event)
    local pid = event.player_index    
    local pstate = getPlayerState(pid)
    if (not pstate.enabled) then        
        echo("DTMG: onBuildGhostEntity - disabled")
        return
    end        

    local entity = event.created_entity                         
    if (event.created_entity.name == "entity-ghost" and entity.force) then                      
        local force = entity.force -- orignal force        
        entity.force = "neutral" -- hack
        local meta = { e = entity, f = force  }
        table.insert(pstate.ghosts, meta)                
        echo("DTMG: onBuildGhostEntity - saved")
        echo_var(meta)
    end    
end

function onToggleDebug()
    echo("DTMG: onToggleDebug")
    local lstate = getLocalState()
    lstate.debug = not lstate.debug
    
    if (lstate.debug) then
        echo("DTMG: onToggleDebug - enabled")
    end
end
