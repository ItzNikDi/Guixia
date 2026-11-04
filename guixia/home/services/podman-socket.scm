(define-module (guixia home services podman-socket)
  #:use-module (gnu services)
  #:use-module (gnu home services shepherd)
  #:use-module (gnu packages containers)
  #:use-module (guix gexp)
  #:export (podman-socket-service))

(define podman-socket-service
  (simple-service 'podman-socket home-shepherd-service-type
                  (list (shepherd-service (provision '(podman-socket))
                                          (documentation
                                           "Rootless Podman API socket for my user.")
                                          (start #~(lambda ()
                                                     (let ((runtime-dir (getenv
                                                                         "XDG_RUNTIME_DIR")))
                                                       (unless runtime-dir
                                                         (error
                                                          "XDG_RUNTIME_DIR is not set"))
                                                       (let* ((podman-dir (string-append
                                                                           runtime-dir
                                                                           "/podman"))
                                                              (socket (string-append
                                                                       "unix://"
                                                                       podman-dir
                                                                       "/podman.sock")))
                                                         (unless (file-exists?
                                                                  podman-dir)
                                                           (mkdir podman-dir))
                                                         (chmod podman-dir
                                                                #o700)
                                                         ((make-forkexec-constructor
                                                           (list #$(file-append
                                                                    podman
                                                                    "/bin/podman")
                                                                 "system"
                                                                 "service"
                                                                 "--time=0"
                                                                 socket)))))))
                                          (stop #~(make-kill-destructor))))))
