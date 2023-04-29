# CAI (Centralized Alias Interface)

**CAI (Centralized Alias Interface)** is a shell script written in Zsh and intended for managing macOS utilities such as Wi-Fi, Bluetooth, git, files on macOS.

*CAI* is divided into a few **Alias Groups (AG)** like below:

1. __wifi__
    AG that helps to work with Wi-Fi interface.

2. __bluetooth__
    AG that helps to work with Bluetooth interface.

3. __files__
    AG that stores your aliases to make your work easier with files and directories.

4. __git__
    AG that stores your aliases to make your work easier with Git.

They are intended being divided by different kinds of aliases and functions **semantically** and for a small optimization instead of sourcing all the code every time when it's not really needed...

## Dependencies

1. __blueutil__ (if you don't have this utility, you need to install it via [homebrew PM](https://formulae.brew.sh/formula/blueutil))

## Installation
1. Make sure that you installed [homebrew](https://brew.sh) and [blueutil](https://formulae.brew.sh/formula/blueutil) from there.

2. Clone the repository or download the ZIP file:
    `git clone https://github.com/devshok/CAI.git`

3. Move `.cai` folder inside to `~/` directory:
    `mv cai/.cai ~/`

4. Open your `.zshrc` file at the root and write the next lines:
    `source ~/.cai/.cai.zsh`
    `cai run`

5. Restart your terminal and then you're ready to start!

## Usage

### wifi
Let's say, you want to turn on Wi-Fi:
    `wifi on`
    
And then you want to get a list of Wi-Fi networks around your machine:
    `wifi scan`
    
You found that one and thought you want to connect it:
    `wifi connect YOUR-HOME-WIFI Password123456Aa`
    
Don't want to connect typing all the name and password every time? No problem!
    `wifi save home YOUR-HOME-WIFI Password123456Aa`
    
And use your new alias like that:
    `wifi connect home`
    
CAI provides much more Wi-Fi-related commands. To see a list of these commands, type:
    `wifi help`
    
### bluetooth
Like Wi-FI, we can turn it on (or off):
    `bluetooth on`
    
And get the list of paired devices with your machine:
    `bluetooth list all`
    
Found that one you want to connect? Connect by MAC-address:
    `bluetooth connect 5b-a6-a6-c5-f5-31`
    
And save it by creating a handful alias you like:
    `bluetooth save airpods 5b-a6-a6-c5-f5-31`
    
Then, you'll be able to manipulate with your device like that:
    `bluetooth disconnect airpods`
    
Or vice-versa:
    `bluetooth connect airpods`
    
Get more commands:
    `bluetooth help`
    
### files

That is just a separate file that is intended to keep your aliases for working with files, directories and apps. To see and edit it, use:
`cai edit files`

Then update changes without reloading a terminal:
`cai update files`
    
### git

Like *Files AG*, **Git AG** serves to keep aliases that make your work with git easier.
Use `cai edit git` to see and edit git aliases. Then `cai update git` to update changes.

## Editing
To edit any file like configuration of Wi-Fi aliases, or something else, use this:
`cai edit [option]`

**Option** defines what exactly you want to see and edit. Even `CAI` itself it can be! Feel free to explore and edit using this line:
`cai edit help`

## Updating (Sourcing)
Zsh environment works as any scripts you might want to run, should be sourced (compiled). That's why there's `cai update [option]` command provided.

Check options using this line:
`cai update help`

## Default Editor
Define your own favorite editor for modifying the source code.
By default it's built-in **nano** editor on macOS.

To set your editor, use this command:
`cai set [editor]`

Check available editors using this:
`cai set help`

Get the current editor specified by default or by you:
`cai get editor`

There's a list of prepared editors in the configuration but if you want to add your own one and then use it, first open the configuration file and edit it whatever you like:
`cai edit config`

After changes update it:
`cai update config`

## CAI Files Organization

It's intended to be stored in the root directory (at `~`). There you can notice `.cai` folder that keeps:
- `.cai.zsh` — The centralized interface for editing and updating all AG and configurations and even itself.
- `.cai.config` — A configuration file with a list of editors and a default editor by user.
- `.wifi_networks.config` — A configuration file with a fave list of Wi-Fi networks saved by user.
- `.bluetooth_devices.config` — A configuration file with a fave list of Bluetooth devices saved by user.
- `ag` folder that stores all AG files.
    - `.wifi.zsh` — Wi-Fi AG.
    - `.bluetooth.zsh` — Bluetooth AG.
    - `.files.zsh` — Files AG.
    - `.git.zsh` — Git AG.

## More details?
`cai help`

## Contribution
If you find a bug or have a suggestion for a new feature, please open an issue on GitHub.
Pull requests are also welcome!

## License

I don't care. Use it whatever you like if somebody finds it useful.