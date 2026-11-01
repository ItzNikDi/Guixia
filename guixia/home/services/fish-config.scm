(define-module (guixia home services fish-config)
  #:use-module (gnu home services)
  #:use-module (guix gexp)
  #:export (fish-config-service))

(define fish-config-service
  (simple-service 'fish-config-service
                  home-xdg-configuration-files-service-type
                  `(("fish/config.fish" ,(local-file
                                          "../../../files/config.fish")))))
