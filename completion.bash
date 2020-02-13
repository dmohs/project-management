_project_rb_complete() {
  COMPREPLY=()
  local word="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"

  # Only auto complete project.rb commands if its the first argument
  if [ "$prev" == "$1" ]; then
    local completions="$($1 --cmplt "$COMP_CWORD" "${COMP_WORDS[@]}")"
  else
    local completions="$(ls)"
  fi

  COMPREPLY=( $(compgen -W "$completions" -- "$word") )
}

complete -F _project_rb_complete ./project.rb
