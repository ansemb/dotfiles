function nvm
    if not test -f ~/.nvm/nvm.sh
        return
    end

    bass source ~/.nvm/nvm.sh --no-use ';' nvm $argv
end
