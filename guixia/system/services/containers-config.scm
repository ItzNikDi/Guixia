(define-module (guixia system services containers-config)
  #:use-module (gnu services)
  #:use-module (guix gexp)
  #:export (containers-config-service))

(define containers-config-service
  (simple-service 'containers-config etc-service-type
                  `(("containers/containers.conf" ,(local-file
                                                    "../../../files/containers.conf")))))
