fastfetch
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /opt/homebrew/Caskroom/miniconda/base/bin/conda
    eval /opt/homebrew/Caskroom/miniconda/base/bin/conda "shell.fish" hook $argv | source
else
    if test -f "/opt/homebrew/Caskroom/miniconda/base/etc/fish/conf.d/conda.fish"
        . "/opt/homebrew/Caskroom/miniconda/base/etc/fish/conf.d/conda.fish"
    else
        set -x PATH /opt/homebrew/Caskroom/miniconda/base/bin $PATH
    end
end
# <<< conda initialize <<<

set --global --export HOMEBREW_PREFIX /opt/homebrew
set --global --export HOMEBREW_CELLAR /opt/homebrew/Cellar
set --global --export HOMEBREW_REPOSITORY /opt/homebrew
fish_add_path --global --move --path /opt/homebrew/bin /opt/homebrew/sbin
if test -n "$MANPATH[1]"
    set --global --export MANPATH '' $MANPATH
end
if not contains /opt/homebrew/share/info $INFOPATH
    set --global --export INFOPATH /opt/homebrew/share/info $INFOPATH
end
alias python=python3
alias nv=nvim
alias python=python3
alias nv=nvim

# Course Management Functions
function courses
    cd ~/university && ls -d */
end

function current
    readlink -f ~/current-course
end

function cc
    cd (readlink -f ~/current-course)
end

# Quick course switching (we'll need fzf for this)
function cs
    set course (find ~/university -maxdepth 1 -type d -not -path '*/.*' | sed 's|.*/||' | sort | fzf --height 40% --prompt "Course: ")
    if test -n "$course"
        ln -sfn ~/university/"$course" ~/current-course
        echo "Current course set to: $course"
        cd ~/current-course
    end
end
