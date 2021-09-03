function fish_right_prompt
    set -l rc $status
    if test ! $rc -eq 0
        echo -n -s (set_color --bold $fish_color_status) $rc " ↵"
    end
end
