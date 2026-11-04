(define-module (guixia home packages utils)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages admin)
  #:use-module (gnu packages gnome)
  #:export (utils))

(define utils
  (list git btop fastfetch-minimal gvfs gnome-keyring))
