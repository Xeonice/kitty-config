-- Hammerspoon config for kitty hotkey window
-- Option + / to toggle kitty

local previousApp = nil  -- Remember previous app before showing kitty

function toggleKitty()
    local kittyApp = hs.application.find("kitty")
    local frontApp = hs.application.frontmostApplication()

    if kittyApp and kittyApp:isFrontmost() then
        -- Kitty is focused, hide it and return to previous app
        kittyApp:hide()

        -- Switch back to previous app (with error handling)
        pcall(function()
            if previousApp and previousApp:isRunning() then
                previousApp:activate()
            end
        end)
        previousApp = nil
    else
        -- Remember current app before switching to kitty (with error handling)
        pcall(function()
            if frontApp and frontApp:name() ~= "kitty" and frontApp:isRunning() then
                previousApp = frontApp
            end
        end)

        if kittyApp then
            -- Kitty exists, show it
            if kittyApp:isHidden() then
                kittyApp:unhide()
            end

            -- Move to current space and focus
            local kittyWin = kittyApp:mainWindow()
            if kittyWin then
                pcall(function()
                    local currentSpace = hs.spaces.focusedSpace()
                    if currentSpace then
                        hs.spaces.moveWindowToSpace(kittyWin, currentSpace)
                    end
                end)
                kittyWin:focus()
            end
            kittyApp:activate()
        else
            -- Kitty not running, launch it
            hs.application.launchOrFocus("/Applications/kitty.app")
        end
    end
end

-- Bind Option + / to toggle kitty
hs.hotkey.bind({"alt"}, "/", toggleKitty)

-- Notification
hs.alert.show("Kitty hotkey ready: Option+/")
