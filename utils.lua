function safe(func, param)     
    xpcall(
        func, 
        function(err)      
            game.print({"dtmg-messages.dont-touch-my-ghost-error"})
            game.print(err)
        end,
        param
    )    
end

function echo_var(var)
    echo(serpent.block(var))
end

function echo(str)
    local lstate = getLocalState()
    if (lstate.debug) then
        game.print(str)
    end
end
