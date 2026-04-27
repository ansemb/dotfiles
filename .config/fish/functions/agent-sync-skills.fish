function agent-sync-skills --description "Sync shared agent skills into agent-specific skill directories"
    set -l source "$HOME/.config/agents/skills"
    set -l targets "$HOME/.agent/skills" "$HOME/.claude/skills" "$HOME/.copilot/skills"

    if not test -d "$source"
        echo "Missing skills source: $source" >&2
        return 1
    end

    for target in $targets
        mkdir -p (dirname "$target")

        if test -L "$target"
            set -l current_target (readlink "$target")
            if test "$current_target" != "../.config/agents/skills" -a "$current_target" != "$source"
                rm "$target"
                ln -s ../.config/agents/skills "$target"
                echo "Updated $target -> ../.config/agents/skills"
            else
                echo "OK $target -> $current_target"
            end
        else if test -e "$target"
            for skill_dir in "$source"/*
                if test -f "$skill_dir/SKILL.md"
                    set -l skill_name (basename "$skill_dir")
                    set -l skill_link "$target/$skill_name"

                    if test -L "$skill_link"
                        rm "$skill_link"
                        ln -s "$skill_dir" "$skill_link"
                        echo "Updated $skill_link -> $skill_dir"
                    else if test -e "$skill_link"
                        echo "Skipped existing non-symlink: $skill_link" >&2
                    else
                        ln -s "$skill_dir" "$skill_link"
                        echo "Linked $skill_link -> $skill_dir"
                    end
                end
            end
        else
            ln -s ../.config/agents/skills "$target"
            echo "Linked $target -> ../.config/agents/skills"
        end
    end
end
