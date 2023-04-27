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
	# 	print_bad_wifi_syntax
	#
	# Description:
	# 	Prints an error message for incorrect wifi syntax.
	#
	local function print_bad_wifi_syntax() {
		echo "bad wifi syntax. use 'wifi help' to get instructions."
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
		echo "error: unknown wifi status: ${1}"
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	print_wifi_status_on
	#
	# Description:
	# 	Prints a message indicating that Wi-Fi is ON.
	#
	local function print_wifi_status_on() {
		echo "Wi-Fi is ON"
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	print_wifi_status_off
	#
	# Description:
	# 	Prints a message indicating that Wi-Fi is OFF.
	#
	local function print_wifi_status_off() {
		echo "Wi-Fi is OFF"
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	print_wifi_help
	#
	# Description:
	# 	Prints instructions for using the 'wifi' command.
	#
	local function print_wifi_help() {
		echo "here are some instructions for 'wifi help'"
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
		echo $name
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
		/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -s \
  			| awk 'NR==1 { printf "%-33s %-5s %s\n", $1, $2, $NF; next } \
         		{ printf "%-33s %-5s %s\n", substr($0,1,33), substr($0,34,5), $NF }' \
  			| tail -n +2 \
  			| column -t -s $'\t'
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
		networksetup -getinfo Wi-Fi
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
		local network=$1; local password=$2
		networksetup -setairportnetwork en0 $network $password
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
		sudo /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -z
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
		ping -c 5 www.google.com
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	save_network
	#
	# Description:
	# 	This function saves a new Wi-Fi network in the favorite list.
	#
	# Notes:
	#   - It uses the '.wifi_networks.config' configuration that will store your favorite list.
	#
	function save_network() {}

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
	function delete_network() {}

	# MAIN PART OF THE SCRIPT:

	case $1 in
		"name")
			if [[ $# -eq 1 ]]; then
				get_current_wifi_name
			else
				print_bad_wifi_syntax
			fi
			;;
		"scan")
			if [[ $# -eq 1 ]]; then
				get_wifi_list
			else
				print_bad_wifi_syntax
			fi
			;;
		"info")
			if [[ $# -eq 1 ]]; then
				get_wifi_info
			else
				print_bad_wifi_syntax
			fi
			;;
		"status")
			if [[ $# -eq 1 ]]; then
				get_wifi_status
			else
				print_bad_wifi_syntax
			fi
			;;
		"on")
			turn_wifi_on
			;;
		"off")
			turn_wifi_off
			;;
		"connect")
			if [[ $# -eq 2 ]]; then
				local network=$2
				connect_wifi $network
			elif [[ $# -eq 3 ]]; then
				local network=$2; local password=$3
				connect_wifi $network $password
			else
				print_bad_wifi_syntax
			fi
			;;
		"disconnect")
			disconnect_network
			;;
		"ping")
			check_connection
			;;
		"save")
			if [[ $# -eq 3 ]]; then
				save_network
			else
				print_bad_wifi_syntax
			fi
			;;
		"delete")
			if [[ $# -eq 3 ]]; then
				delete_network
			else
				print_bad_wifi_syntax
			fi
			;;
		"help")
			print_wifi_help
			;;
		*)
			print_bad_wifi_syntax
			;;
	esac
}