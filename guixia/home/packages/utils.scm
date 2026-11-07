(define-module (guixia home packages utils)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages shellutils)
  #:use-module (gnu packages admin)
  #:use-module (gnu packages gnome)
  #:export (utils))

(define utils
  (list git btop starship fastfetch-minimal direnv gvfs gnome-keyring))
