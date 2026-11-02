(define-module (guixia home services portals)
  #:use-module (gnu home services)
  #:use-module (guix gexp)
  #:export (portals-service))

(define portals-service
  (simple-service 'niri-portals-config
                  home-xdg-configuration-files-service-type
                  `(("xdg-desktop-portal/niri-portals.conf" ,(local-file
                                                              "../../../files/.config/xdg-desktop-portal/niri-portals.conf")))))
