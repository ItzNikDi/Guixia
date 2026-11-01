set -gx GUIX_PROFILE ~/.guix-home/profile
fish_add_path "$GUIX_PROFILE/bin"
set -gax XDG_DATA_DIRS $GUIX_PROFILE/share
set -gx GUIX_LOCPATH $GUIX_PROFILE/lib/locale

function fish_greeting
    fastfetch
end

if status is-login && test (tty) = /dev/tty1
    set -gx GNOME_KEYRING_CONTROL $XDG_RUNTIME_DIR/keyring
    set -gx SSH_AUTH_SOCK $XDG_RUNTIME_DIR/keyring/ssh
    exec dbus-run-session niri
end
