(define-module (guixia system services gitea-runner)
  #:use-module (gnu services)
  #:use-module (gnu services shepherd)
  #:use-module (guixia packages compose)
  #:use-module (guix gexp)
  #:export (gitea-runner-service))

(define gitea-runner-service
  (simple-service 'gitea-runner shepherd-root-service-type
                  (list (shepherd-service (provision '(gitea-runner))
                                          (requirement '(gitea-podman
                                                         networking))
                                          (documentation
                                           "Gitea Actions runner (compose project).")
                                          (start #~(make-forkexec-constructor (list #$
                                                                               (file-append
                                                                                docker-compose-v2
                                                                                "/bin/docker-compose")
                                                                               "up"
                                                                               "--remove-orphans")
                                                    #:user "gitea"
                                                    #:group "gitea"
                                                    #:directory
                                                    "/home/gitea/gitea_runner"
                                                    #:environment-variables (list
                                                                             "HOME=/home/gitea"
                                                                             "XDG_RUNTIME_DIR=/run/gitea"
                                                                             "DOCKER_HOST=unix:///run/gitea/podman/podman.sock"
                                                                             "PATH=/run/setuid-programs:/run/current-system/profile/bin")
                                                    #:log-file
                                                    "/var/log/gitea-runner.log"))
                                          (stop #~(make-kill-destructor))))))
