#!/bin/zsh

# CONFIGURATION SETUP:

source ~/.cai/.cai.config

# CENTRALIZED ALIAS INTERFACE:

function cai() {

	# Path to the directory containing CAI scripts and configuration files
	local CAI_PATH="${HOME}/.cai"

	# Name of the configuration file
	local CAI_FILE=".${0}.zsh"

	# Path to the directory containing this file
	local CAI_FILE_PATH="${CAI_PATH}/${CAI_FILE}"

	# Name of the CAI config file
	local CAI_CONFIG_FILE=".cai.config"

	# Name of the CAI Bluetooth devices config file
	local CAI_BLUETOOTH_DEVICES_FILE=".bluetooth_devices.config"

	# Name of the CAI WiFi networks config file
	local CAI_WIFI_NETWORKS_FILE=".wifi_networks.config"

	# Full path to the CAI config file
	local CAI_CONFIG_FILE_PATH="${CAI_PATH}/${CAI_CONFIG_FILE}"

	# Full path to the CAI Bluetooth devices config file
	local CAI_BLUETOOTH_DEVICES_CONFIG_FILE_PATH="${CAI_PATH}/${CAI_BLUETOOTH_DEVICES_FILE}"

	# Full path to the CAI WiFi networks config file
	local CAI_WIFI_NETWORKS_CONFIG_FILE_PATH="${CAI_PATH}/${CAI_WIFI_NETWORKS_FILE}"

	# The path to the "ag" directory where all the Alias Groups are stored.
	# Each Alias Group is a collection of shell functions that are sourced together
	# when the corresponding alias is executed. This variable is set to the "ag"
	# subdirectory of the main CAI directory.
	local AG_PATH="${CAI_PATH}/ag"

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
	# 	- print_note_for_help
	# 	- print_cai_run_bad_syntax_error
	# 	- print_cai_update_bad_syntax_error
	# 	- print_cai_get_editor_bad_syntax_error
	# 	- print_cai_set_editor_bad_syntax_error
	# 	- print_cai_help
	# 	- print_bad_cai_syntax_error
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
		printf "\t1. Use \033[1mcai help\033[0m to get more instructions.\n"
		if [[ $# -gt 0 ]]; then
			local i=2
			for note in "$@"; do
				printf "\t${i}. ${note}\n"
				((i++))
			done
		fi
		print_empty_line
	}

	local function print_cai_run_bad_syntax_error() {
		print_bad_syntax_title_with_message "\t$(tput setaf 3)cai run$(tput sgr0)"
		echo "Usage:"
		print_empty_line
		printf "\t$(tput setaf 3)cai run$(tput sgr0)\n\n"
		print_note_for_help
		print_empty_line
	}

	local function print_cai_update_bad_syntax_error() {
		print_bad_syntax_title_with_message "\t$(tput setaf 3)cai update$(tput sgr0)"
		echo "Usage:"
		print_empty_line
		printf "\t$(tput setaf 3)cai update [option]$(tput sgr0)\n"
		print_empty_line
		echo "Options:"
		print_empty_line
		printf "\t\033[1mwifi\033[0m\t\tSource the Wi-Fi Alias Group.\n"
		printf "\t\033[1mfiles\033[0m\t\tSource the Files Alias Group.\n"
		printf "\t\033[1mgit\033[0m\t\tSource the Git Alias Group.\n"
		printf "\t\033[1mbluetooth\033[0m\tSource the Bluetooth Alias Group.\n"
		printf "\t\033[1mcore\033[0m\t\tSource \033[1m.zshrc\033[0m file.\n"
		printf "\t\033[1mconfig\033[0m\t\tSource the CAI config.\n"
		printf "\t\033[1mconfigs\033[0m\t\tSource the CAI, Wi-Fi and Bluetooth Configuration files.\n"
		printf "\t\033[1mall\033[0m\t\tSource all AG files, the CAI file, and all configurations (CAI, Wi-FI and Bluetooth as well).\n"
		printf "\t\033[1mhelp\033[0m\t\tShow this page that helps you to use \033[1mcai update\033[0m.\n"
		print_empty_line
		print_note_for_help "\033[1mcai update\033[0m without any options sources itself (\033[1m.cai.zsh\033[0m file)."
		print_empty_line
	}

	local function print_cai_update_help_page() {
		print_empty_line
		echo "Usage:"
		print_empty_line
		printf "\t$(tput setaf 3)cai update [option]$(tput sgr0)\n"
		print_empty_line
		echo "Options:"
		print_empty_line
		printf "\t\033[1mwifi\033[0m\t\tSource the Wi-Fi Alias Group.\n"
		printf "\t\033[1mfiles\033[0m\t\tSource the Files Alias Group.\n"
		printf "\t\033[1mgit\033[0m\t\tSource the Git Alias Group.\n"
		printf "\t\033[1mbluetooth\033[0m\tSource the Bluetooth Alias Group.\n"
		printf "\t\033[1mcore\033[0m\t\tSource \033[1m.zshrc\033[0m file.\n"
		printf "\t\033[1mconfig\033[0m\t\tSource the CAI config.\n"
		printf "\t\033[1mconfigs\033[0m\t\tSource the CAI, Wi-Fi and Bluetooth Configuration files.\n"
		printf "\t\033[1mall\033[0m\t\tSource all AG files, the CAI file, and all configurations (CAI, Wi-FI and Bluetooth as well).\n"
		printf "\t\033[1mhelp\033[0m\t\tShow this page that helps you to use \033[1mcai update\033[0m.\n"
		print_empty_line
		print_note_for_help "\033[1mcai update\033[0m without any options sources itself (\033[1m.cai.zsh\033[0m file)."
		print_empty_line
	}

	local function print_cai_edit_bad_syntax_error() {
		print_bad_syntax_title_with_message "\t$(tput setaf 3)cai edit$(tput sgr0)"
		echo "Usage:"
		print_empty_line
		printf "\t$(tput setaf 3)cai edit [option]$(tput sgr0)\n"
		print_empty_line
		echo "Options:"
		print_empty_line
		printf "\t\033[1mwifi\033[0m\t\tOpen the Wi-Fi Alias Group file by the default editor specified by the user.\n"
		printf "\t\033[1mfiles\033[0m\t\tOpen the Files Alias Group file by the default editor specified by the user.\n"
		printf "\t\033[1mgit\033[0m\t\tOpen the Git Alias Group  file by the default editor specified by the user.\n"
		printf "\t\033[1mbluetooth\033[0m\tOpen the Bluetooth Alias Group file by the default editor specified by the user.\n"
		printf "\t\033[1mcore\033[0m\t\tOpen \033[1m.zshrc\033[0m file.\n"
		printf "\t\033[1mconfig\033[0m\t\tOpen the CAI config file by the default editor specified by the user.\n"
		printf "\t\033[1mconfigs\033[0m\t\tOpen the CAI, Wi-Fi and Bluetooth Configuration files by the default editor specified by the user.\n"
		printf "\t\033[1mall\033[0m\t\tOpen all AG files, the CAI file, and all configurations (CAI, Wi-FI and Bluetooth as well).\n"
		printf "\t\033[1mhelp\033[0m\t\tShow this page that helps you to use \033[1mcai edit\033[0m.\n"
		print_empty_line
		print_note_for_help "\033[1mcai edit\033[0m without any options opens itself (\033[1m.cai.zsh\033[0m file) to edit."
		print_empty_line
	}

	local function print_cai_edit_help_page() {
		print_empty_line
		echo "Usage:"
		print_empty_line
		printf "\t$(tput setaf 3)cai edit [option]$(tput sgr0)\n"
		print_empty_line
		echo "Options:"
		print_empty_line
		printf "\t\033[1mwifi\033[0m\t\tOpen the Wi-Fi Alias Group file by the default editor specified by the user.\n"
		printf "\t\033[1mfiles\033[0m\t\tOpen the Files Alias Group file by the default editor specified by the user.\n"
		printf "\t\033[1mgit\033[0m\t\tOpen the Git Alias Group  file by the default editor specified by the user.\n"
		printf "\t\033[1mbluetooth\033[0m\tOpen the Bluetooth Alias Group file by the default editor specified by the user.\n"
		printf "\t\033[1mcore\033[0m\t\tOpen \033[1m.zshrc\033[0m file.\n"
		printf "\t\033[1mconfig\033[0m\t\tOpen the CAI config file by the default editor specified by the user.\n"
		printf "\t\033[1mconfigs\033[0m\t\tOpen the CAI, Wi-Fi and Bluetooth Configuration files by the default editor specified by the user.\n"
		printf "\t\033[1mall\033[0m\t\tOpen all AG files, the CAI file, and all configurations (CAI, Wi-FI and Bluetooth as well).\n"
		printf "\t\033[1mhelp\033[0m\t\tShow this page that helps you to use \033[1mcai edit\033[0m.\n"
		print_empty_line
		local notes=(
			"\033[1mcai edit\033[0m without any options opens itself (\033[1m.cai.zsh\033[0m file) to edit."
			"Use \033[1mcai update\033[0m to update your changes to make it work."
		)
		print_note_for_help "${notes[@]}"
		echo "Examples:"
		print_empty_line
		printf "\t\033[1mcai edit wifi\033[0m\t\tOpen and start editing Wi-FI AG. And then save it.\n"
		printf "\t\033[1mcai update wifi\033[0m\t\tAnd then update to make it work."
		print_empty_line
		print_empty_line
	}

	local function print_cai_get_editor_bad_syntax_error() {
		print_bad_syntax_title_with_message "\t$(tput setaf 3)cai get [option]$(tput sgr0)"
		echo "Usage:"
		print_empty_line
		printf "\t$(tput setaf 3)cai get [option]$(tput sgr0)\n"
		print_empty_line
		echo "Options:"
		print_empty_line
		printf "\t\033[1meditor\033[0m\tShow the default editor that user chose to use by default.\n"
		print_empty_line
		local notes=(
			"Use \033[1mcai edit config\033[0m to edit a list of editors."
			"And then use \033[1mcai update config\033[0m to update changes."
		)
		print_note_for_help "${notes[@]}"
		print_empty_line
	}

	local function print_cai_get_help() {
		print_empty_line
		echo "Usage:"
		print_empty_line
		printf "\t$(tput setaf 3)cai get [option]$(tput sgr0)\n"
		print_empty_line
		echo "Options:"
		print_empty_line
		printf "\t\033[1meditor\033[0m\tShow the default editor that user chose to use by default.\n"
		print_empty_line
		local notes=(
			"Use \033[1mcai edit config\033[0m to edit a list of editors."
			"And then use \033[1mcai update config\033[0m to update changes."
		)
		print_note_for_help "${notes[@]}"
		print_empty_line
	}

	local function print_cai_set_editor_bad_syntax_error() {
		print_bad_syntax_title_with_message "\t$(tput setaf 3)cai set [option]$(tput sgr0)"
		echo "Usage:"
		print_empty_line
		printf "\t$(tput setaf 3)cai set [option] <editor>$(tput sgr0)\n"
		print_empty_line
		echo "Options:"
		print_empty_line
		printf "\t\033[1meditor\033[0m\tAn indicator to set and use a new editor by default for editing CAI files.\n"
		print_empty_line
		echo "Editors:"
		print_empty_line
		for alias_name editor_name in ${(kv)CAI_EDITORS_LIST}; do
			echo "\tUse \033[1mcai set editor ${alias_name}\033[0m to set ${editor_name} as a default editor"
		done
		print_empty_line
		local notes=(
			"Use \033[1mcai edit config\033[0m to edit a list of editors."
			"And then use \033[1mcai update config\033[0m to update changes."
		)
		print_note_for_help "${notes[@]}"
		print_empty_line
	}

	local function print_cai_set_help() {
		print_empty_line
		echo "Usage:"
		print_empty_line
		printf "\t$(tput setaf 3)cai set [option] <editor>$(tput sgr0)\n"
		print_empty_line
		echo "Options:"
		print_empty_line
		printf "\t\033[1meditor\033[0m\tAn indicator to set and use a new editor by default for editing CAI files.\n"
		print_empty_line
		echo "Editors:"
		print_empty_line
		for alias_name editor_name in ${(kv)CAI_EDITORS_LIST}; do
			echo "\tUse \033[1mcai set editor ${alias_name}\033[0m to set ${editor_name} as a default editor"
		done
		print_empty_line
		local notes=(
			"Use \033[1mcai edit config\033[0m to edit a list of editors."
			"And then use \033[1mcai update config\033[0m to update changes."
		)
		print_note_for_help "${notes[@]}"
		print_empty_line
	}

	local function print_cai_help() {
		printf "\n\033[1mCAI\033[0m - A Centralized Alias Interface for managing macOS utilities such as Wi-Fi, Bluetooth, git, files on macOS.\n"
		printf "\033[1mCAI\033[0m is divided into a few Alias Groups \033[1m(AG)\033[0m like below:\n"
		print_empty_line
		printf "\t\033[1mwifi\033[0m\n"
		echo "\t- - - - - - - - - - - - - - - - - - - - - - - - - - -"
		printf "\tAG that helps to work with Wi-Fi interface.\n"
		printf "\tUse \033[1mwifi help\033[0m to explore more details.\n"
		print_empty_line
		printf "\t\033[1mbluetooth\033[0m\n"
		echo "\t- - - - - - - - - - - - - - - - - - - - - - - - - - -"
		printf "\tAG that helps to work with Bluetooth interface.\n"
		printf "\tUse \033[1mbluetooth help\033[0m to explore more details.\n"
		print_empty_line
		printf "\t\033[1mfiles\033[0m\n"
		echo "\t- - - - - - - - - - - - - - - - - - - - - - - - - - -"
		printf "\tAG that stores your aliases to make your work easier with files and directories.\n"
		printf "\tUse \033[1mcai edit files\033[0m to edit aliases there.\n"
		print_empty_line
		printf "\t\033[1mgit\033[0m\n"
		echo "\t- - - - - - - - - - - - - - - - - - - - - - - - - - -"
		printf "\tAG that stores your aliases to make your work easier with Git.\n"
		printf "\tUse \033[1mcai edit git\033[0m to edit aliases there.\n"
		print_empty_line
		printf "Usage:\n"
		print_empty_line
		printf "\t$(tput setaf 3)cai [option]$(tput sgr0)\n\n"
		printf "Options:\n"
		print_empty_line
		printf "\t\033[1mrun\033[0m\t\t\tSources all AGs + CAI itself and its all configurations.\n"
		printf "\t\033[1mupdate [option]\033[0m\t\tWorks like \033[1mcai run\033[0m but with some tricky changes. Use \033[1mcai update help\033[0m to explore more.\n"
		printf "\t\033[1medit [option]\033[0m\t\tOpen any file of configurations, AGs or even CAI itself. Use \033[1mcai edit help\033[0m to explore more.\n"
		printf "\t\033[1mget [option]\033[0m\t\tGet any information you need. Use \033[1mcai get help\033[0m to explore more.\n"
		printf "\t\033[1mset [option]\033[0m\t\tSet any information you need. Use \033[1mcai set help\033[0m to explore more.\n"
		printf "\t\033[1mhelp\033[0m\t\t\tShow this help message.\n"
		print_empty_line
		printf "Examples:\n"
		print_empty_line
		printf "\t\033[1mcai edit all\033[0m\t\tOpen all CAI's files including configurations by a specified default editor by the user.\n"
		printf "\t\033[1mcai update all\033[0m\t\tSource and update all changes in all files.\n"
		print_empty_line
		print_empty_line
	}

	local function print_bad_cai_syntax_error() {
		print_error_title
		echo "Wrong syntax. Check instructions below."
		print_underline
		print_cai_help
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	update_cai
	#
	# Description:
	# 	Source the CAI file to update the command-line tool.
	#
	local function update_cai() {
		source "$CAI_FILE_PATH"
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	update_all_ag
	#
	# Description:
	# 	Source all of the AG files to update the custom functions and aliases.
	# 	And the CAI file itself.
	#
	local function update_all_ag() {
		for ag in "${AG_PATH}/".*.zsh; do
			source $ag
		done
		update_cai
		update_cai_configs
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	update_core
	#
	# Description:
	# 	Source the .zshrc file to update the shell configuration.
	#
	local function update_core() {
		source ~/.zshrc
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	update_cai_config
	#
	# Description:
	# 	Source the CAI configuration file.
	#
	local function update_cai_config() {
		source "${CAI_CONFIG_FILE_PATH}"
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	update_cai_configs
	#
	# Description:
	# 	Source the CAI, bluetooth and Wi-Fi configuration files.
	#
	local function update_cai_configs() {
		source "${CAI_CONFIG_FILE_PATH}"
		source "${CAI_WIFI_NETWORKS_CONFIG_FILE_PATH}"
		source "${CAI_BLUETOOTH_DEVICES_CONFIG_FILE_PATH}"
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	handle_update_operation
	#
	# Description:
	# 	Update the desired feature, or display the help message if the syntax is incorrect.
	#
	# Arguments:
	# 	- $1: an option that specifies the update operation.
	#
	local function handle_update_operation() {
		local update_option=$1
		case $update_option in
			"wifi" | "files" | "git")
				source "${AG_PATH}"/."${update_option}".zsh
				;;
			"bluetooth")
				source "${AG_PATH}"/."${update_option}".zsh
				source "${CAI_BLUETOOTH_DEVICES_CONFIG_FILE_PATH}"
				;;
			"all")
				update_all_ag
				;;
			"core")
				update_core
				;;
			"config")
				update_cai_config
				;;
			"configs")
				update_cai_configs
				;;
			"help")
				print_cai_update_help_page
				;;
			*)
				print_cai_update_bad_syntax_error
				;;
		esac
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	edit_core
	#
	# Description:
	# 	Open the .zshrc file in the default editor specified by the user.
	#
	local function edit_core() {
		OPEN_BY_CAI_DEFAULT_EDITOR ~/.zshrc
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	edit_cai
	#
	# Description:
	# 	Open the CAI file in the default editor specified by the user.
	#
	local function edit_cai() {
		OPEN_BY_CAI_DEFAULT_EDITOR "$CAI_FILE_PATH"
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	edit_cai_config
	#
	# Description:
	# 	Open the CAI configuration file in the default editor specified by the user.
	#
	local function edit_cai_config() {
		OPEN_BY_CAI_DEFAULT_EDITOR "$CAI_CONFIG_FILE_PATH"
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	edit_cai_configs
	#
	# Description:
	# 	Open the Wi-Fi networks and Bluetooth devices configuration files in the default editor specified by the user.
	# 	And open the CAI configuration file as well in the default editor specified by the user.
	#
	local function edit_cai_configs() {
		OPEN_BY_CAI_DEFAULT_EDITOR "$CAI_CONFIG_FILE_PATH"
		OPEN_BY_CAI_DEFAULT_EDITOR "$CAI_BLUETOOTH_DEVICES_CONFIG_FILE_PATH"
		OPEN_BY_CAI_DEFAULT_EDITOR "$CAI_WIFI_NETWORKS_CONFIG_FILE_PATH"
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	edit_ag
	#
	# Description:
	# 	Open the specified AG file in the default editor specified by the user.
	#
	# Arguments:
	# 	- $1: AG
	#
	local function edit_ag() {
		OPEN_BY_CAI_DEFAULT_EDITOR "${AG_PATH}"/."${1}".zsh
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	edit_all
	#
	# Description:
	# 	Open all AG files in the default editor specified by the user.
	#
	local function edit_all() {
		edit_core
		edit_cai
		edit_cai_configs
		for ag in "${AG_PATH}"/.*.zsh; do
			OPEN_BY_CAI_DEFAULT_EDITOR $ag
		done
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	handle_edit_operation
	#
	# Description:
	# 	Handle the edit operation depending on the given option.
	#
	# Arguments:
	# 	- $1: AG
	#
	local function handle_edit_operation() {
		local edit_option="$1"
		case $edit_option in
			"wifi" | "files" | "git")
				edit_ag $edit_option
				;;
			"bluetooth")
				edit_ag $edit_option
				OPEN_BY_CAI_DEFAULT_EDITOR "$CAI_BLUETOOTH_DEVICES_CONFIG_FILE_PATH"
				;;
			"core")
				edit_core
				;;
			"all")
				edit_all
				;;
			"config")
				edit_cai_config
				;;
			"configs")
				edit_cai_configs
				;;
			"help")
				print_cai_edit_help_page
				;;
			*)
				print_cai_edit_bad_syntax_error
				;;
		esac
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	set_new_cai_editor
	#
	# Description:
	# 	Set a new CAI default editor.
	#
	# Arguments:
	# 	- $1: a new name of the default editor
	#
	local func set_new_cai_editor() {
		sed -i '' "s/CAI_DEFAULT_EDITOR=.*/CAI_DEFAULT_EDITOR=\"$1\"/" "${CAI_CONFIG_FILE_PATH}"
		update_cai_config
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	OPEN_BY_CAI_DEFAULT_EDITOR
	#
	# Description:
	# 	Open a target file using the CAI default editor.
	#
	# Arguments:
	# 	- $1: a target file path to open by the default CAI editor.
	#
	local function OPEN_BY_CAI_DEFAULT_EDITOR() {
		local USER_CAI_EDITOR=true
		local readonly TARGET_FILE_PATH="$1"
		local OPEN_COMMAND=""
		local func set_default_editor() {
			local nano_editor="${CAI_EDITORS_LIST[nano]}"
			OPEN_COMMAND=$nano_editor
			set_new_cai_editor $nano_editor
			# result → OPEN_COMMAND="nano"
			# result → CAI_DEFAULT_EDITOR="nano" in ~/.cai.config
		}
		if [ -z "$TARGET_FILE_PATH" ]; then
			print_cai_edit_help
			return 1
		fi
		if [ -z "$CAI_DEFAULT_EDITOR" ]; then
			USER_CAI_EDITOR=false
		fi
		if $USER_CAI_EDITOR; then
			local found_editor=false
			for key value in ${(kv)CAI_EDITORS_LIST}; do
				if [[ $key == $CAI_DEFAULT_EDITOR ]]; then
					if [[ $value[1] == ${(U)value[1]} ]]; then
						# For example,
						# result → OPEN_COMMAND="open -a Xcode" if USER_CAI_EDITOR="xcode"
						OPEN_COMMAND="open -a ${value}"
					else
						# For example,
						# result → OPEN_COMMAND="vim" if USER_CAI_EDITOR="vim"
						OPEN_COMMAND=$value
					fi
					found_editor=true
					break
				fi
			done
			if [[ ! $found_editor == true ]]; then
				set_default_editor
			fi
		fi
		if [[ -z "$OPEN_COMMAND" && ! $USER_CAI_EDITOR == true ]]; then
			set_default_editor
		fi
		eval "${OPEN_COMMAND} ${TARGET_FILE_PATH}"
	}

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	# Function name:
	# 	is_new_editor_valid
	#
	# Description:
	# 	This function is used to check if a new editor specified by the user is valid or not.
	#
	# Arguments:
	# 	- arg name: arg description
	#
	# Returns:
	# 	- If the key matches the argument, this line returns a success status of 0.
	# 	- If none of the keys match the argument, this line returns a failure status of 1.
	#
	local func is_new_editor_valid() {
		for key in ${(k)CAI_EDITORS_LIST}; do
			if [[ $key == $1 ]]; then
				return 0
			fi
		done
		return 1
	}

	# MAIN PART OF THE SCRIPT:

	if test -z "$1"; then
		print_bad_cai_syntax_error
	else
		case $1 in
			"run")
				if [ $# -eq 1 ]; then
					update_all_ag
				else
					print_cai_run_bad_syntax_error
				fi
				;;
			"update")
				case $# in
					1)
						update_cai
						;;
					2)
						local update_option="$2"
						handle_update_operation $update_option
						;;
					*)
						print_cai_update_bad_syntax_error
						;;
				esac
				;;
			"edit")
				case $# in
					1)
						edit_cai
						;;
					2)
						local edit_option="$2"
						handle_edit_operation $edit_option
						;;
					*)
						print_bad_cai_edit_syntax_error
						;;
				esac
				;;
			"get")
				if [ $# -eq 2 ] && [ "$1" = "get" ] && [ "$2" = "editor" ]; then
					echo ${CAI_DEFAULT_EDITOR}
				elif [[ $# -eq 2 && "$2" == "help" ]]; then
					print_cai_get_help
				else
					print_cai_get_editor_bad_syntax_error
				fi
				;;
			"set")
				if [ $# -eq 3 ] && [ "$1" = "set" ] && [ "$2" = "editor" ] && [ -n $3 ]; then
					if is_new_editor_valid $3; then
						set_new_cai_editor $3
					else
						print_cai_set_editor_bad_syntax_error
					fi
				elif [[ $# -eq 2 && "$2" == "help" ]]; then
					print_cai_set_help
				else
					print_cai_set_editor_bad_syntax_error
				fi
				;;
			"help")
				if [ $# -eq 1 ]; then
					print_cai_help
				else
					print_bad_cai_syntax_error
				fi
				;;
			*)
				print_bad_cai_syntax_error
				;;
		esac
	fi
}