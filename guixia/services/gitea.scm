(define-module (guixia services gitea)
  #:use-module (gnu services)
  #:use-module (gnu services shepherd)
  #:use-module (guix gexp)
  #:use-module (guixia packages compose)
  #:export (gitea-service))

(define gitea-service
  (simple-service 'gitea shepherd-root-service-type
                  (list (shepherd-service (provision '(gitea))
                                          (requirement '(gitea-podman
                                                         networking))
                                          (documentation
                                           "Gitea (compose project).")
                                          (start #~(make-forkexec-constructor (list #$
                                                                               (file-append
                                                                                docker-compose-v2
                                                                                "/bin/docker-compose")
                                                                               "up"
                                                                               "--remove-orphans")
                                                    #:user "gitea"
                                                    #:group "gitea"
                                                    #:directory
                                                    "/home/gitea/gitea"
                                                    #:environment-variables (list
                                                                             "HOME=/home/gitea"
                                                                             "XDG_RUNTIME_DIR=/run/gitea"
                                                                             "DOCKER_HOST=unix:///run/gitea/podman/podman.sock"
                                                                             "PATH=/run/setuid-programs:/run/current-system/profile/bin")
                                                    #:log-file
                                                    "/var/log/gitea.log"))
                                          (stop #~(make-kill-destructor))))))
