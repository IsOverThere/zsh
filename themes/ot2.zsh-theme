#!/usr/bin/env zsh

# ------------------------------------------------------------------------------
#
# Pure - A minimal and beautiful theme for oh-my-zsh
#
# Based on the custom Zsh-prompt of the same name by Sindre Sorhus. A huge
# thanks goes out to him for designing the fantastic Pure prompt in the first
# place! I'd also like to thank Julien Nicoulaud for his "nicoulaj" theme from
# which I've borrowed both some ideas and some actual code. You can find out
# more about both of these fantastic two people here:
#
# Sindre Sorhus
#   Github:   https://github.com/sindresorhus
#   Twitter:  https://twitter.com/sindresorhus
#
# Julien Nicoulaud
#   Github:   https://github.com/nicoulaj
#   Twitter:  https://twitter.com/nicoulaj
#
# ------------------------------------------------------------------------------

# Set required options
#
setopt prompt_subst

# Load required modules
#

# Fastest possible way to check if repo is dirty
#
#git_dirty() {
    ## Check if we're in a git repo
    #command git rev-parse --is-inside-work-tree &>/dev/null || return
    ## Check if it's dirty
    #command git diff --quiet --ignore-submodules HEAD &>/dev/null; [ $? -eq 1 ] && echo "*"
#}

# Display information about the current repository
#
#repo_information() {
    #echo "%F{blue}${vcs_info_msg_0_%%/.} %F{8}$vcs_info_msg_1_`git_dirty` $vcs_info_msg_2_%f"
#}

# Displays the exec time of the last command if set threshold was exceeded
#
cmd_exec_time() {
    local stop=`date +%s`
    local start=${cmd_timestamp:-$stop}
    let local elapsed=$stop-$start
    #    [ $elapsed -gt 5 ] && echo  ${elapsed}s
    #if [ $elapsed -gt 5 ]
    #then
        #local elapsed_format=""
        #if (($elapsed/3600 != 0)); then
            #elapsed_format=$(($elapsed/3600))"h"$(($elapsed%3600/60))"m"
        #else
            #if (($elapsed/60 != 0)); then
                #elapsed_format=$(($elapsed/60))"m"
            #fi
        #fi
        #elapsed_format=$elapsed_format$(($elapsed%60))"s"
        #echo " ${elapsed_format}"
    #fi
    if [ $elapsed -gt 5 ]
    then
        local elapsed_format=""
        if (($elapsed/3600 != 0)); then
            elapsed_format=$(($elapsed/3600))"h"
        fi
        if (($elapsed%3600/60 != 0)); then
            elapsed_format=$elapsed_format$(($elapsed%3600/60))"m"
        fi
        if (($elapsed%60 != 0)); then
            elapsed_format=$elapsed_format$(($elapsed%60))"s"
        fi
        #echo "羽${elapsed_format}"
        echo "羽${elapsed_format}"
    fi
}

# Get the initial timestamp for cmd_exec_time
#
preexec() {
    cmd_timestamp=`date +%s`
}

#from ~/.zsh/oh-my-zsh/themes/bureau.zsh-theme
#ZSH_THEME_GIT_PROMPT_PREFIX="[%{$fg_bold[green]%}±%{$reset_color%}%{$fg_bold[white]%}"
#ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}]"
#ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}✓%{$reset_color%}"
#ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[cyan]%}▴%{$reset_color%}"
#ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[magenta]%}▾%{$reset_color%}"
#ZSH_THEME_GIT_PROMPT_STAGED="%{$fg_bold[green]%}●%{$reset_color%}"
#ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg_bold[yellow]%}●%{$reset_color%}"
#ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}●%{$reset_color%}"
#

#  ●                      
local DIRTY_STRING=""
ZSH_THEME_GIT_PROMPT_PREFIX="( "
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_AHEAD="%{$FG[039]%}%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$FG[165]%}%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_STAGED="%{$FG[040]%}${DIRTY_STRING}%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNSTAGED_ONLY="%{$FG[226]%}⚡%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$FG[226]%}${DIRTY_STRING}%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$FG[160]%}${DIRTY_STRING}%{$reset_color%}"
local FLAGS='--ignore-submodules=dirty'

bureau_git_branch () {
  ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  echo "${ref#refs/heads/}"
}

bureau_git_status() {
  _STATUS=""

  # check status of files
  _INDEX=$(command git status ${FLAGS} --porcelain 2> /dev/null)
  if [[ -n "$_INDEX" ]]; then
    if $(echo "$_INDEX" | command grep -q '^[AMRD]. '); then
      _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_STAGED"
    fi
    if $(echo "$_INDEX" | command grep -q '^.[MTD] '); then
      _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_UNSTAGED"
    fi
    if $(echo "$_INDEX" | command grep -q -E '^\?\? '); then
      _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED"
    fi
    if $(echo "$_INDEX" | command grep -q '^UU '); then
      _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_UNMERGED"
    fi
  else
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi

  # check status of local repository
  _INDEX=$(command git status ${FLAGS} --porcelain -b 2> /dev/null)
  if $(echo "$_INDEX" | command grep -q '^## .*ahead'); then
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_AHEAD"
  fi
  if $(echo "$_INDEX" | command grep -q '^## .*behind'); then
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_BEHIND"
  fi
  if $(echo "$_INDEX" | command grep -q '^## .*diverged'); then
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_DIVERGED"
  fi

  if $(command git rev-parse --verify refs/stash &> /dev/null); then
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_STASHED"
  fi

  if [ "${_STATUS}"x = "${ZSH_THEME_GIT_PROMPT_UNSTAGED}"x ]; then
    _STATUS="$ZSH_THEME_GIT_PROMPT_UNSTAGED_ONLY"
  fi

  echo $_STATUS
}
ZSH_THEME_GIT_PROMPT=yes
bureau_git_prompt () {
  #local _pwd=$(command pwd)
  #if [ "${_pwd}" =~ "xxx" ]; then
  if [ "${ZSH_THEME_GIT_PROMPT}"x == "no"x ]; then
      #_result="( %{$FG[123]%}%{$reset_color%})"
      _result=""
  else
      local _branch=$(bureau_git_branch)
      local _status=$(bureau_git_status)
      #if has space in reture value
      #local _status="$(bureau_git_status)"
      local _result=""
      if [[ "${_branch}x" != "x" ]]; then
        _result="$ZSH_THEME_GIT_PROMPT_PREFIX$_branch"
        if [[ "${_status}x" != "x" ]]; then
          _result="$_result $_status"
        fi
        _result="$_result$ZSH_THEME_GIT_PROMPT_SUFFIX"
      fi
  fi
  echo $_result
}


# Output additional information about paths, repos and exec time
#
#precmd() {
    #vcs_info # Get version control info before we start outputting stuff
    #print -P "\n$(repo_information) %F{yellow}$(cmd_exec_time)%f"
#}


cmd_print_host() {
    if [ $HOST = "zhangcl-Latitude-E5440" ] || [ $HOST = "ubuntuvmwarezhangcl" ]
    then
        system_icon=""
    elif [ $HOST = "zhangcl-OptiPlex-7010" ]
    then
        system_icon="ﲾ"
    else
        system_icon=""
    fi
    echo "$system_icon"
}

# Define prompts
#   羽  力 ﲾ    
#PROMPT=$'%{\e[38;5;172m%} %{\e[38;5;242m%}U%{\e[38;5;241m%}B%{\e[38;5;240m%}U%{\e[38;5;239m%}N%{\e[38;5;238m%}T%{\e[38;5;237m%}U %{\e[38;5;31m%}%n%{\e[0m%}@%M: %{\e[38;5;255m%}%~%{\e[0m%} $(git_prompt_info) [%{\e[38;5;248m%}%w %*%{\e[0m%}] %{\e[38;5;200m%}$(cmd_exec_time)%{\e[0m%}
#%(?.%{\e[38;5;242m%}>%{\e[38;5;241m%}>%{\e[38;5;239m%}>%{\e[38;5;238m%}>%{\e[38;5;237m%}>%{\e[38;5;236m%}>%{\e[38;5;235m%}>%{\e[0m%}.%{\e[38;5;21m%}>%{\e[38;5;20m%}>%{\e[38;5;19m%}>%{\e[38;5;18m%}>%{\e[38;5;17m%}>%{\e[0m%}'
#fixed color
#PROMPT='%{$FG[202]%}$(cmd_print_host) %{$FG[242]%}U%{$FG[241]%}B%{$FG[240]%}U%{$FG[239]%}N%{$FG[238]%}T%{$FG[237]%}U %{$FG[031]%}%n%f@%M: %{$FG[255]%}%~%f $(git_prompt_info) [%{$FG[248]%}%w %*%f] %{$FG[214]%}   $(cmd_exec_time)%f
#%(?.%{$FG[242]%}>%{$FG[241]%}>%{$FG[239]%}>%{$FG[238]%}>%{$FG[237]%}>%{$FG[236]%}>%{$FG[235]%}>%f.%{$FG[196]%}>%{$FG[202]%}>%{$FG[208]%}>%{$FG[214]%}>%{$FG[220]%}>%{$FG[226]%}>%f'
#for all color schemes
PROMPT='%{$FG[034]%}$(cmd_print_host) %{$FG[242]%}U%{$FG[241]%}B%{$FG[240]%}U%{$FG[239]%}N%{$FG[238]%}T%{$FG[237]%}U %{$FG[031]%}%n%f@%M: %B%~%b $(bureau_git_prompt) [%{$FG[248]%}%w %*%f] %{$FG[214]%}   $(cmd_exec_time)%f
%(?.%{$FG[242]%}>%{$FG[241]%}>%{$FG[239]%}>%{$FG[238]%}>%{$FG[237]%}>%{$FG[236]%}>%f.%{$FG[196]%}>%{$FG[202]%}>%{$FG[208]%}>%{$FG[214]%}>%{$FG[220]%}>%{$FG[226]%}>%f'
#PROMPT='%{$FG[202]%}$(cmd_print_host) %{$FG[242]%}U%{$FG[241]%}B%{$FG[240]%}U%{$FG[239]%}N%{$FG[238]%}T%{$FG[237]%}U %{$FG[031]%}%n%f@%M: %{$FG[255]%}%~%f $(git_prompt_info) [%{$FG[248]%}%w %*%f] %{$FG[214]%}   $(cmd_exec_time)%f
#%(?.%{$FG[242]%}>%{$FG[241]%}>%{$FG[239]%}>%{$FG[238]%}>%{$FG[237]%}>%{$FG[236]%}>%{$FG[235]%}>%f.%{$FG[196]%}>%{$FG[197]%}>%{$FG[198]%}>%{$FG[199]%}>%{$FG[200]%}>%{$FG[201]%}>%f'
#PROMPT='%{$FG[202]%}$(cmd_print_host) %{$FG[242]%}U%{$FG[241]%}B%{$FG[240]%}U%{$FG[239]%}N%{$FG[238]%}T%{$FG[237]%}U %{$FG[031]%}%n%f@%M: %{$FG[255]%}%~%f $(git_prompt_info) [%{$FG[248]%}%w %*%f] %{$FG[214]%}   $(cmd_exec_time)%f
#%(?.%{$FG[242]%}>%{$FG[241]%}>%{$FG[239]%}>%{$FG[238]%}>%{$FG[237]%}>%{$FG[236]%}>%{$FG[235]%}>%f.%{$FG[196]%}%{$FG[197]%}%{$FG[198]%}%{$FG[199]%}%{$FG[200]%}%{$FG[201]%}%f'
#PROMPT='%{$FG[202]%} %{$FG[242]%}U%{$FG[241]%}B%{$FG[240]%}U%{$FG[239]%}N%{$FG[238]%}T%{$FG[237]%}U %{$FG[031]%}%n%f@%M: %{$FG[255]%}%~%f $(git_prompt_info) [%{$FG[248]%}%w %*%f] %{$FG[214]%}   $(cmd_exec_time)%f
#%(?.%{$FG[242]%}>%{$FG[241]%}>%{$FG[239]%}>%{$FG[238]%}>%{$FG[237]%}>%{$FG[236]%}>%{$FG[235]%}>%f.%{$FG[196]%}>%{$FG[197]%}>%{$FG[198]%}>%{$FG[199]%}>%{$FG[200]%}>%{$FG[201]%}>%f'
#PROMPT="%(?.%F{magenta}.%F{red})❯%f " # Display a red prompt char on failure
#RPROMPT="%F{8}${SSH_TTY:+%n@%m}%f"    # Display username if connected via SSH

# ------------------------------------------------------------------------------
#
# List of vcs_info format strings:
#
# %b => current branch
# %a => current action (rebase/merge)
# %s => current version control system
# %r => name of the root directory of the repository
# %S => current path relative to the repository root directory
# %m => in case of Git, show information about stashes
# %u => show unstaged changes in the repository
# %c => show staged changes in the repository
#
# List of prompt format strings:
#
# prompt:
# %F => color dict
# %f => reset color
# %~ => current path
# %* => time
# %n => username
# %m => shortname host
# %(?..) => prompt conditional - %(condition.true.false)
#
#  %B - %b bold start to end
#  %U - %u underline start to end
#  $fg_bold[color]
#
# ------------------------------------------------------------------------------
