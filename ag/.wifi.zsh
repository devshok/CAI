#!/bin/zsh

# CONFIGURATION SETUP:

source ~/.cai/.cai.config

# SHORTCUT:

function wf() {
	wifi "$@"
}

function wifi() {

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
	# 	get_wifi_router_ip
	#
	# Description:
	# 	This function retrieves the IP address of the Wi-Fi router to which the machine is connected.
	#
	# Notes:
	#   - It uses the 'route' command to get the default gateway and extracts the router's IP address from the output.
	#
	local function get_wifi_router_ip() {
		local output=$(route -n get default | grep gateway)
		local router_ip=$(echo $output | cut -d':' -f2 | xargs)
		echo "Router IP: ${router_ip}"
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	get_wifi_details
	#
	# Description:
	# 	This function shows detailed information about the Wi-Fi connection, including IP address, subnet mask, and router IP.
	#
	# Notes:
	#   - It uses the 'networksetup' command to retrieve the information.
	#
	local function get_wifi_details() {
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

	# MAIN PART OF THE SCRIPT:

	case $1 in
		"get")
			if [ $# -eq 2 ]; then
				case $2 in
					"name")
						get_current_wifi_name
						;;
						;;
					"list")
						get_wifi_list
						;;
					"info")
						get_wifi_details
						;;
					*)
						print_bad_wifi_syntax
						;;
				esac
			elif [[ $# -eq 3 && $2 = "router" && $3 = "ip" ]]; then
				get_wifi_router_ip
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
			if [[ $# -ge 2 && -n "$2" ]]; then
				local network=$2; local password=$3
				connect_wifi $network $password
			else
				print_bad_wifi_syntax
			fi
			;;
		"disconnect")
			disconnect_network
			;;
		"help")
			print_wifi_help
			;;
		*)
			print_bad_wifi_syntax
			;;
	esac
}