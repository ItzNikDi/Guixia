(define-module (guixia home packages portals)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages gnome)
  #:export (portals-packages))

(define portals-packages
  (list xdg-utils xdg-desktop-portal xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome))
