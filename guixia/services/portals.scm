(define-module (guixia services portals)
  #:use-module (gnu home services)
  #:use-module (gnu packages freedesktop)
  #:use-module (guix gexp)
  #:use-module (ice-9 ftw)
  #:export (portals-service portals-packages))

(define portals-packages
  (list xdg-utils xdg-desktop-portal xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr))

(define portals-service
  (simple-service 'labwc-portals-config home-files-service-type
                  (list (list ".config/xdg-desktop-portal/labwc-portals.conf"
                              (local-file (string-append (dirname (current-filename))
                                           "/labwc-portals.conf"))))))
