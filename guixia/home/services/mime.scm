(define-module (guixia home services mime)
  #:use-module (gnu home services)
  #:use-module (guix gexp)
  #:export (mime-defaults-service))

(define mime-defaults-service
  (simple-service 'mime-defaults home-xdg-configuration-files-service-type
                  `(("mimeapps.list" ,(local-file
                                       "../../../files/mimeapps.list")))))
