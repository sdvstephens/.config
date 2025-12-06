function fish_greeting
    fastfetch
end
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

zoxide init fish | source

set -gx PATH /opt/homebrew/opt/openjdk@17 $PATH

# ============================================
# UNIFIED UNIVERSITY CLI SYSTEM
# Add to ~/.config/fish/config.fish
# ============================================

# Main unified command
function uni --description "Unified university command system"
    switch $argv[1]
        # Lecture management
        case lecture new-lecture lec
            if test (count $argv) -lt 2
                echo "Usage: uni lecture <course> [title]"
                return 1
            end
            python3 ~/university/scripts/advanced_lecture.py $argv[2..]

            # Compile master PDF
        case compile build master
            if test (count $argv) -lt 2
                echo "Usage: uni compile <course>"
                echo "Available courses:"
                ls -d ~/university/*/ | grep -v -E 'scripts|templates|planning|psets' | xargs -n1 basename
                return 1
            end
            python3 ~/university/scripts/compile_master.py $argv[2..]

            # Grade management
        case grade grades gpa
            python3 ~/university/scripts/grade_manager.py $argv[2..]

            # Search across all notes
        case search find grep
            if test (count $argv) -lt 2
                echo "Usage: uni search <keyword>"
                return 1
            end
            set keyword $argv[2..]
            cd ~/university
            echo "🔍 Searching for '$keyword'..."
            echo ""
            grep -r --include="*.tex" --color=always -n "$keyword" . | grep -v -E '\.aux|\.log|\.toc|preamble.tex' | head -30

            # Statistics dashboard
        case stats statistics dashboard
            cd ~/university
            echo "📊 University Statistics Dashboard"
            echo "===================================="
            echo ""

            # Count courses (exclude utility directories)
            set courses (ls -d */ 2>/dev/null | grep -v -E 'scripts|templates|planning|psets|figures' | wc -l | xargs)
            echo "📚 Courses: $courses"

            # Count lectures
            set total_lectures (find . -name 'lecture_*.tex' | wc -l | xargs)
            echo "📝 Total Lectures: $total_lectures"

            # Count figures
            set total_figs (find . -name '*.ipe' -o -name '*.pdf' -path '*/figures/*' | wc -l | xargs)
            echo "📐 Total Figures: $total_figs"

            # Lines of LaTeX
            set latex_lines (find . -name '*.tex' -not -path '*/.*' | xargs wc -l 2>/dev/null | tail -1 | awk '{print $1}')
            echo "📄 Lines of LaTeX: $latex_lines"

            # Git stats
            echo ""
            echo "📦 Git Status:"
            set changed (git status -s | wc -l | xargs)
            if test $changed -gt 0
                echo "  ⚠️  $changed uncommitted changes"
            else
                echo "  ✅ All changes committed"
            end

            # Recent commits
            echo ""
            echo "🕐 Recent Activity:"
            git log --oneline --date=short --pretty=format:"  %ad - %s" -5
            echo ""

            # Git save
        case save push commit
            save-uni $argv[2..]

            # Git status
        case status st
            cd ~/university
            echo "📁 University Repository Status"
            echo "================================"
            git status

            # List courses
        case list courses ls
            echo "Available Courses:"
            echo "=================="
            for dir in ~/university/*/
                set course (basename $dir)
                # Skip utility directories
                if not string match -q -r 'scripts|templates|planning|psets' $course
                    set lec_count (ls $dir/lecture_*.tex 2>/dev/null | wc -l | xargs)
                    if test $lec_count -gt 0
                        printf "  📚 %-30s (%2d lectures)\n" $course $lec_count
                    end
                end
            end

            # Clean auxiliary files
        case clean cleanup
            if test (count $argv) -lt 2
                echo "Usage: uni clean <course>"
                return 1
            end
            set course $argv[2]
            cd ~/university/$course
            rm -f *.aux *.log *.toc *.out *.synctex.gz *.bcf *.run.xml *.bbl *.blg 2>/dev/null
            echo "✅ Cleaned auxiliary files in $course"

            # Help
        case help -h --help
            echo "uni - Unified University Command System"
            echo ""
            echo "Usage: uni <command> [arguments]"
            echo ""
            echo "Commands:"
            echo "  lecture <course> <title>   Create new lecture"
            echo "  compile <course>           Compile master PDF"
            echo "  grade                      Manage grades"
            echo "  fig <name>                 Create/edit figure"
            echo "  search <keyword>           Search all notes"
            echo "  stats                      Show statistics dashboard"
            echo "  save [message]             Push to GitHub"
            echo "  status                     Show git status"
            echo "  list                       List all courses"
            echo "  clean <course>             Remove auxiliary files"
            echo ""
            echo "Examples:"
            echo "  uni lecture math55 'Group Theory'"
            echo "  uni compile math55"
            echo "  uni search 'symmetric group'"
            echo "  uni stats"
            echo "  uni save 'Added lecture 9'"

        case '*'
            echo "❌ Unknown command: $argv[1]"
            echo "Run 'uni help' for usage information"
    end
end

# Quick shortcuts (optional)
alias unil='uni lecture'
alias unic='uni compile'
alias unis='uni search'
alias unist='uni stats'

# Academic CLI
alias acad='python3 ~/university/scripts/academic_cli.py'
alias alec='python3 ~/university/scripts/advanced_lecture.py'

function cleanup --description "Clean course directory, use '.' for current"
    if test (count $argv) -eq 0
        acad course cleanup
    else if test "$argv[1]" = "."
        set course_name (basename (pwd))
        echo "Cleaning current directory: $course_name"
        acad course cleanup --name "$course_name"
    else
        acad course cleanup $argv
    end
end

function cleanup-dry --description "Preview cleanup, use '.' for current"
    if test (count $argv) -eq 0
        acad course cleanup --dry-run
    else if test "$argv[1]" = "."
        set course_name (basename (pwd))
        echo "Preview cleanup for: $course_name"
        acad course cleanup --name "$course_name" --dry-run
    else
        acad course cleanup --dry-run $argv
    end
end

# Already have save-uni from before, keep it!
# (Your existing save-uni function stays here)

# Emacs daemon aliases
alias e='env TERM=xterm-256color emacsclient -c --alternate-editor=""'
alias et='emacsclient -nw' # Open terminal client
alias ec='emacsclient -c' # Same as 'e'
alias ekill='emacsclient -e "(kill-emacs)"' # Stop daemon
# Emacs with Chemacs2
alias doom-emacs='emacs --with-profile doom'
alias vanilla-emacs='emacs --with-profile vanilla'
# Daemon management
alias edoom-start='emacs --with-profile doom --daemon'
alias edoom-stop='emacsclient -e "(kill-emacs)"'
alias edoom-restart='edoom-stop; and sleep 1; and edoom-start'
# Check if daemon is running
alias edoom-status='emacsclient -e "t" 2>/dev/null && echo "✓ Daemon running" || echo "✗ Daemon not running"'
# Doom CLI (keep this)
fish_add_path ~/.doom-emacs/bin

set -gx LIBGS "/opt/homebrew/lib/libgs.dylib"
# ============================================
# ACADEMIC WORKFLOW - Lecture Compilation
# ============================================

set -x THEFUCK_OVERRIDDEN_ALIASES 'gsed,git'
set -gx PATH $HOME/.elan/bin $PATH

# Master file compilation
function compile-lectures
    python3 ~/university/scripts/compile_master.py $argv
end

function compile-open
    python3 ~/university/scripts/compile_master.py $argv --open
end

# Abbreviations (expand as you type - even better!)
abbr -a cm compile-lectures
abbr -a co compile-open
abbr -a cl compile-lectures --list

# Save and push university notes to GitHub from anywhere
function save-uni --description "Commit and push ~/university to GitHub"
    set -l original_dir (pwd)
    cd ~/university

    git add -A

    # Use custom message if provided, otherwise auto-generate
    if test (count $argv) -gt 0
        git commit -m "$argv"
    else
        git commit -m "Auto-save: $(date '+%Y-%m-%d %H:%M')"
    end

    # Try main branch, fallback to master
    if git push origin main 2>/dev/null
        echo "✅ University notes pushed to GitHub (main)"
    else if git push origin master 2>/dev/null
        echo "✅ University notes pushed to GitHub (master)"
    else
        echo "❌ Push failed - check connection or branch name"
    end

    cd $original_dir
end
# D-Bus configuration for Zathura
# set -x DBUS_SESSION_BUS_ADDRESS "unix:path=$DBUS_LAUNCHD_SESSION_BUS_SOCKET"

fish_add_path --global --move --path /usr/local/texlive/2025/bin/universal-darwin
# fish_add_path --global --move --path /opt/local/bin /opt/local/sbin
