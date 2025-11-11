# This is a script that switches to the previous workspace
# when attempting to switch to the current one
# Make sure jq is installed before running the script
#!/bin/bash

CURRENT_WORKSPACE_FILE="/tmp/current_workspace.txt"

previous_workspace=$(cat $CURRENT_WORKSPACE_FILE)

target_workspace="$1"

active_workspace=$(hyprctl activeworkspace -j | jq '.id')

# 99 is used to represent the tab key
if [[ "$target_workspace" == "$active_workspace" || "$target_workspace" == "99" ]] 
then 
  hyprctl dispatch workspace "$previous_workspace"
else
  hyprctl dispatch workspace "$target_workspace"
fi

echo "$active_workspace" > $CURRENT_WORKSPACE_FILE
