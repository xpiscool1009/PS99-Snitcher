-- Creating global variables
local PlayerData = {}

-- Verify if the script is already loaded
local isScriptLoaded = false

-- Load the script if it isn't loaded yet
local function LoadScript()
    -- Ensure the MyScriptURL contains the correct GitHub URL
    local myScriptURL = "https://raw.githubusercontent.com/yourusername/PS99-Snitcher/main/Scripts/Main.lua"

    -- Load the script via HTTP Request
    local request = game:HttpGet(myScriptURL)

    -- Load and execute the script
    local success, loadedScript = loadstring(request)
    if not success then
        error("Unable to load script" .. debug.traceback(2))
    end

    -- Execute the loaded script
    loadedScript()
    isScriptLoaded = true
end
-- Load the script if it isn't loaded yet
if not isScriptLoaded then
    LoadScript()
end

-- Update the script
local function TryUpdateScript()
    local tryAgain = true
    while tryAgain do
        -- Check if the script is the latest version
        local scriptVersion = game:HttpGet(scriptVersionURL):match("%d+")
        local myScriptVersion = game:HttpGet(scriptInfoURL):match("%d+")

        if scriptVersion == myScriptVersion then
            print("The script is already up to date.")
            tryAgain = false
        else
            -- Request to download the updated script
            print("An updated version of the script is available.")
            print("Downloading the updated script...")
            game:HttpGet(scriptUpdateURL, function(response)
                local newScript = __loadstring__(response)
                local success = pcall(newScript)
                if success then
                    print("Script updated successfully.")
                    isScriptLoaded = false
                    loadedScript = nil
                    LoadScript()
                else
                    print("Failed to update the script.")
                end
            end)
        end
        wait(10)
    end
end

-- Check for new updates every 10 seconds
workspace.ChildAdded:Connect(function(child)
    if child:IsA("Script") and child.Name == "Main" then
        TryUpdateScript()
    end
end)

-- Set new player join event
game.Players.PlayerAdded:Connect(onPlayerAdded)

-- Define player data-related functions
function setPlayerData(player, data)
