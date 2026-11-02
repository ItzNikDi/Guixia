(define-module (guixia home services fuzzel-config)
  #:use-module (gnu home services)
  #:use-module (guix gexp)
  #:export (fuzzel-config-service))

(define fuzzel-config-service
  (simple-service 'fuzzel-config-service
                  home-xdg-configuration-files-service-type
                  `(("fuzzel/fuzzel.ini" ,(local-file
                                          "../../../files/.config/fuzzel/fuzzel.ini")))))
