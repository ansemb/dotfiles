if type -q fnm
  fnm env --use-on-cd --shell fish | source
  fnm completions --shell fish
end
