parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1 /'
}
export PS1="\[\e[0;32m\]\$(parse_git_branch)\[\e[0;0m\][\[\e[0;36m\]\w\[\e[0;0m\]] "
