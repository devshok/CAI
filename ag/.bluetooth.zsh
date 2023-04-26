#!/bin/zsh

# SHORTCUTS:

function bl() {
	bluetooth "$@"
}

function blue() {
	bluetooth "$@"
}

# The bluetooth() function provides a set of subcommands to manage Bluetooth devices on macOS.
# It takes one option at a time and performs the appropriate action based on the option selected. 
#
# The available options are as follows:
#
# on: Turn on Bluetooth
# off: Turn off Bluetooth
# list: List paired Bluetooth devices. Type can be "all", "connected", or "fave"
# status: Show the status of Bluetooth. If [device] is not specified, show the status of Bluetooth itself
# connect: Connect to a specific device or all devices in the favorite list
# disconnect: Disconnect from a specific device
# forget: Unpair a device from the system
# save: Save a device to the favorite list with a symbolic name
# delete: Remove a device from the favorite list
# help: Show this help message
#
# Each option may require an additional argument to be passed, 
# such as a device name or a device type. 
# If the arguments are not passed correctly, an error message will be displayed.

function bluetooth() {

	# Path to the directory containing CAI scripts and configuration files
	local CAI_PATH="${HOME}/.cai"

	# Name of the configuration file for Bluetooth devices
	local CONFIG_FILE=".bluetooth_devices.config"

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
	# Function names:
	# 	- print_bad_syntax_title_with_message
	# 	- print_note_for_help_
	# 	- print_bad_syntax_bl_on_error
	# 	- print_bad_syntax_bl_off_error
	# 	- print_bad_syntax_bl_list_error
	# 	- print_bad_syntax_bl_status_error
	#	- print_bad_syntax_bl_connect_error
	#	- print_bad_syntax_bl_disconnect_error
	#	- print_bad_syntax_bl_forget_error
	#	- print_bad_syntax_bl_save_error
	#	- print_bad_syntax_bl_delete_error
	#
	# Description:
	# 	These functions print an error message when there is a bad syntax in the bluetooth command. 
	# 	It is meant to be used as a helper function for the bluetooth command functions.
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
		printf "\t1. This command can also be abbreviated as \033[1mblue\033[0m or \033[1mbl\033[0m instead of \033[1mbluetooth\033[0m.\n"
		printf "\t2. Use \033[1mbluetooth help\033[0m to get more instructions.\n"
		if [[ $# -gt 0 ]]; then
			local i=3
			for note in "$@"; do
				printf "\t${i}. ${note}\n"
				((i++))
			done
		fi
		print_empty_line
	}

	local function print_bad_syntax_bl_on_error() {
		print_bad_syntax_title_with_message "\t$(tput setaf 3)bluetooth on$(tput sgr0)"
		print_empty_line
	}

	local function print_bad_syntax_bl_off_error() {
		print_bad_syntax_title_with_message "\t$(tput setaf 3)bluetooth off$(tput sgr0)"
		print_empty_line
	}

	local function print_bad_syntax_bl_list_error() {
		print_bad_syntax_title_with_message "\t$(tput setaf 3)bluetooth list$(tput sgr0)"
		echo "Usage:"
		print_empty_line
		printf "\t$(tput setaf 3)bluetooth list [option]$(tput sgr0)\n\n"
		print_empty_line
		echo "Options:"
		print_empty_line
		printf "\t\033[1mall\033[0m\t\tList all paired devices\n"
		printf "\t\033[1mconnected\033[0m\tList all connected devices\n"
		printf "\t\033[1mfave\033[0m\t\tRetrieve the list of favorite devices stored in the configuration file\n\n"
		print_note_for_help
		echo "Examples:"
		print_empty_line
		printf "\t\033[1mbluetooth list all\033[0m\n"
		printf "\t\033[1mbluetooth list connected\033[0m\n"
		printf "\t\033[1mbluetooth list fave\033[0m\n\n"
		print_empty_line
	}

	local function print_bad_syntax_bl_status_error() {
		print_bad_syntax_title_with_message "\t$(tput setaf 3)bluetooth status$(tput sgr0)"
		echo "Usage:"
		print_empty_line
		printf "\t$(tput setaf 3)bluetooth status [option]$(tput sgr0)\n\n"
		print_empty_line
		echo "Options:"
		print_empty_line
		printf "\t\033[1m<MAC address>\033[0m\tCheck whether a specific device connected with your machine by MAC address or not\n"
		printf "\t\033[1m<device name>\033[0m\tCheck whether a specific device connected with your machine by name from the favorite list\n\n"
		print_note_for_help "\033[1mbluetooth status\033[0m can be used without options. In this case, it prints the state of the Bluetooth itself on your machine."
		echo "Examples:"
		print_empty_line
		printf "\t\033[1mbluetooth status\033[0m\t\t\tCheck the state of Bluetooth itself on your machine\n"
		printf "\t\033[1mbluetooth status airpods\033[0m\t\tCheck the state of a specific device by name\n"
		printf "\t\033[1mbluetooth status 5b-a6-a6-c5-f5-31\033[0m\tCheck the state of a specific device by MAC address\n\n"
		print_empty_line
	}

	local function print_bad_syntax_bl_connect_error() {
		print_bad_syntax_title_with_message "\t$(tput setaf 3)bluetooth connect$(tput sgr0)"
		echo "Usage:"
		print_empty_line
		printf "\t$(tput setaf 3)bluetooth connect [option]$(tput sgr0)\n\n"
		print_empty_line
		echo "Options:"
		print_empty_line
		printf "\t\033[1m<MAC address>\033[0m\tConnect to a specific device by MAC address\n"
		printf "\t\033[1m<device name>\033[0m\tConnect to a specific device by name in the favorite list\n\n"
		print_note_for_help
		echo "Examples:"
		print_empty_line
		printf "\t\033[1mbluetooth connect airpods\033[0m\t\tConnect to a specific device by name\n"
		printf "\t\033[1mbluetooth connect 5b-a6-a6-c5-f5-31\033[0m\tConnect to a specific device by MAC address\n\n"
		print_empty_line
	}

	local function print_bad_syntax_bl_disconnect_error() {
		print_bad_syntax_title_with_message "\t$(tput setaf 3)bluetooth disconnect$(tput sgr0)"
		echo "Usage:"
		print_empty_line
		printf "\t$(tput setaf 3)bluetooth disconnect [option]$(tput sgr0)\n\n"
		print_empty_line
		echo "Options:"
		print_empty_line
		printf "\t\033[1m<MAC address>\033[0m\tDisconnect from a specific device by MAC address\n"
		printf "\t\033[1m<device name>\033[0m\tDisconnect from a specific device by name in the favorite list\n\n"
		print_note_for_help
		echo "Examples:"
		print_empty_line
		printf "\t\033[1mbluetooth disconnect airpods\033[0m\t\tDisconnect from a specific device by name\n"
		printf "\t\033[1mbluetooth disconnect 5b-a6-a6-c5-f5-31\033[0m\tDisconnect from a specific device by MAC address\n\n"
		print_empty_line
	}

	local function print_bad_syntax_bl_forget_error() {
		print_bad_syntax_title_with_message "\t$(tput setaf 3)bluetooth forget$(tput sgr0)"
		echo "Usage:"
		print_empty_line
		printf "\t$(tput setaf 3)bluetooth forget [option]$(tput sgr0)\n\n"
		print_empty_line
		echo "Options:"
		print_empty_line
		printf "\t\033[1m<MAC address>\033[0m\tUnpair a specific device by MAC address\n"
		printf "\t\033[1m<device name>\033[0m\tUnpair a specific device by name in the favorite list\n\n"
		print_note_for_help
		echo "Examples:"
		print_empty_line
		printf "\t\033[1mbluetooth forget airpods\033[0m\t\tUnpair a specific device by name\n"
		printf "\t\033[1mbluetooth forget 5b-a6-a6-c5-f5-31\033[0m\tUnpair from a specific device by MAC address\n\n"
		print_empty_line
	}

	local function print_bad_syntax_bl_save_error() {
		print_bad_syntax_title_with_message "\t$(tput setaf 3)bluetooth save$(tput sgr0)"
		echo "Usage:"
		print_empty_line
		printf "\t$(tput setaf 3)bluetooth save <device name> <MAC address>$(tput sgr0)\n\n"
		print_empty_line
		echo "Arguments:"
		print_empty_line
		printf "\t\033[1m<device name>\033[0m\tName it whatever you find easy to type\n"
		printf "\t\033[1m<MAC address>\033[0m\tMAC address of the device you wanna save\n"
		print_note_for_help
		echo "Example:"
		print_empty_line
		printf "\t\033[1mbluetooth save airpods 5b-a6-a6-c5-f5-31\033[0m\tSave your Apple AirPods to manipulate with it later easily\n"
		print_empty_line
	}

	local function print_bad_syntax_bl_delete_error() {
		print_bad_syntax_title_with_message "\t$(tput setaf 3)bluetooth delete$(tput sgr0)"
		echo "Usage:"
		print_empty_line
		printf "\t$(tput setaf 3)bluetooth delete <device name>$(tput sgr0)\n\n"
		print_empty_line
		echo "Argument:"
		print_empty_line
		printf "\t\033[1m<device name>\033[0m\tA name of your device you wanna delete from the favorite list\n\n"
		print_note_for_help
		echo "Example:"
		print_empty_line
		printf "\t\033[1mbluetooth delete airpods\033[0m\tYou delete your Apple AirPods from the favorite list\n"
		print_empty_line
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	print_bluetooth_is_turned_on
	#
	# Description:   
	#   Prints the message indicating that Bluetooth is turned on
	#
	local function print_bluetooth_is_turned_on() {
		echo "Bluetooth is turned ON."
		print_empty_line
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	print_bluetooth_is_turned_off
	#
	# Description:
	# 	Prints a message indicating that Bluetooth is turned off.
	#
	local function print_bluetooth_is_turned_off() {
		echo "Bluetooth is turned OFF."
		print_empty_line
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	print_bluetooth_state_error
	#
	# Description:
	# 	This function prints an error message indicating that the current state of Bluetooth
	# 	is unknown or cannot be determined. The message includes an emoji icon and a message
	# 	indicating the unknown state. It also prints an empty line after the message.
	#
	local function print_bluetooth_state_error() {
		print_error_title
		echo "Unknown state"
		print_empty_line
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function Name: 
	# 	print_unknown_device_name_error_for_status
	#
	# Description:
	# 	Prints an error message if the provided device name is not in the list of favorite devices for the "status" command. 
	#
	# Arguments:
	# 	- device_name: Name of the device provided by the user.
	#
	# Notes:
	#   - This function suggests the user to save the device and its MAC address using the "blue save" command before retrying the "status" command.
	#   - It also suggests the user to use the "blue list" command to get the list of devices and their MAC addresses.
	#
	local function print_unknown_device_name_error_for_status() {
		local device_name=$1
		print_error_title
		echo "Sorry, but there's no '${device_name}' in your fave list."
		echo "To fix it, use the next command:"
		print_empty_line
		echo "$(tput setaf 3)\tblue save ${device_name} <MAC address>$(tput sgr0)"
		print_empty_line
		echo "For example:"
		print_empty_line
		echo "$(tput setaf 3)\tblue save ${device_name} 5b-a6-a6-c5-f5-31$(tput sgr0)"
		print_empty_line
		echo "And then repeat your command like that:"
		print_empty_line
		echo "$(tput setaf 3)\tblue status -f ${device_name}$(tput sgr0)"
		print_empty_line
		echo "No idea where to get MAC address? Just get the list of your devices using the command below:"
		print_empty_line
		echo "$(tput setaf 3)\tblue list all$(tput sgr0)"
		print_empty_line
		echo "Or:"
		print_empty_line
		echo "$(tput setaf 3)\tblue list connected$(tput sgr0)"
		print_empty_line
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	print_instructions_to_add_new_fave_device
	#
	# Description:
	#   This function is intended to provide a helpful message to users who want to add a new favorite device to the list of
	#   known Bluetooth devices.
	#
	local function print_instructions_to_add_new_fave_device() {
		echo "Need to add any device? Simply use that:"
		print_empty_line
		echo "$(tput setaf 3)\tblue save <DEVICE SYMBOLIC NAME> <MAC address>$(tput sgr0)"
		print_empty_line
		echo "For example:"
		print_empty_line
		echo "$(tput setaf 3)\tblue save airpods 5b-a6-a6-c5-f5-31$(tput sgr0)"
		print_empty_line
		echo "No idea where to get MAC address? Just get the list of your devices using the command below:"
		print_empty_line
		echo "$(tput setaf 3)\tblue list all$(tput sgr0)"
		print_empty_line
		echo "Or:"
		print_empty_line
		echo "$(tput setaf 3)\tblue list connected$(tput sgr0)"
		print_empty_line
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	turn_on
	#
	# Description:
	# 	This function turns on Bluetooth on the local machine 
	# 	using the blueutil command-line utility. 
	#
	# 	After turning on Bluetooth, it displays a success message 
	# 	and a message indicating that Bluetooth is turned on.
	#
	local function turn_on() {
		blueutil --power 1
		print_success_title
		print_bluetooth_is_turned_on
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	turn_off
	#
	# Description:
	# 	This function turns off Bluetooth on the local machine 
	# 	using the blueutil command-line utility. 
	#
	# 	After turning off Bluetooth, it displays a success message 
	# 	and a message indicating that Bluetooth is turned off.
	#
	local function turn_off() {
		blueutil --power 0
		print_success_title
		print_bluetooth_is_turned_off
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	get_status
	#
	# Description:
	# 	This function gets the current status of Bluetooth on the local machine
	# 	using the blueutil command-line utility. 
	#
	# 	It then displays a message indicating whether Bluetooth is turned on or off, 
	# 	or if the state is unknown.
	#
	local function get_status() {
		local bluetooth_status=$(blueutil --power)
		case $bluetooth_status in
			0)
				print_empty_line
				print_bluetooth_is_turned_off
				;;
			1)
				print_empty_line
				print_bluetooth_is_turned_on
				;;
			*)
				print_bluetooth_state_error
				;;
		esac
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	get_mac_address_from_fave_list
	#
	# Description:
	# 	This function retrieves the MAC address of a specified device
	# 	from a list of favorite devices stored in a configuration file. 
	#
	# 	The function takes a device name as a parameter
	# 	and searches the configuration file for a corresponding MAC address. 
	#
	# 	If a matching device name is found, the function returns the MAC address. 
	#
	# 	If no matching device is found, the function returns an empty string.
	#
	local function get_mac_address_from_fave_list() {
		source "$CONFIG_FILE_PATH"
		for device mac_address in ${(kv)BLUETOOTH_DEVICES}; do
			if [[ "$device" == "$1" ]]; then
				echo $mac_address
				return
			fi
		done
		echo ""
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	get_device_status_by_mac_address
	#
	# Description:
	# 	This function takes a MAC address as a parameter 
	# 	and checks whether the device is connected or disconnected.
	# 	It then prints a message with the status of the device.
	#
	local function get_device_status_by_mac_address() {
		local mac_address=$1
		local device_status=$(blueutil --is-connected $mac_address)
		case $device_status in
			0)
				print_empty_line
				echo "Device (${mac_address}) is DISCONNECTED."
				print_empty_line
				;;
			1)
				print_empty_line
				echo "Device (${mac_address}) is CONNECTED."
				print_empty_line
				;;
			*)
				print_error_title
				echo "Unknown state of this device."
				print_empty_line
				;;
		esac
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	get_device_status
	#
	# Description:
	# 	This function takes the name of a device as a parameter 
	# 	and checks whether it is connected or disconnected.
	#
	# 	It then prints a message with the status of the device.
	#
	local function get_device_status() {
		local fave_mac_address=$(get_mac_address_from_fave_list $1)
		if [[ -z "$fave_mac_address" ]]; then
			local mac_address=$1
			get_device_status_by_mac_address $mac_address
		else
			get_device_status_by_mac_address $fave_mac_address
		fi
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	get_list_all
	#
	# Description:
	# 	This function lists all paired devices.
	#
	local function get_list_all() {
		blueutil --paired
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	get_list_connected
	#
	# Description:
	# 	This function lists all connected devices.
	#
	local function get_list_connected() {
		blueutil --connected
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	get_fave_list
	#
	# Description:
	# 	This function retrieves the list of favorite devices stored in the configuration file.
	# 	It then prints the list along with the device name and MAC address.
	#
	local function get_fave_list() {
		source "$CONFIG_FILE_PATH"
		local i=1
		print_empty_line
		echo "Your favorite list"
		print_underline
		if [[ ${#BLUETOOTH_DEVICES[@]} -eq 0 ]]; then
			echo "Empty."
		else
			for device mac_address in ${(kv)BLUETOOTH_DEVICES}; do
				echo "${i}. ${device}\t\t${mac_address}"
				((i++))
			done
		fi
		print_underline
		print_empty_line
		if [[ ${#BLUETOOTH_DEVICES[@]} -eq 0 ]]; then
			print_instructions_to_add_new_fave_device
		fi
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	get_updated_fave_list
	#
	# Description:
	# 	This function retrieves the updated list of favorite devices stored in the configuration file.
	# 	It then prints the updated list along with the device name and MAC address.
	#
	local function get_updated_fave_list() {
		source "$CONFIG_FILE_PATH"
		local i=1
		print_empty_line
		echo "Your new favorite list"
		print_underline
		if [[ ${#BLUETOOTH_DEVICES[@]} -eq 0 ]]; then
			echo "Empty."
		else
			for device mac_address in ${(kv)BLUETOOTH_DEVICES}; do
				echo "${i}. ${device}\t\t${mac_address}"
				((i++))
			done
		fi
		print_underline
		print_empty_line
		if [[ ${#BLUETOOTH_DEVICES[@]} -eq 0 ]]; then
			print_instructions_to_add_new_fave_device
		fi
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	connect_device_by_mac_address
	#
	# Description:
	# 	Attempts to connect a device by its MAC address
	#
	# Arguments:
	# 	- mac_address: The MAC address of the device to connect
	#
	local function connect_device_by_mac_address() {
		local mac_address=$1
		local device_status=$(blueutil --is-connected $mac_address)

		local function __connect_device_by_mac_address() {
			print_empty_line
			echo "Trying to connect... Just wait a moment."
			print_empty_line
			blueutil --connect $1
			local new_device_status=$(blueutil --is-connected $mac_address)
			if [[ $new_device_status == $device_status ]]; then
				print_empty_line
			else
				print_success_title
				echo "Device (${1}) is CONNECTED."
				print_empty_line
			fi
		}

		case $device_status in
			0)
				__connect_device_by_mac_address $mac_address
				;;
			1)
				print_empty_line
				echo "Device (${mac_address}) is ALREADY CONNECTED."
				print_empty_line
				;;
			*)
				print_empty_line
				echo "Unknown state of this device."
				echo "But anyway I gonna try to connect..."
				print_empty_line
				__connect_device_by_mac_address $mac_address
				;;
		esac
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	disconnect_device_by_mac_address
	#
	# Description:
	# 	Attempts to disconnect a device by its MAC address
	#
	# Arguments:
	# 	- mac_address: The MAC address of the device to disconnect
	#
	local function disconnect_device_by_mac_address() {
		local mac_address=$1
		local device_status=$(blueutil --is-connected $mac_address)

		local function __disconnect_device_by_mac_address() {
			print_empty_line
			echo "Trying to disconnect... Just wait a moment."
			print_empty_line
			blueutil --disconnect $1
			local new_device_status=$(blueutil --is-connected $1)
			if [[ $new_device_status == $device_status ]]; then
				print_empty_line
			else
				print_success_title
				echo "Device (${1}) is DISCONNECTED."
				print_empty_line
			fi
		}

		case $device_status in
			0)
				print_empty_line
				echo "Device (${mac_address}) is ALREADY DISCONNECTED."
				print_empty_line
				;;
			1)
				__disconnect_device_by_mac_address $mac_address
				;;
			*)
				print_empty_line
				echo "Unknown state of this device."
				echo "But anyway I gonna try to disconnect..."
				print_empty_line
				__disconnect_device_by_mac_address $mac_address
				;;
		esac
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	connect_device
	#
	# Description:
	# 	If the device is not in the favorites list, connect using its MAC address
	#	Otherwise, connect using the MAC address associated with the device name in the favorites list
	#
	# Arguments:
	# 	- $1: it can be either a MAC address or a device name from the favorite list in the configuration.
	#
	local function connect_device() {
		source "$CONFIG_FILE_PATH"
		local fave_mac_address=$(get_mac_address_from_fave_list $1)
		if [[ -z "$fave_mac_address" ]]; then
			connect_device_by_mac_address $1
		else
			connect_device_by_mac_address $fave_mac_address
		fi
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	connect_all_fave_devices
	#
	# Description:
	# 	If there are no devices in the favorites list, provide instructions on how to add them
	#	Otherwise, connect all devices in the favorites list using their MAC addresses
	#
	local function connect_all_fave_devices() {
		source "$CONFIG_FILE_PATH"
		if [[ ${#BLUETOOTH_DEVICES[@]} -eq 0 ]]; then
			print_empty_line
			echo "There is not list of your favorite devices to connect."
			print_underline
			print_instructions_to_add_new_fave_device
		else
			for device mac_address in ${(kv)BLUETOOTH_DEVICES}; do
				connect_device_by_mac_address $mac_address
			done
		fi
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	disconnect_device
	#
	# Description:
	# 	If the device is not in the favorites list, disconnect using its MAC address
	#	Otherwise, disconnect using the MAC address associated with the device name in the favorites list
	#
	# Arguments:
	# 	- $1: it can be either a MAC address or a device name from the favorite list in the configuration.
	#
	local function disconnect_device() {
		source "$CONFIG_FILE_PATH"
		local fave_mac_address=$(get_mac_address_from_fave_list $1)
		if [[ -z "$fave_mac_address" ]]; then
			disconnect_device_by_mac_address $1
		else
			disconnect_device_by_mac_address $fave_mac_address
		fi
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	save_fave_device
	#
	# Description:
	# 	This function saves a device's MAC address with a symbolic name as a favorite device. 
	#
	# 	It takes two arguments - the first argument is the symbolic name of the device, 
	# 	and the second argument is the MAC address of the device. 
	#
	# 	The function saves the device to a configuration file and updates the favorite device list.
	#
	# Arguments:
	# 	- key: it's a name of the device that user wants to save into the favorite list.
	# 	- value: it's a MAC address of the device that user wants to save into the favorite list.
	#
	local function save_fave_device() {
		source "$CONFIG_FILE_PATH"
		local key=$1; local value=$2
		BLUETOOTH_DEVICES[$key]=$value
		if [[ ${#BLUETOOTH_DEVICES[@]} -eq 0 ]]; then
			echo "declare -A BLUETOOTH_DEVICES" > "$CONFIG_FILE_PATH"
		else
			echo "declare -A BLUETOOTH_DEVICES=(" > "$CONFIG_FILE_PATH"
			for key value in ${(kv)BLUETOOTH_DEVICES}; do
				echo "\t[${key}]=${value}" >> "$CONFIG_FILE_PATH"
			done
			echo ")" >> "$CONFIG_FILE_PATH"
		fi
		get_updated_fave_list
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	delete_fave_device
	#
	# Description:
	# 	This function deletes a device from the favorite device list. 
	#
	# 	It takes one argument - the symbolic name of the device to delete.
	# 	The function removes the device from the configuration file 
	# 	and updates the favorite device list.
	#
	# Arguments:
	# 	- $1: it's name of the device user wants to remove from the favorite list.
	#
	local function delete_fave_device() {
		source "$CONFIG_FILE_PATH"
		local requesting_device=$1
		typeset -A new_devices_set=()
		for existing_device mac_address in ${(kv)BLUETOOTH_DEVICES}; do
			if [[ "$existing_device" == "$requesting_device" ]]; then
				continue
			else
				new_devices_set[$existing_device]=$mac_address
			fi
		done
		if [[ ${#new_devices_set[@]} -eq 0 ]]; then
			echo "declare -A BLUETOOTH_DEVICES" > "$CONFIG_FILE_PATH"
		else
			echo "declare -A BLUETOOTH_DEVICES=(" > "$CONFIG_FILE_PATH"
			for key value in ${(kv)new_devices_set}; do
				echo "\t[${key}]=${value}" >> "$CONFIG_FILE_PATH"
			done
			echo ")" >> "$CONFIG_FILE_PATH"
		fi
		get_updated_fave_list
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	forget_device
	#
	# Description:
	# 	This function unpairs and forgets a device from the Bluetooth device list.
	#
	# 	It takes one argument - the symbolic name of the device to forget. 
	#
	# 	If the device is a favorite device, it gets the MAC address from the favorite device list
	# 	and unpairs that device. Otherwise, it unpairs the device directly.
	#
	# Arguments:
	# 	- $1: it's either a name or a MAC address of the device that user wants to unpair.
	#
	local function forget_device() {
		source "$CONFIG_FILE_PATH"
		local saved_mac_address=$(get_mac_address_from_fave_list $1)
		if [[ -z "$saved_mac_address" ]]; then
			local forgetting_result=$(blueutil --unpair $1)
			if [[ -z "$forgetting_result" ]]; then
				print_empty_line
				echo "Device (${1}) is forgotten."
				print_empty_line
			else
				print_empty_line
			fi
		else
			local forgetting_result=$(blueutil --unpair $saved_mac_address)
			if [[ -z "$forgetting_result" ]]; then
				print_empty_line
				echo "Device (${saved_mac_address}) is forgotten."
				print_empty_line
			else
				print_empty_line
			fi
		fi
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	print_help
	#
	# Description:
	# 	This function prints help instructions for the bluetooth command. 
	# 	It takes no arguments and simply prints out the help text.
	#
	local function print_help() {
		printf "\n\033[1mbluetooth\033[0m - A command-line tool for managing Bluetooth devices on macOS.\n\n"
		printf "Usage:\n"
		print_empty_line
		printf "\t$(tput setaf 3)bluetooth <command> [options]$(tput sgr0)\n\n"
		printf "Commands:\n"
		print_empty_line
		printf "\t\033[1mon\033[0m\t\t\t\t\t\tTurn on Bluetooth\n"
		printf "\t\033[1moff\033[0m\t\t\t\t\t\tTurn off Bluetooth\n"
		printf "\t\033[1mlist\033[0m [all|fave|connected]\t\t\tList paired Bluetooth devices\n"
		printf "\t\033[1mstatus\033[0m [<MAC address>|<device name>]\t\tShow the status of Bluetooth. If [device] is not specified, it show the status of Bluetooth itself\n"
		printf "\t\033[1mconnect\033[0m [<MAC address>|<device name>|all]\tConnect to a specific device or all devices in the favorite list\n"
		printf "\t\033[1mdisconnect\033[0m [<MAC address>|<device name>]\tDisconnect from a specific device by MAC address or a name in the favorite list\n"
		printf "\t\033[1mforget\033[0m [<MAC address>|<device name>]\t\tUnpair a device from the system by a name in the favorite list or by MAC address\n"
		printf "\t\033[1msave\033[0m [name] [mac_address]\t\t\tSave a device to the favorite list with a symbolic name\n"
		printf "\t\033[1mdelete\033[0m [name]\t\t\t\t\tRemove a device from the favorite list\n"
		printf "\t\033[1mhelp\033[0m\t\t\t\t\t\tShow this help message\n\n"
		printf "Note:\n"
		print_empty_line
		printf "\tThis command can also be abbreviated as \033[1mblue\033[0m or \033[1mbl\033[0m instead of \033[1mbluetooth\033[0m.\n"
		print_empty_line
		printf "Examples:\n"
		print_empty_line
		printf "\t\033[1mbluetooth list all\033[0m\t\t\t\tList all paired devices with your machine\n"
		printf "\t\033[1mbluetooth list fave\033[0m\t\t\t\tList all favorite devices saved on the configutation\n"
		printf "\t\033[1mbluetooth list connected\033[0m\t\t\tList all connected devices with your machine currently\n"
		printf "\t\033[1mbluetooth save airpods 5b-a6-a6-c5-f5-31\033[0m\tSave your headphones onto the favorite list using a short handful name\n"
		printf "\t\033[1mbluetooth connect airpods\033[0m\t\t\tConnect your favorite device with your machine by a name in the favorite list\n"
		printf "\t\033[1mbluetooth connect 5b-a6-a6-c5-f5-31\033[0m\t\tConnect your favorite device with your machine by MAC address\n"
		printf "\t\033[1mbluetooth disconnect airpods\033[0m\t\t\tDisconnect your favorite device from your machine by a name in the favorite list\n"
		printf "\t\033[1mbluetooth disconnect 5b-a6-a6-c5-f5-31\033[0m\t\tDisconnect your favorite device from your machine by MAC address\n"
		printf "\t\033[1mbluetooth forget airpods\033[0m\t\t\tOr unpair your favorite device from your machine at all by using a name in the favorite list\n"
		printf "\t\033[1mbluetooth forget 5b-a6-a6-c5-f5-31\033[0m\t\tOr unpair your favorite device from your machine at all by using MAC address\n"
		printf "\t\033[1mbluetooth delete airpods\033[0m\t\t\tAnd then remove your device from the favorite list\n"
		print_empty_line
		print_empty_line
	}

	# MAIN PART OF THE SCRIPT:

	case $1 in
		"on")
			if [[ $# -eq 1 ]]; then
				turn_on
			else
				print_bad_syntax_bl_on_error
			fi
			;;
		"off")
			if [[ $# -eq 1 ]]; then
				turn_off
			else
				print_bad_syntax_bl_off_error
			fi
			;;
		"list")
			if [[ $# -eq 2 ]]; then
				case $2 in
					"all")
						get_list_all
						;;
					"connected")
						get_list_connected
						;;
					"fave")
						get_fave_list
						;;
					*)
						print_bad_syntax_bl_list_error
						;;
				esac
			else
				print_bad_syntax_bl_list_error
			fi
			;;
		"status")
			case $# in
				1)
					get_status
					;;
				2)
					get_device_status $2
					;;
				*)
					print_bad_syntax_bl_status_error
					;;
			esac
			;;
		"connect")
			if [[ $# -eq 2 ]]; then
				if [[ "$2" == "all" ]]; then
					connect_all_fave_devices
				else
					connect_device $2
				fi
			else
				print_bad_syntax_bl_connect_error
			fi
			;;
		"disconnect")
			if [[ $# -eq 2 ]]; then
				disconnect_device $2
			else
				print_bad_syntax_bl_disconnect_error
			fi
			;;
		"forget")
			if [[ $# -eq 2 ]]; then
				forget_device $2
			else
				print_bad_syntax_bl_forget_error
			fi
			;;
		"save")
			if [[ $# -eq 3 ]]; then
				local device_symbolic_name=$2
				local mac_address=$3
				save_fave_device $device_symbolic_name $mac_address
			else
				print_bad_syntax_bl_save_error
			fi
			;;
		"delete")
			if [[ $# -eq 2 ]]; then
				local device_symbolic_name=$2
				delete_fave_device $device_symbolic_name
			else
				print_bad_syntax_bl_delete_error
			fi
			;;
		"help")
			print_help
			;;
		*)
			print_error_title
			echo "Bad syntax. Check instructions below to use \033[1mbluetooth\033[0m correctly."
			print_empty_line
			print_help
			;;
	esac
}