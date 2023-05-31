#!/bin/bash

# Script for setting up RoVa Lab LUMI environment.
# WARNING: This script will replace your .bashrc file backing up the old .bashrc file as .bashrc_rovalumi_backup.
# Author: Ladislav Bartos
VERSION="0.3"

# Check if the user is allowed to access the project directory
function validate_project {
    local PROJECT_DIR="/project/project_$1"
    if cd "$PROJECT_DIR" >/dev/null 2>&1; then
        cd - >/dev/null 2>&1  # Return to the original directory
        return 0
    else
        echo "Warning: You don't have access to project_$1. Skipping..."
        return 1
    fi
}

# Prompt for shortcuts and create aliases
function create_aliases {
    local SHORTCUTS=()
    local ARGS=()
    local ALIAS_LINES=()

    for ARG in "$@"; do
        if validate_project "$ARG"; then
            read -p "Enter shortcut for project '$ARG': " SHORTCUT
            SHORTCUT="${SHORTCUT// /}"  # Remove whitespace

            if [[ -n "$SHORTCUT" ]]; then
                SHORTCUTS+=("$SHORTCUT")
                ARGS+=("$ARG")
                ALIAS_LINES+=("PROJECT_ID_$SHORTCUT=$ARG")
                ALIAS_LINES+=("alias set-install-$SHORTCUT='export EBU_USER_PREFIX=/project/project_$ARG/EasyBuild'")
                ALIAS_LINES+=("alias project-$SHORTCUT='cd /scratch/project_$ARG/\$USER'")
                ALIAS_LINES+=("alias main-$SHORTCUT='cd /project/project_$ARG'")
            fi
            
            # Create user directory in the project scratch
	    if [ ! -d /scratch/project_$ARG/$USER ]; then 
		mkdir /scratch/project_$ARG/$USER 2>/dev/null || echo "Error. Could not create user directory for project $ARG."
	    fi
        fi
        
        
        
    done

    # Append alias lines to .bashrc
    if [[ ${#ALIAS_LINES[@]} -gt 0 ]]; then
        printf "%s\n" "${ALIAS_LINES[@]}" >> $HOME/.bashrc
    fi

    # Print shortcuts for confirmation
    if [[ ${#SHORTCUTS[@]} -gt 0 ]]; then
        echo -e "\nShortcuts created:"
        for ((i = 0; i < ${#SHORTCUTS[@]}; i++)); do
            echo "Shortcut: ${SHORTCUTS[i]} --> Project: ${ARGS[i]}"
        done
    else
        echo "No valid shortcuts provided. Assuming this is intentional."
    fi
}

# Entry point
# Back-up .bashrc file and create a new one.
if [ -f $HOME/.bashrc ]; then mv $HOME/.bashrc $HOME/.bashrc_rovalumi_backup; fi
printf "# .bashrc file for RoVa Lab LUMI environment\n# Version $VERSION\n\n" > $HOME/.bashrc

create_aliases "$@"

# Create bin directory & set up loop_sub
printf "\nSetting up bin directory and PATH.\n"
if [ ! -d $HOME/bin ]; then mkdir $HOME/bin || exit 1; fi
printf "\n\nexport PATH=\"${HOME}/bin:\$PATH\"" >> $HOME/.bashrc

cp loop_sub $HOME/bin && chmod u+x $HOME/bin/loop_sub || exit 1

printf "\nSuccessfully set up RoVa Lab LUMI environment.\n\n"

source $HOME/.bashrc

