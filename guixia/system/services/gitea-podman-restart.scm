(define-module (guixia system services gitea-podman-restart)
  #:use-module (gnu services)
  #:use-module (gnu services shepherd)
  #:use-module (gnu packages containers)
  #:use-module (guix gexp)
  #:export (gitea-podman-restart-service))

(define gitea-podman-restart-service
  (simple-service 'gitea-podman-restart shepherd-root-service-type
                  (list (shepherd-service (provision '(gitea-podman-restart))
                                          (requirement '(gitea-podman
                                                         networking))
                                          (documentation
                                           "Start rootless Podman containers flagged as 'should-start-on-boot'.")
                                          (start #~(lambda _
                                                     (let ((pid (fork+exec-command
                                                                 (list #$(file-append
                                                                          podman
                                                                          "/bin/podman")
                                                                  "--log-level=info"
                                                                  "start"
                                                                  "--all"
                                                                  "--filter"
                                                                  "should-start-on-boot=true")
                                                                 #:user
                                                                 "gitea"
                                                                 #:group
                                                                 "gitea"
                                                                 #:directory
                                                                 "/home/gitea"
                                                                 #:environment-variables
                                                                 (list
                                                                  "HOME=/home/gitea"
                                                                  "XDG_RUNTIME_DIR=/run/gitea"
                                                                  "PATH=/run/setuid-programs:/run/current-system/profile/bin")
                                                                 #:log-file
                                                                 "/var/log/gitea-podman-restart.log")))
                                                       (zero? (cdr (waitpid
                                                                    pid))))))
                                          (stop #~(lambda _
                                                    (let ((pid (fork+exec-command
                                                                (list #$(file-append
                                                                         podman
                                                                         "/bin/podman")
                                                                 "--log-level=info"
                                                                 "stop"
                                                                 "--service"
                                                                 "--all")
                                                                #:user "gitea"
                                                                #:group
                                                                "gitea"
                                                                #:directory
                                                                "/home/gitea"
                                                                #:environment-variables
                                                                (list
                                                                 "HOME=/home/gitea"
                                                                 "XDG_RUNTIME_DIR=/run/gitea"
                                                                 "PATH=/run/setuid-programs:/run/current-system/profile/bin")
                                                                #:log-file
                                                                "/var/log/gitea-podman-restart.log")))
                                                      (waitpid pid) #f)))))))
