if type -q fnm
  fnm env --use-on-cd --shell fish | source
  set fnm_completions_file "$FISH_HOME/completions/fnm.fish"
  if not test -f "$fnm_completions_file"
    fnm completions --shell fish > "$fnm_completions_file"
  end
end
