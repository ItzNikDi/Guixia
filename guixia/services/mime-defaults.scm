(define-module (guixia services mime-defaults)
  #:use-module (gnu home services)
  #:use-module (guix gexp)
  #:export (mime-defaults-service))

(define mime-defaults-service
  (simple-service 'mime-defaults home-files-service-type
                  (list (list ".config/mimeapps.list"
                              (local-file "/mimeapps.list")))))
