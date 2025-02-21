
function __complete_mc
    set -lx COMP_LINE (commandline -cp)
    test -z (commandline -ct)
    and set COMP_LINE "$COMP_LINE "
    /nix/store/2bygnmmskfzdl83wiwj34d3552zl8369-minio-client-2024-11-21T17-21-54Z/bin/mc
end
complete -f -c mc -a "(__complete_mc)"

