#!/bin/bash
#
# ARG_POSITIONAL_SINGLE([input_template],[(twolevel_)modelbuild inputs template, with <subject-id>/<session-id> in place of filenames])
# ARG_OPTIONAL_SINGLE([prefix],[p],[Unique prefix to be prepended to all inputs],[])
# ARG_OPTIONAL_SINGLE([subfolder],[f],[Subfolder to be added between the <subject-id>/<session-id> and the files],[])
# ARG_OPTIONAL_SINGLE([suffix],[s],[suffix to complete the filenames in bids-style (filename=<subject-id>_<session-id>$suffix) ],[])
# ARG_OPTIONAL_SINGLE([output],[o],[Output],[/dev/stdout])
# ARG_OPTIONAL_BOOLEAN([overwrite],[w],[Overwrite output],[on])

# ARG_HELP([Create input file for (twolevel-)modelbuild.sh based on an inputs template, with <subject-id>/<session-id> in place of filenames])
# ARGBASH_GO()
# needed because of Argbash --> m4_ignore([
### START OF CODE GENERATED BY Argbash v2.10.0 one line above ###
# Argbash is a bash code generator used to get arguments parsing right.
# Argbash is FREE SOFTWARE, see https://argbash.dev for more info


die()
{
	local _ret="${2:-1}"
	test "${_PRINT_HELP:-no}" = yes && print_help >&2
	echo "$1" >&2
	exit "${_ret}"
}


begins_with_short_option()
{
	local first_option all_short_options='pfsowh'
	first_option="${1:0:1}"
	test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

# THE DEFAULTS INITIALIZATION - POSITIONALS
_positionals=()
# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_prefix=
_arg_subfolder=
_arg_suffix=
_arg_output="/dev/stdout"
_arg_overwrite="on"


print_help()
{
	printf '%s\n' "Create input file for (twolevel-)modelbuild.sh based on an inputs template, with <subject-id>/<session-id> in place of filenames"
	printf 'Usage: %s [-p|--prefix <arg>] [-f|--subfolder <arg>] [-s|--suffix <arg>] [-o|--output <arg>] [-w|--(no-)overwrite] [-h|--help] <input_template>\n' "$0"
	printf '\t%s\n' "<input_template>: (twolevel_)modelbuild inputs template, with <subject-id>/<session-id> in place of filenames"
	printf '\t%s\n' "-p, --prefix: Unique prefix to be prepended to all inputs (no default)"
	printf '\t%s\n' "-f, --subfolder: Subfolder to be added between the <subject-id>/<session-id> and the files (no default)"
	printf '\t%s\n' "-s, --suffix: suffix to complete the filenames in bids-style (filename=<subject-id>_<session-id>$suffix)  (no default)"
	printf '\t%s\n' "-o, --output: Output (default: '/dev/stdout')"
	printf '\t%s\n' "-w, --overwrite, --no-overwrite: Overwrite output (on by default)"
	printf '\t%s\n' "-h, --help: Prints help"
}


parse_commandline()
{
	_positionals_count=0
	while test $# -gt 0
	do
		_key="$1"
		case "$_key" in
			-p|--prefix)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_prefix="$2"
				shift
				;;
			--prefix=*)
				_arg_prefix="${_key##--prefix=}"
				;;
			-p*)
				_arg_prefix="${_key##-p}"
				;;
			-f|--subfolder)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_subfolder="$2"
				shift
				;;
			--subfolder=*)
				_arg_subfolder="${_key##--subfolder=}"
				;;
			-f*)
				_arg_subfolder="${_key##-f}"
				;;
			-s|--suffix)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_suffix="$2"
				shift
				;;
			--suffix=*)
				_arg_suffix="${_key##--suffix=}"
				;;
			-s*)
				_arg_suffix="${_key##-s}"
				;;
			-o|--output)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_output="$2"
				shift
				;;
			--output=*)
				_arg_output="${_key##--output=}"
				;;
			-o*)
				_arg_output="${_key##-o}"
				;;
			-w|--no-overwrite|--overwrite)
				_arg_overwrite="on"
				test "${1:0:5}" = "--no-" && _arg_overwrite="off"
				;;
			-w*)
				_arg_overwrite="on"
				_next="${_key##-w}"
				if test -n "$_next" -a "$_next" != "$_key"
				then
					{ begins_with_short_option "$_next" && shift && set -- "-w" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
				fi
				;;
			-h|--help)
				print_help
				exit 0
				;;
			-h*)
				print_help
				exit 0
				;;
			*)
				_last_positional="$1"
				_positionals+=("$_last_positional")
				_positionals_count=$((_positionals_count + 1))
				;;
		esac
		shift
	done
}


handle_passed_args_count()
{
	local _required_args_string="'input_template'"
	test "${_positionals_count}" -ge 1 || _PRINT_HELP=yes die "FATAL ERROR: Not enough positional arguments - we require exactly 1 (namely: $_required_args_string), but got only ${_positionals_count}." 1
	test "${_positionals_count}" -le 1 || _PRINT_HELP=yes die "FATAL ERROR: There were spurious positional arguments --- we expect exactly 1 (namely: $_required_args_string), but got ${_positionals_count} (the last one was: '${_last_positional}')." 1
}


assign_positional_args()
{
	local _positional_name _shift_for=$1
	_positional_names="_arg_input_template "

	shift "$_shift_for"
	for _positional_name in ${_positional_names}
	do
		test $# -gt 0 || break
		eval "$_positional_name=\${1}" || die "Error during argument parsing, possibly an Argbash bug." 1
		shift
	done
}

parse_commandline "$@"
handle_passed_args_count
assign_positional_args 1 "${_positionals[@]}"

# OTHER STUFF GENERATED BY Argbash

### END OF CODE GENERATED BY Argbash (sortof) ### ])
# [ <-- needed because of Argbash

# Set bash strict mode
set -euo pipefail
IFS=$'\n\t'

# Remove output content if overwrite is specified
if [ $_arg_overwrite = "on" ]; then
  printf "" > ${_arg_output}
fi

# Loop over lines in file
while IFS= read -r i_line; do
  # Split the line based on "commas"
  IFS="," read -ra all_session <<< "$i_line"
  i_line_output=""
  for i_session in ${all_session[@]}; do
    IFS="/" read -ra subject_session_ids <<< "$i_session"
    i_session_output=$(printf '%s%s/%s/%s/%s_%s%s' \
      "$_arg_prefix" \
      "${subject_session_ids[0]}" \
      "${subject_session_ids[1]}" \
      "$_arg_subfolder" \
      "${subject_session_ids[0]}" \
      "${subject_session_ids[1]}" \
      "$_arg_suffix")
    i_line_output=${i_line_output}${i_session_output},
  done
  i_line_output=${i_line_output::-1}
  printf '%s\n' $i_line_output >> ${_arg_output}

done < $_arg_input_template

# ] <-- needed because of Argbash
