(define-module (guixia home packages desktop)
  #:use-module (gnu packages qt)
  #:use-module (gnu packages polkit)
  #:use-module (gnu packages window-management)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages terminals)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages fonts)
  #:export (desktop))

(define desktop
  (list niri
        xwayland-satellite
        polkit-gnome
        awww
        waybar
        swayidle
        mako
        alacritty
        fuzzel
        cliphist
        wtype
        wl-clipboard
        bemoji
        nautilus
        seahorse
        piper
        hicolor-icon-theme
        font-google-noto-emoji))
