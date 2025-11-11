if status is-interactive; 

	alias e="exit"
	alias c="clear"
	alias tl="task list"

  alias muz="cd ~/Media/Music"
  alias vid="cd ~/Media/Videos"

  alias v="nvim"

	set fish_greeting
end

function td
    task $argv[1] done
end

function ta
    task add $argv[1]
end

fish_vi_key_bindings

function cdf
    set dir (fd --type d --hidden --follow --exclude .git 2>/dev/null | fzf +m)
    if test -n "$dir"
        cd $dir
    end
end

# fcitx5 environment variables
set -x GTK_IM_MODULE fcitx
set -x QT_IM_MODULE fcitx
set -x XMODIFIERS "@im=fcitx"

function copy_template
    if test (count $argv) -ne 1
        echo "Usage: copy_template <new_directory_name>"
        return 1
    end

    set new_dir $argv[1]
    set src_dir "/home/anon/Documents/Templates/Basic"
    
    if test -d $new_dir
        echo "Error: Directory '$new_dir' already exists."
        return 1
    end

    cp -r $src_dir $new_dir
    echo "Copied contents of $src_dir into $new_dir"
end

