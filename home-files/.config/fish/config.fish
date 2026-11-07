set -gx GUIX_PROFILE ~/.guix-home/profile
fish_add_path "$GUIX_PROFILE/bin"
set -gax XDG_DATA_DIRS $GUIX_PROFILE/share
set -gx GUIX_LOCPATH $GUIX_PROFILE/lib/locale

set -gax XCURSOR_PATH $HOME/.local/share/icons

function fish_greeting
    fastfetch
end

if status is-login && test (tty) = /dev/tty1
    set -gx GNOME_KEYRING_CONTROL $XDG_RUNTIME_DIR/keyring
    set -gx SSH_AUTH_SOCK $XDG_RUNTIME_DIR/keyring/ssh
    exec dbus-run-session niri --session
end

if status is-interactive
    # easier navigation
    alias .. 'cd ..'
    alias ... 'cd ../..'
    alias .... 'cd ../../..'
    alias ..... 'cd ../../../..'
    alias ...... 'cd ../../../../..'

    alias ip 'ip -color' # more color!

    if type -q direnv
        direnv hook fish | source
    end

    if type -q starship
        starship init fish | source
    end
end
