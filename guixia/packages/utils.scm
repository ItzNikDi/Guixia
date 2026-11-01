(define-module (guixia packages utils)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages admin)
  #:use-module (gnu packages terminals)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages gnome)
  #:export (utils))

(define utils
  (list git
        btop
        fastfetch-minimal
        alacritty
        fuzzel
        nautilus
        gvfs
        gnome-keyring
        seahorse
        hicolor-icon-theme))
