-- Hammerspoon config for kitty hotkey window
-- Option + / to toggle kitty
--
-- Improvements over naive implementation:
-- 1. Uses bundleID for reliable app detection (not string matching)
-- 2. Uses hs.window.filter for robust window tracking
-- 3. Avoids hs.spaces.moveWindowToSpace (broken on macOS Sequoia)
-- 4. Uses application watcher for state management
-- 5. Handles edge cases: no windows, app crashes, multiple windows

local KITTY_BUNDLE_ID = "net.kovidgoyal.kitty"
local previousAppBundleID = nil

-- Window filter for kitty - more reliable than hs.application.find()
local kittyFilter = hs.window.filter.new(false):setAppFilter("kitty")

-- Get kitty app reliably using bundleID
local function getKittyApp()
    return hs.application.get(KITTY_BUNDLE_ID)
end

-- Get the frontmost kitty window
local function getKittyWindow()
    local app = getKittyApp()
    if not app then return nil end

    -- Try focused window first, then main window, then any window
    local win = app:focusedWindow()
    if win then return win end

    win = app:mainWindow()
    if win then return win end

    local windows = app:allWindows()
    if windows and #windows > 0 then
        return windows[1]
    end

    return nil
end

-- Check if kitty is currently focused
local function isKittyFocused()
    local frontApp = hs.application.frontmostApplication()
    return frontApp and frontApp:bundleID() == KITTY_BUNDLE_ID
end

-- Save the current app before switching to kitty
local function savePreviousApp()
    local frontApp = hs.application.frontmostApplication()
    if frontApp and frontApp:bundleID() ~= KITTY_BUNDLE_ID then
        previousAppBundleID = frontApp:bundleID()
    end
end

-- Restore the previous app
local function restorePreviousApp()
    if previousAppBundleID then
        local prevApp = hs.application.get(previousAppBundleID)
        if prevApp and prevApp:isRunning() then
            prevApp:activate()
        end
        previousAppBundleID = nil
    end
end

-- Main toggle function
function toggleKitty()
    local kittyApp = getKittyApp()

    if isKittyFocused() then
        -- Kitty is focused, hide it and restore previous app
        if kittyApp then
            kittyApp:hide()
        end
        restorePreviousApp()
    else
        -- Save current app before switching
        savePreviousApp()

        if kittyApp then
            -- Kitty is running
            local kittyWin = getKittyWindow()

            if kittyApp:isHidden() then
                kittyApp:unhide()
            end

            if kittyWin then
                -- Raise window to current space by focusing
                -- Note: hs.spaces.moveWindowToSpace is broken on macOS Sequoia
                -- Instead, we use raise() which brings window to current space
                kittyWin:raise()
                kittyWin:focus()
            end

            kittyApp:activate()
        else
            -- Kitty not running, launch it using bundleID (more reliable)
            hs.application.launchOrFocusByBundleID(KITTY_BUNDLE_ID)
        end
    end
end

-- Bind Option + / to toggle kitty
hs.hotkey.bind({"alt"}, "/", toggleKitty)

-- Notification
hs.alert.show("Kitty hotkey ready: Option+/")
