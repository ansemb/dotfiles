if type -q fnm
  fnm env --use-on-cd --shell fish | source
  set fnm_completions_file "$FISH_HOME/completions/fnm.fish"
  if not test -f "$fnm_completions_file"
    fnm completions --shell fish > "$fnm_completions_file"
  end
end

# fnm
set FNM_PATH "/opt/homebrew/opt/fnm/bin"
if [ -d "$FNM_PATH" ]
  fnm env | source
end
