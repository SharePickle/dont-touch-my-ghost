function getPlayerState(pid)
    local name = game.players[pid].name
    if (not global.DONT_TOUCH_MY_GHOST_PLAYER_STATE) then
        global.DONT_TOUCH_MY_GHOST_PLAYER_STATE = { }
    end
    
    if (not global.DONT_TOUCH_MY_GHOST_PLAYER_STATE[name]) then
        global.DONT_TOUCH_MY_GHOST_PLAYER_STATE[name] = {
            enabled = false,
            ghosts = {}            
        }
    end

    return global.DONT_TOUCH_MY_GHOST_PLAYER_STATE[name]
end

local _localState = {
    debug = false
}

function getLocalState()
    return _localState
end
