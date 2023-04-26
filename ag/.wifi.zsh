#!/bin/zsh

# CONFIGURATION SETUP:

source ~/.cai/.cai.config

function wifi() {

	# ERRORS:

	local function print_bad_wifi_syntax() {
		echo "bad wifi syntax. use 'wifi help' to get instructions."
	}

	local function print_unknown_wifi_status() {
		echo "error: unknown wifi status: ${1}"
	}

	# STATUS:

	local function print_wifi_status_on() {
		echo "Wi-Fi is ON"
	}

	local function print_wifi_status_off() {
		echo "Wi-Fi is OFF"
	}

	# HELP:

	local function print_wifi_help() {
		echo "here are some instructions for 'wifi help'"
	}

	# GETTERS:

	local function get_current_wifi_name() {
		local output=$(networksetup -getairportnetwork en0)
		local name=$(echo $output | cut -d':' -f2 | xargs)
		echo $name
	}

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

	local function get_wifi_list() {
		/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -s \
  			| awk 'NR==1 { printf "%-33s %-5s %s\n", $1, $2, $NF; next } \
         		{ printf "%-33s %-5s %s\n", substr($0,1,33), substr($0,34,5), $NF }' \
  			| tail -n +2 \
  			| column -t -s $'\t'
	}

	local function get_wifi_router_ip() {
		local output=$(route -n get default | grep gateway)
		local router_ip=$(echo $output | cut -d':' -f2 | xargs)
		echo "Router IP: ${router_ip}"
	}

	local function get_wifi_details() {
		networksetup -getinfo Wi-Fi
	}

	# SETTERS:

	local function turn_wifi_on() {
		networksetup -setairportpower en0 on
	}

	local function turn_wifi_off() {
		networksetup -setairportpower en0 off
	}

	# CONNECTING AND DISCONNECTING:

	local function connect_wifi() {
		local network=$1; local password=$2
		networksetup -setairportnetwork en0 $network $password
	}

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
					"status")
						get_wifi_status
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