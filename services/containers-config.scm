(define-module (guixia services containers-config)
  #:use-module (gnu services)
  #:use-module (guix gexp)
  #:export (containers-config-service))

(define containers-config-service
  (simple-service 'containers-conf etc-service-type
                  (list `("containers/containers.conf" ,(local-file
                                                         "containers.conf")))))
