(define-module (guixia home packages desktop)
  #:use-module (gnu packages qt)
  #:use-module (gnu packages polkit)
  #:use-module (gnu packages window-management)
  #:use-module (gnu packages terminals)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages gnome)
  #:export (desktop))

(define desktop
  (list niri
        polkit-gnome
        awww
        waybar
        swayidle
        mako
        alacritty
        fuzzel
        cliphist
        bemoji
        nautilus
        seahorse
        hicolor-icon-theme))
