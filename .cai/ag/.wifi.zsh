#!/bin/zsh

# CONFIGURATION SETUP:

source ~/.cai/.cai.config

# SHORTCUT:

function wf() {
	wifi "$@"
}

# The wifi() function provides a set of subcommands to manage Wi-Fi Interface on macOS.
# It takes one option at a time and performs the appropriate action based on the option selected. 
#
# The available options are as follows:
#
# on: Turn on Wi-Fi interface
# off: Turn off Wi-Fi interface
# scan: Scan Wi-Fi network around the machine.
# status: Show the status of Wi-Fi interface.
# connect: Connect to a specific Wi-Fi network.
# disconnect: Disconnect from a specific Wi-Fi network.
# save: Save a Wi-Fi network to the favorite list
# delete: Remove a Wi-Fi network from the favorite list
# list: List your favorite Wi-Fi networks
# help: Show a help message
#
# Each option may require an additional argument to be passed.
# If the arguments are not passed correctly, an error message will be displayed.

function wifi() {

	# Path to the directory containing CAI scripts and configuration files
	local CAI_PATH="${HOME}/.cai"

	# Name of the configuration file for Wi-Fi networks
	local CONFIG_FILE=".wifi_networks.config"

	# Full path to the Bluetooth devices configuration file
	local CONFIG_FILE_PATH="${CAI_PATH}/${CONFIG_FILE}"

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	print_underline
	#
	# Description:
	# 	This function prints an underline to separate sections of the output.
	#
	local function print_underline() {
		echo "--------------------------------------------"
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	print_empty_line
	#
	# Description:
	# 	Prints an empty line to the console.
	#	This function can be used to add spacing between lines of output or to
	#	break up sections of text in the console.
	#
	local function print_empty_line() {
		echo ""
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function Name: 
	# 	print_error_title
	#
	# Description: 
	# 	Prints an error message with a title and underline to the console using ANSI color codes.
	#
	local function print_error_title() {
		print_empty_line
		echo "$(tput setaf 1)ERROR$(tput sgr0)"
		print_underline
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name: 
	# 	print_success_title
	#
	# Description:
	# 	Prints a success message to the terminal using green text and an underline.
	#
	# Notes:
	#   - Uses the `tput` command to set the terminal text color and formatting.
	#   - Calls the `print_empty_line` and `print_underline` functions to add visual
	#     separation before and after the message.
	#
	local function print_success_title() {
		print_empty_line
		echo "$(tput setaf 2)SUCCESS$(tput sgr0)"
		print_underline
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	print_instructions_to_add_new_fave_network
	#
	# Description:
	#   This function is intended to provide a helpful message to users who want
	# 	to add a new favorite network to the list of known Wi-Fi networks.
	#
	local function print_instructions_to_add_new_fave_network() {
		echo "Need to add any network? Simply use that:"
		print_empty_line
		echo "$(tput setaf 3)\twifi save <Alias name> <Wi-Fi network name> <password>$(tput sgr0)"
		print_empty_line
		echo "For example:"
		print_empty_line
		echo "$(tput setaf 3)\twifi save home 'My\ Home\ Wi-Fi' password1234Hh$(tput sgr0)"
		print_empty_line
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function names:
	#	- print_bad_syntax_title_with_message
	# 	- print_note_for_help
	# 	- print_bad_wifi_name_syntax
	# 	- print_bad_wifi_scan_syntax
	# 	- print_bad_wifi_info_syntax
	# 	- print_bad_wifi_status_syntax
	# 	- print_bad_wifi_turn_on_syntax
	# 	- print_bad_wifi_turn_off_syntax
	#	- print_bad_wifi_connect_syntax
	#	- print_bad_wifi_disconnect_syntax
	#	- print_bad_wifi_ping_syntax
	#	- print_bad_wifi_save_syntax
	#	- print_bad_wifi_delete_syntax
	#	- print_bad_wifi_list_syntax
	#	- print_bad_wifi_help_syntax
	#
	# Description:
	# 	These functions print an error message when there is a bad syntax in the wifi command. 
	# 	It is meant to be used as a helper function for the wifi command functions.
	#

	local function print_bad_syntax_title_with_message() {
		local message=$1
		print_error_title
		echo "Wrong way of using:"
		print_empty_line
		echo "${message}"
		print_empty_line
	}

	local function print_note_for_help() {
		printf "Notes:\n"
		print_empty_line
		printf "\t1. This command can also be abbreviated as \033[1mwf\033[0m instead of \033[1mwifi\033[0m.\n"
		printf "\t2. Use \033[1mwifi help\033[0m to get more instructions.\n"
		if [[ $# -gt 0 ]]; then
			local i=3
			for note in "$@"; do
				printf "\t${i}. ${note}\n"
				((i++))
			done
		fi
		print_empty_line
	}

	local function print_bad_wifi_name_syntax() {
		print_bad_syntax_title_with_message "\t$(tput setaf 3)wifi name$(tput sgr0)"
		print_empty_line
		print_note_for_help "\033[1mwifi name\033[0m is only used without options."
		print_empty_line
	}

	local function print_bad_wifi_scan_syntax() {
		print_bad_syntax_title_with_message "\t$(tput setaf 3)wifi scan$(tput sgr0)"
		print_empty_line
		print_note_for_help "\033[1mwifi scan\033[0m is only used without options."
		print_empty_line
	}

	local function print_bad_wifi_info_syntax() {
		print_bad_syntax_title_with_message "\t$(tput setaf 3)wifi info$(tput sgr0)"
		print_empty_line
		print_note_for_help "\033[1mwifi info\033[0m is only used without options."
		print_empty_line
	}

	local function print_bad_wifi_status_syntax() {
		print_bad_syntax_title_with_message "\t$(tput setaf 3)wifi status$(tput sgr0)"
		print_empty_line
		print_note_for_help "\033[1mwifi status\033[0m is only used without options."
		print_empty_line
	}

	local function print_bad_wifi_turn_on_syntax() {
		print_bad_syntax_title_with_message "\t$(tput setaf 3)wifi on$(tput sgr0)"
		print_empty_line
		print_note_for_help "\033[1mwifi on\033[0m is only used without options."
		print_empty_line
	}

	local function print_bad_wifi_turn_off_syntax() {
		print_bad_syntax_title_with_message "\t$(tput setaf 3)wifi off$(tput sgr0)"
		print_empty_line
		print_note_for_help "\033[1mwifi off\033[0m is only used without options."
		print_empty_line
	}

	local function print_bad_wifi_connect_syntax() {
		print_bad_syntax_title_with_message "\t$(tput setaf 3)wifi connect$(tput sgr0)"
		echo "Usage:"
		print_empty_line
		printf "\t$(tput setaf 3)wifi connect [<Wi-Fi network>|<Alias name>] <Password>$(tput sgr0)\n\n"
		print_empty_line
		echo "Arguments:"
		print_empty_line
		printf "\t\033[1m<Wi-Fi network>\033[0m\tA name of Wi-Fi network that you want to connect.\n"
		printf "\t\033[1m<Alias name>\033[0m\tA shortcut name of Wi-Fi network that you saved in the favorite list. In this case, no need a password.\n"
		printf "\t\033[1m<Password>\033[0m\tA password of Wi-Fi network that you want to connect. No need a password if you're using an alias from the favorite list.\n"
		print_empty_line
		print_note_for_help "Use \033[1mwifi list fave\033[0m to retrieve the list of aliases that you saved to use \033[1mwifi connect\033[0m command."
		echo "Examples:"
		print_empty_line
		printf "\t\033[1mwifi connect home\033[0m\n"
		printf "\t\033[1mwifi connect work\033[0m\n"
		printf "\t\033[1mwifi connect NWF-4532 Qwerty123456\033[0m\n"
		print_empty_line
	}

	local funciton print_bad_wifi_disconnect_syntax() {
		print_bad_syntax_title_with_message "\t$(tput setaf 3)wifi disconnect$(tput sgr0)"
		print_empty_line
		print_note_for_help "\033[1mwifi disconnect\033[0m is only used without options."
		print_empty_line
	}

	local function print_bad_wifi_ping_syntax() {
		print_bad_syntax_title_with_message "\t$(tput setaf 3)wifi ping$(tput sgr0)"
		print_empty_line
		print_note_for_help "\033[1mwifi ping\033[0m is only used without options."
		print_empty_line
	}

	local function print_bad_wifi_save_syntax() {
		print_bad_syntax_title_with_message "\t$(tput setaf 3)wifi save$(tput sgr0)"
		echo "Usage:"
		print_empty_line
		printf "\t$(tput setaf 3)wifi save <Alias name> <Wi-Fi network> <Password>$(tput sgr0)\n\n"
		print_empty_line
		echo "Arguments:"
		print_empty_line
		printf "\t\033[1m<Alias name>\033[0m\tA shortcut name of Wi-Fi network that you wanna save in the favorite list.\n"
		printf "\t\033[1m<Wi-Fi network>\033[0m\tA name of Wi-Fi network that you wana save in the favorite list.\n"
		printf "\t\033[1m<Password>\033[0m\tA password of Wi-Fi network that you wanna save in the favorite list.\n"
		print_empty_line
		print_note_for_help "Use \033[1mwifi list fave\033[0m to retrieve the list of aliases that you saved."
		print_empty_line
		echo "Examples:"
		print_empty_line
		printf "\t\033[1mwifi save home NWF-4532 Qwerty123456\033[0m\n"
		printf "\t\033[1mwifi connect home\033[0m\n"
		print_empty_line
	}

	local function print_bad_wifi_delete_syntax() {
		print_bad_syntax_title_with_message "\t$(tput setaf 3)wifi delete$(tput sgr0)"
		echo "Usage:"
		print_empty_line
		printf "\t$(tput setaf 3)wifi delete <Alias name>$(tput sgr0)\n\n"
		print_empty_line
		echo "Arguments:"
		print_empty_line
		printf "\t\033[1m<Alias name>\033[0m\tA shortcut name of Wi-Fi network that you wanna delete from the favorite list.\n"
		print_empty_line
		print_note_for_help "Use \033[1mwifi list fave\033[0m to retrieve the list of aliases that you saved."
		print_empty_line
		echo "Examples:"
		print_empty_line
		printf "\t\033[1mwifi save home NWF-4532 Qwerty123456\033[0m\n"
		printf "\t\033[1mwifi connect home\033[0m\n"
		printf "\t\033[1mwifi disconnect home\033[0m\n"
		printf "\t\033[1mwifi delete home\033[0m\n"
		print_empty_line
	}

	local function print_bad_wifi_list_syntax() {
		print_bad_syntax_title_with_message "\t$(tput setaf 3)wifi list$(tput sgr0)"
		echo "Usage:"
		print_empty_line
		printf "\t$(tput setaf 3)wifi list [option]$(tput sgr0)\n\n"
		print_empty_line
		echo "Options:"
		print_empty_line
		printf "\t\033[1mfave\033[0m\tA list of favorite Wi-Fi networks that you saved.\n"
		print_empty_line
		print_note_for_help
		echo "Example:"
		print_empty_line
		printf "\t\033[1mwifi list fave\033[0m\n"
		print_empty_line
	}

	local function print_wifi_help() {
		printf "\n\033[1mwifi\033[0m - A command-line tool for managing Wi-Fi interface on macOS.\n\n"
		printf "Usage:\n"
		print_empty_line
		printf "\t$(tput setaf 3)wifi <command> [options]$(tput sgr0)\n\n"
		printf "Commands:\n"
		print_empty_line
		printf "\t\033[1mname\033[0m\t\t\t\t\t\t\tGet a name of your current Wi-Fi network\n"
		printf "\t\033[1mscan\033[0m\t\t\t\t\t\t\tScan Wi-Fi networks around your machine\n"
		printf "\t\033[1minfo\033[0m\t\t\t\t\t\t\tGet the details of your current Wi-Fi connection\n"
		printf "\t\033[1mstatus\033[0m\t\t\t\t\t\t\tShow the status of Wi-Fi interface.\n"
		printf "\t\033[1mon\033[0m\t\t\t\t\t\t\tTurn on the Wi-Fi interface\n"
		printf "\t\033[1moff\033[0m\t\t\t\t\t\t\tTurn off the Wi-Fi interface\n"
		printf "\t\033[1mconnect\033[0m [<Wi-Fi network>|<Alias Name>] <password>\tConnect a Wi-Fi network either by a name and password or by a name in the favorite list\n"
		printf "\t\033[1mdisconnect\033[0m\t\t\t\t\t\tDisconnect your machine from your current Wi-Fi connection\n"
		printf "\t\033[1mping\033[0m\t\t\t\t\t\t\tCheck the Internet connection\n"
		printf "\t\033[1msave\033[0m <Alias name> <Wi-Fi network> <Password>\t\tSave to the favorite list with a alias name\n"
		printf "\t\033[1mdelete\033[0m <Alias name>\t\t\t\t\tDelete a favorite Wi-FI network info from the favorite list using an alias name\n"
		printf "\t\033[1mlist\033[0m [fave]\t\t\t\t\t\tList all favorite Wi-Fi networks you saved before\n"
		printf "\t\033[1mhelp\033[0m\t\t\t\t\t\t\tPrint this page to show you instructions for using 'wifi' command\n\n"
		printf "Note:\n"
		print_empty_line
		printf "\tThis command can also be abbreviated as \033[1mwf\033[0m instead of \033[1mwifi\033[0m.\n"
		print_empty_line
		printf "Examples:\n"
		print_empty_line
		printf "\t\033[1mwifi status\033[0m\t\t\t\t\t\tGet the state of your Wi-Fi interface\n"
		printf "\t\033[1mwifi on\033[0m\t\t\t\t\t\t\tTurn the Wi-Fi interface on if it's turned off\n"
		printf "\t\033[1mwifi connect YOUR-NEW-WIFI yourPassword12345\033[0m\t\tConnect to a new Wi-Fi network using Wi-Fi's name and password\n"
		printf "\t\033[1mwifi save HOME YOUR-NEW-WIFI yourPassword12345\033[0m\t\tSave your home Wi-Fi network onto the favorite list using a short handful name\n"
		printf "\t\033[1mwifi connect HOME\033[0m\t\t\t\t\tAfter saving your home Wi-Fi network, you're able to connect just simply by using a short handful name like 'HOME' for example\n"
		printf "\t\033[1mwifi ping\033[0m\t\t\t\t\t\tCheck the Internet connection\n"
		printf "\t\033[1mwifi list fave\033[0m\t\t\t\t\t\tList all your favorite Wi-Fi networks\n"
		printf "\t\033[1mwifi disconnect\033[0m\t\t\t\t\t\tDisconnect your machine from your current Wi-Fi network\n"
		printf "\t\033[1mwifi delete HOME\033[0m\t\t\t\t\tAnd then you can delete a home Wi-Fi network from your favorite list to forget it\n"
		print_empty_line
		print_empty_line
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	print_unknown_wifi_status
	#
	# Description:
	# 	Prints an error message for unknown wifi status.
	#
	# Arguments:
	# 	- $1: The unknown wifi status to be printed.
	#
	local function print_unknown_wifi_status() {
		print_empty_line
		echo "error: unknown wifi status: ${1}"
		print_empty_line
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	print_wifi_status_on
	#
	# Description:
	# 	Prints a message indicating that Wi-Fi is ON.
	#
	local function print_wifi_status_on() {
		print_empty_line
		echo "Wi-Fi is ON"
		print_empty_line
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	print_wifi_status_off
	#
	# Description:
	# 	Prints a message indicating that Wi-Fi is OFF.
	#
	local function print_wifi_status_off() {
		print_empty_line
		echo "Wi-Fi is OFF"
		print_empty_line
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	get_current_wifi_name
	#
	# Description:
	# 	Gets the name of the currently connected Wi-Fi network.
	#
	local function get_current_wifi_name() {
		local output=$(networksetup -getairportnetwork en0)
		local name=$(echo $output | cut -d':' -f2 | xargs)
		print_empty_line
		echo $name
		print_empty_line
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	get_wifi_status
	#
	# Description:
	# 	Gets the status of Wi-Fi and prints an appropriate message.
	#
	local function get_wifi_status() {
		local output=$(networksetup -getairportpower en0)
		local wifi_status=$(echo $output | cut -d':' -f2 | xargs)
		case $wifi_status in
			"On")
				print_wifi_status_on
				;;
			"Off")
				print_wifi_status_off
				;;
			*)
				print_unknown_wifi_status $wifi_status
				;;
		esac
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	get_wifi_list
	#
	# Description:
	# 	This function lists all available Wi-Fi networks with their respective signal strength and security type.
	#
	# Notes:
	#   - It uses the 'airport' utility to scan for Wi-Fi networks and formats the output using awk and column.
	#
	local function get_wifi_list() {
		print_empty_line
		/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -s
		print_empty_line
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	get_wifi_info
	#
	# Description:
	# 	This function shows detailed information about the Wi-Fi connection, including IP address, subnet mask, and router IP.
	#
	# Notes:
	#   - It uses the 'networksetup' command to retrieve the information.
	#
	local function get_wifi_info() {
		print_empty_line
		local wifi_raw_status=$(networksetup -getairportpower en0)
		local wifi_status=$(echo $wifi_raw_status | cut -d':' -f2 | xargs)
		if [[ "$wifi_status" == "Off" ]]; then
			echo "You're offline. The Wi-Fi interface is turned off."
		else
			networksetup -getinfo Wi-Fi
		fi
		print_empty_line
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	turn_wifi_on
	#
	# Description:
	# 	This function turns on the Wi-Fi interface.
	#
	# Notes:
	#   - It uses the 'networksetup' command to set the power state of the Wi-Fi interface to 'on'.
	#
	local function turn_wifi_on() {
		networksetup -setairportpower en0 on
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	turn_wifi_off
	#
	# Description:
	# 	This function turns off the Wi-Fi interface.
	#
	# Notes:
	#   - It uses the 'networksetup' command to set the power state of the Wi-Fi interface to 'off'.
	#
	local function turn_wifi_off() {
		networksetup -setairportpower en0 off
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	connect_wifi
	#
	# Description:
	# 	This function connects to a Wi-Fi network using the provided network name and password.
	#
	# Arguments:
	# 	- $1: a name of a target Wi-Fi network.
	# 	- $2 a password of a target Wi-Fi network. 
	#
	# Notes:
	#   - It uses the 'networksetup' command to set the Wi-Fi network and password.
	#
	local function connect_wifi() {
		source "$CONFIG_FILE_PATH"
		local found_fave_wifi; local found_password
		for alias_name wifi_info in ${(kv)WIFI_NETWORKS}; do
			IFS="," read -r current_wifi_name current_wifi_password <<< "$wifi_info"
			current_wifi_password=$(echo $current_wifi_password | tr -d ' ')
			if [[ "$1" == "$alias_name" ]]; then
				found_fave_wifi=$current_wifi_name
				found_password=$current_wifi_password
				break
			fi
		done
		print_empty_line
		if [[ -n "$found_fave_wifi" && -n "$found_password" ]]; then
			networksetup -setairportnetwork en0 $found_fave_wifi $found_password
		else
			local network=$1; local password=$2
			networksetup -setairportnetwork en0 $network $password
		fi
		print_empty_line
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	disconnect_network
	#
	# Description:
	# 	This function disconnects the current Wi-Fi network.
	#
	# Notes:
	#   - This function uses the 'airport' command-line tool to disassociate from the current Wi-Fi network.
	#   - It requires superuser privileges, so it will prompt for your password when executed.
	#   - It does not turn off Wi-Fi; it only disconnects from the current network.
	#
	local function disconnect_network() {
		print_empty_line
		sudo /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -z
		print_empty_line
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	check_connection
	#
	# Description:
	# 	This function checks the Internet connection.
	#
	# Notes:
	#   - It uses the 'ping' command that tries to send the package to 'google.com' and then get it back.
	#
	local function check_connection() {
		print_empty_line
		ping -c 5 www.google.com
		print_empty_line
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	print_fave_list
	#
	# Description:
	# 	This function retrieves the list of favorite Wi-Fi networks stored in the configuration file.
	# 	It then prints the list along with the the Wi-Fi network and its password.
	#
	# Notes:
	#   - The configuration of the favorite list is intended to be stored at '~/.cai/' path.
	#

	local function print_fave_list() {
		source "$CONFIG_FILE_PATH"
		local i=1
		print_empty_line
		echo "Your favorite list"
		print_underline
		if [[ ${#WIFI_NETWORKS[@]} -eq 0 ]]; then
			echo "Empty."
		else
			for alias_name network_info in ${(kv)WIFI_NETWORKS}; do
				IFS="," read -r network password <<< "$network_info"
				password=$(echo $password | tr -d ' ')
				echo "${i}. ${alias_name}"
				print_empty_line
				echo "Wi-Fi network:\t${network}"
				echo "Password:\t${password}"
				print_underline
				((i++))
			done
		fi
		print_empty_line
		if [[ ${#WIFI_NETWORKS[@]} -eq 0 ]]; then
			print_instructions_to_add_new_fave_network
		fi
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	print_updated_fave_list
	#
	# Description:
	# 	This function retrieves the updated list of favorite Wi-Fi networks stored in the configuration file.
	# 	It then prints the updated list along with the Wi-Fi network and its password.
	#
	# Notes:
	#   - The configuration of the favorite list is intended to be stored at '~/.cai/' path.
	#
	local function print_updated_fave_list() {
		source "$CONFIG_FILE_PATH"
		local i=1
		print_empty_line
		echo "Your new favorite list"
		print_underline
		if [[ ${#WIFI_NETWORKS[@]} -eq 0 ]]; then
			echo "Empty."
		else
			for alias_name network_info in ${(kv)WIFI_NETWORKS}; do
				IFS="," read -r network password <<< "$network_info"
				password=$(echo $password | tr -d ' ')
				echo "${i}. ${alias_name}"
				print_empty_line
				echo "Wi-Fi network:\t${network}"
				echo "Password:\t${password}"
				print_underline
				((i++))
			done
		fi
		print_empty_line
		if [[ ${#WIFI_NETWORKS[@]} -eq 0 ]]; then
			print_instructions_to_add_new_fave_network
		fi
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	save_network
	#
	# Description:
	# 	This function saves a new Wi-Fi network in the favorite list.
	#
	# Arguments:
	# 	- $1: A Symbolic name of the device provided by the user.
	# 	- $2: A name of a Wi-Fi network that user wants to save.
	# 	- $3: A password of a Wi-Fi network that user wants to save.
	#
	# Notes:
	#   - It uses the '.wifi_networks.config' configuration that will store your favorite list.
	#
	function save_network() {
		source "$CONFIG_FILE_PATH"
		local alias_name=$1
		local network=$2
		local password=$3
		WIFI_NETWORKS[$alias_name]="${network}, ${password}"
		echo "declare -A WIFI_NETWORKS=(" > "$CONFIG_FILE_PATH"
		for alias_name wifi_info in ${(kv)WIFI_NETWORKS}; do
			echo "\t[${alias_name}]='${wifi_info}'" >> "$CONFIG_FILE_PATH"
		done
		echo ")" >> "$CONFIG_FILE_PATH"
		print_updated_fave_list
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	delete_network
	#
	# Description:
	# 	This function deletes a specific Wi-Fi network from the favorite list.
	#
	# Notes:
	#   - It uses the '.wifi_networks.config' configuration that stores your favorite Wi-Fi network.
	#
	function delete_network() {
		source "$CONFIG_FILE_PATH"
		local query_alias_name=$1
		local -A new_list
		for alias_name wifi_info in ${(kv)WIFI_NETWORKS}; do
			if [[ "$query_alias_name" != "$alias_name" ]]; then
				new_list[$alias_name]=$wifi_info
			fi
		done
		if [[ ${#new_list[@]} -eq 0 ]]; then
			echo "declare -A WIFI_NETWORKS" > "$CONFIG_FILE_PATH"
		else
			echo "declare -A WIFI_NETWORKS=(" > "$CONFIG_FILE_PATH"
			for new_alias_name new_wifi_info in ${(kv)new_list}; do
				echo "\t[${new_alias_name}]='${new_wifi_info}'" >> "$CONFIG_FILE_PATH"
			done
			echo ")" >> "$CONFIG_FILE_PATH"
		fi
		print_updated_fave_list
	}

	# MAIN PART OF THE SCRIPT:

	case $1 in
		"name")
			if [[ $# -eq 1 ]]; then
				get_current_wifi_name
			else
				print_bad_wifi_name_syntax
			fi
			;;
		"scan")
			if [[ $# -eq 1 ]]; then
				get_wifi_list
			else
				print_bad_wifi_scan_syntax
			fi
			;;
		"info")
			if [[ $# -eq 1 ]]; then
				get_wifi_info
			else
				print_bad_wifi_info_syntax
			fi
			;;
		"status")
			if [[ $# -eq 1 ]]; then
				get_wifi_status
			else
				print_bad_wifi_status_syntax
			fi
			;;
		"on")
			if [[ $# -eq 1 ]]; then
				turn_wifi_on
			else
				print_bad_wifi_turn_on_syntax
			fi
			;;
		"off")
			if [[ $# -eq 1 ]]; then
				turn_wifi_off
			else
				print_bad_wifi_turn_off_syntax
			fi
			;;
		"connect")
			if [[ $# -eq 2 ]]; then
				local network=$2
				connect_wifi $network
			elif [[ $# -eq 3 ]]; then
				local network=$2; local password=$3
				connect_wifi $network $password
			else
				print_bad_wifi_connect_syntax
			fi
			;;
		"disconnect")
			if [[ $# -eq 1 ]]; then
				disconnect_network
			else
				print_bad_wifi_disconnect_syntax
			fi
			;;
		"ping")
			if [[ $# -eq 1 ]]; then
				check_connection
			else
				print_bad_wifi_ping_syntax
			fi
			;;
		"save")
			if [[ $# -eq 4 ]]; then
				local alias_name=$2
				local network_name=$3
				local network_password=$4
				save_network $alias_name $network_name $network_password
			else
				print_bad_wifi_save_syntax
			fi
			;;
		"delete")
			if [[ $# -eq 2 ]]; then
				delete_network $2
			else
				print_bad_wifi_delete_syntax
			fi
			;;
		"list")
			if [[ $# -eq 2 && "$2" == "fave" ]]; then
				print_fave_list
			else
				print_bad_wifi_list_syntax
			fi
			;;
		"help")
			if [[ $# -eq 1 ]]; then
				print_wifi_help
			else
				print_bad_wifi_help_syntax
			fi
			;;
		*)
			print_error_title
			echo "Bad syntax. Check instructions below to use \033[1mwifi\033[0m correctly."
			print_empty_line
			print_wifi_help
			;;
	esac
}