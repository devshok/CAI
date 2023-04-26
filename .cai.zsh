#!/bin/zsh

# CONFIGURATION SETUP:

source ~/.cai/.cai.config

# CENTRALIZED ALIAS INTERFACE:

function cai() {

	# CAI DIRECTORIES:
	
	local CAI_PATH="${HOME}/.cai"
	local CAI_FILE=".${0}.zsh"
	local CAI_FILE_PATH="${CAI_PATH}/${CAI_FILE}"

	# CAI CONFIG DIRECTORIES:

	local CAI_CONFIG_FILE=".cai.config"
	local CAI_BLUETOOTH_DEVICES_FILE=".bluetooth_devices.config"
	local CAI_CONFIG_FILE_PATH="${CAI_PATH}/${CAI_CONFIG_FILE}"
	local CAI_BLUETOOTH_DEVICES_CONFIG_FILE_PATH="${CAI_PATH}/${CAI_BLUETOOTH_DEVICES_FILE}"

	# AG DIRECTORIES:

	local AG_PATH="${CAI_PATH}/ag"

	# BAD SYNTAX:

	local function print_bad_cai_syntax_error() {
		echo "bad syntax: run 'cai help' to get instructions."
	}

	local function print_bad_cai_update_syntax_error() {
		echo "bad syntax: run 'cai update help' to get instructions."
	}

	local function print_bad_cai_edit_syntax_error() {
		echo "bad syntax: run 'cai edit help' to get instructions."
	}

	local function print_bad_cai_set_editor_syntax_error() {
		echo "bad syntax: run 'cai set editor help' to get instructions."	
	}

	local function print_bad_cai_get_editor_syntax_error() {
		echo "bad syntax: run 'cai get editor help' to get instructions."
	}

	# HELP:

	local function print_cai_help() {
		echo "Here are some instructions for usage 'cai help'"
	}

	local function print_cai_update_help() {
		echo "Here are some instructions for usage 'cai update help'"
	}

	local function print_cai_edit_help() {
		echo "Here are some instructions for usage 'cai edit help'"
	}

	local function print_cai_set_editor_help() {
		echo "Here are some instructions for usage 'cai set editor help'"
	}

	local function print_cai_get_editor_help() {
		echo "Here are some instructions for usage 'cai get editor help'"
	}

	# UPDATE HELPERS:

	local function update_cai() {
		source "$CAI_FILE_PATH"
	}

	local function update_all_ag() {
		for ag in "${AG_PATH}/".*.zsh; do
			source $ag
		done
		update_cai
	}

	local function update_core() {
		source ~/.zshrc
	}

	local function update_cai_config() {
		source "${CAI_CONFIG_FILE_PATH}"
	}

	local function handle_update_operation() {
		local update_option=$1
		case $update_option in
			"wifi" | "bluetooth" | "files" | "git")
				source "${AG_PATH}"/."${update_option}".zsh
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
			"help")
				print_cai_update_help
				;;
			*)
				print_bad_cai_update_syntax_error
				;;
		esac
	}

	# EDIT HELPERS:

	local function edit_core() {
		OPEN_BY_CAI_DEFAULT_EDITOR ~/.zshrc
	}

	local function edit_cai() {
		OPEN_BY_CAI_DEFAULT_EDITOR "$CAI_FILE_PATH"
	}

	local function edit_cai_configs() {
		OPEN_BY_CAI_DEFAULT_EDITOR "$CAI_CONFIG_FILE_PATH"
		OPEN_BY_CAI_DEFAULT_EDITOR "$CAI_BLUETOOTH_DEVICES_CONFIG_FILE_PATH"
	}

	local function edit_ag() {
		OPEN_BY_CAI_DEFAULT_EDITOR "${AG_PATH}"/."${1}".zsh
	}

	local function edit_all() {
		edit_core
		edit_cai
		edit_cai_configs
		for ag in "${AG_PATH}"/.*.zsh; do
			OPEN_BY_CAI_DEFAULT_EDITOR $ag
		done
	}

	local function handle_edit_operation() {
		local edit_option="$1"
		case $edit_option in
			"wifi" | "bluetooth" | "files" | "git")
				edit_ag $edit_option
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
			"help")
				print_cai_edit_help
				;;
			*)
				print_bad_cai_edit_syntax_error
				;;
		esac
	}

	local func set_new_cai_editor() {
		sed -i '' "s/CAI_DEFAULT_EDITOR=.*/CAI_DEFAULT_EDITOR=\"$1\"/" "${CAI_CONFIG_FILE_PATH}"
		update_cai_config
	}

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
					print_bad_cai_syntax_error
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
						print_bad_cai_update_syntax_error
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
				else
					print_bad_cai_get_editor_syntax_error
				fi
				;;
			"set")
				if [ $# -eq 3 ] && [ "$1" = "set" ] && [ "$2" = "editor" ] && [ -n $3 ]; then
					if is_new_editor_valid $3; then
						set_new_cai_editor $3
					else
						print_bad_cai_set_editor_syntax_error
					fi
				else
					print_bad_cai_set_editor_syntax_error
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