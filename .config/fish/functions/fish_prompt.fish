function fish_prompt --description 'Write out the prompt'
    set -l last_pipestatus $pipestatus
    set -l normal (set_color normal)

    # Color the prompt differently when we're root
    set -l color_cwd $fish_color_cwd
    set -l suffix ' » '
    if contains -- $USER root toor
        if set -q fish_color_cwd_root
            set color_cwd $fish_color_cwd_root
        end
        set suffix ' # '
    end

    # If we're running via SSH, change the host color.
    set -l color_host $fish_color_host
    if set -q SSH_TTY
        set color_host $fish_color_host_remote
    end

    # Show cwd and git status
    echo -n -s (set_color $color_cwd) (prompt_pwd) $normal (fish_vcs_prompt) $normal

    # Show suffix with color based on vi mode
    switch $fish_bind_mode
        case default
            set_color --bold red
        case insert
            set_color --bold green
        case replace_one
            set_color --bold green
        case visual
            set_color --bold magenta
        case '*'
            set_color --bold red
    end
    echo -n -s $suffix
end
