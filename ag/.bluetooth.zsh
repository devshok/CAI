#!/bin/zsh

# SHORTCUTS:

function bl() {
	bluetooth "$@"
}

function blue() {
	bluetooth "$@"
}

# CORE IMPLEMENTATION:

function bluetooth() {

	local CAI_PATH="${HOME}/.cai"
	local CONFIG_FILE=".bluetooth_devices.config"
	local CONFIG_FILE_PATH="${CAI_PATH}/${CONFIG_FILE}"

	local function print_underline() {
		echo "--------------------------------------------"
	}

	local function print_empty_line() {
		echo ""
	}

	local function print_error_title() {
		print_empty_line
		echo "$(tput setaf 1)💩 ERROR$(tput sgr0)"
		print_underline
	}

	local function print_success_title() {
		print_empty_line
		echo "$(tput setaf 2)🚀 SUCCESS$(tput sgr0)"
		print_underline
	}

	local function print_bad_syntax_error() {
		print_error_title
		echo "bad bluetooth syntax. use 'bluetooth help' to get instructions."
		print_empty_line
	}

	local function print_bluetooth_is_turned_on() {
		echo "⚡️ Bluetooth is turned ON."
		print_empty_line
	}

	local function print_bluetooth_is_turned_off() {
		echo "💤 Bluetooth is turned OFF."
		print_empty_line
	}

	local function print_bluetooth_state_error() {
		print_error_title
		echo "⁉️  Unknown state"
		print_empty_line
	}

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
		echo "Cheers, mate. 🍺"
		print_empty_line
	}

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

	local function turn_on() {
		blueutil --power 1
		print_success_title
		print_bluetooth_is_turned_on
	}

	local function turn_off() {
		blueutil --power 0
		print_success_title
		print_bluetooth_is_turned_off
	}

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

	local function get_device_status_by_mac_address() {
		local mac_address=$1
		local device_status=$(blueutil --is-connected $mac_address)
		case $device_status in
			0)
				print_empty_line
				echo "💤 Device (${mac_address}) is DISCONNECTED."
				print_empty_line
				;;
			1)
				print_empty_line
				echo "⚡️ Device (${mac_address}) is CONNECTED."
				print_empty_line
				;;
			*)
				print_error_title
				echo "⁉️  Unknown state of this device."
				print_empty_line
				;;
		esac
	}

	local function get_device_status() {
		local fave_mac_address=$(get_mac_address_from_fave_list $1)
		if [[ -z "$fave_mac_address" ]]; then
			local mac_address=$1
			get_device_status_by_mac_address $mac_address
		else
			get_device_status_by_mac_address $fave_mac_address
		fi
	}

	local function get_list_all() {
		blueutil --paired
	}

	local function get_list_connected() {
		blueutil --connected
	}

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

	local function connect_device_by_mac_address() {
		local mac_address=$1
		local device_status=$(blueutil --is-connected $mac_address)

		local function __connect_device_by_mac_address() {
			print_empty_line
			echo "⏱️  Trying to connect... Just wait a moment."
			print_empty_line
			blueutil --connect $1
			local new_device_status=$(blueutil --is-connected $mac_address)
			if [[ $new_device_status == $device_status ]]; then
				print_empty_line
			else
				print_success_title
				echo "⚡️ Device (${1}) is CONNECTED."
				print_empty_line
			fi
		}

		case $device_status in
			0)
				__connect_device_by_mac_address $mac_address
				;;
			1)
				print_empty_line
				echo "👍 Device (${mac_address}) is ALREADY CONNECTED."
				print_empty_line
				;;
			*)
				print_empty_line
				echo "⁉️  Unknown state of this device."
				echo "But anyway I gonna try to connect..."
				print_empty_line
				__connect_device_by_mac_address $mac_address
				;;
		esac
	}

	local function disconnect_device_by_mac_address() {
		local mac_address=$1
		local device_status=$(blueutil --is-connected $mac_address)

		local function __disconnect_device_by_mac_address() {
			print_empty_line
			echo "⏱️  Trying to disconnect... Just wait a moment."
			print_empty_line
			blueutil --disconnect $1
			local new_device_status=$(blueutil --is-connected $1)
			if [[ $new_device_status == $device_status ]]; then
				print_empty_line
			else
				print_success_title
				echo "💤 Device (${1}) is DISCONNECTED."
				print_empty_line
			fi
		}

		case $device_status in
			0)
				print_empty_line
				echo "👍 Device (${mac_address}) is ALREADY DISCONNECTED."
				print_empty_line
				;;
			1)
				__disconnect_device_by_mac_address $mac_address
				;;
			*)
				print_empty_line
				echo "⁉️  Unknown state of this device."
				echo "But anyway I gonna try to disconnect..."
				print_empty_line
				__disconnect_device_by_mac_address $mac_address
				;;
		esac
	}

	local function connect_device() {
		source "$CONFIG_FILE_PATH"
		local fave_mac_address=$(get_mac_address_from_fave_list $1)
		if [[ -z "$fave_mac_address" ]]; then
			connect_device_by_mac_address $1
		else
			connect_device_by_mac_address $fave_mac_address
		fi
	}

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

	local function disconnect_device() {
		source "$CONFIG_FILE_PATH"
		local fave_mac_address=$(get_mac_address_from_fave_list $1)
		if [[ -z "$fave_mac_address" ]]; then
			disconnect_device_by_mac_address $1
		else
			disconnect_device_by_mac_address $fave_mac_address
		fi
	}

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

	local function forget_device() {
		source "$CONFIG_FILE_PATH"
		local saved_mac_address=$(get_mac_address_from_fave_list $1)
		if [[ -z "$saved_mac_address" ]]; then
			local forgetting_result=$(blueutil --unpair $1)
			if [[ -z "$forgetting_result" ]]; then
				print_empty_line
				echo "👋 Device (${1}) is forgotten."
				print_empty_line
			else
				print_empty_line
			fi
		else
			local forgetting_result=$(blueutil --unpair $saved_mac_address)
			if [[ -z "$forgetting_result" ]]; then
				print_empty_line
				echo "👋 Device (${saved_mac_address}) is forgotten."
				print_empty_line
			else
				print_empty_line
			fi
		fi
	}

	local function print_help() {
		print_empty_line
		echo "here are some instructions for 'bluetooth help'"
		print_empty_line
	}

	# MAIN PART OF THE SCRIPT:

	case $1 in
		"on")
			if [[ $# -eq 1 ]]; then
				turn_on
			else
				print_bad_syntax_error
			fi
			;;
		"off")
			if [[ $# -eq 1 ]]; then
				turn_off
			else
				print_bad_syntax_error
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
						print_bad_syntax_error
						;;
				esac
			else
				print_bad_syntax_error
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
					print_bad_syntax_error
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
				print_bad_syntax_error
			fi
			;;
		"disconnect")
			if [[ $# -eq 2 ]]; then
				disconnect_device $2
			else
				print_bad_syntax_error
			fi
			;;
		"forget")
			if [[ $# -eq 2 ]]; then
				forget_device $2
			else
				print_bad_syntax_error
			fi
			;;
		"save")
			if [[ $# -eq 3 ]]; then
				local device_symbolic_name=$2
				local mac_address=$3
				save_fave_device $device_symbolic_name $mac_address
			else
				echo "Bad 'blue save' syntax."
			fi
			;;
		"delete")
			if [[ $# -eq 2 ]]; then
				local device_symbolic_name=$2
				delete_fave_device $device_symbolic_name
			else
				print_bad_syntax_error
			fi
			;;
		"help")
			print_help
			;;
		*)
			print_bad_syntax_error
			;;
	esac
}