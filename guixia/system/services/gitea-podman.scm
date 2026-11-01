(define-module (guixia system services gitea-podman)
  #:use-module (gnu services)
  #:use-module (gnu services shepherd)
  #:use-module (gnu packages containers)
  #:use-module (guix gexp)
  #:export (gitea-podman-service))

(define gitea-podman-service
  (simple-service 'gitea-podman shepherd-root-service-type
                  (list (shepherd-service (provision '(gitea-podman))
                                          (requirement '(user-processes
                                                         networking))
                                          (documentation
                                           "Rootless Podman API socket for the Gitea services.")
                                          (start #~(lambda _
                                                     (let* ((pw (getpwnam
                                                                 "gitea"))
                                                            (uid (passwd:uid
                                                                  pw))
                                                            (gid (passwd:gid
                                                                  pw)))
                                                       (for-each (lambda (d)
                                                                   (unless (file-exists?
                                                                            d)
                                                                     (mkdir d))
                                                                   (chown d
                                                                          uid
                                                                          gid)
                                                                   (chmod d
                                                                          #o700))
                                                                 '("/run/gitea"
                                                                   "/run/gitea/podman"))
                                                       ((make-forkexec-constructor
                                                         (list #$(file-append
                                                                  podman
                                                                  "/bin/podman")
                                                          "system" "service"
                                                          "--time=0"
                                                          "unix:///run/gitea/podman/podman.sock")
                                                         #:user "gitea"
                                                         #:group "gitea"
                                                         #:directory
                                                         "/home/gitea"
                                                         #:environment-variables
                                                         (list
                                                          "HOME=/home/gitea"
                                                          "XDG_RUNTIME_DIR=/run/gitea"
                                                          "PATH=/run/setuid-programs:/run/current-system/profile/bin")
                                                         #:log-file
                                                         "/var/log/gitea-podman.log")))))
                                          (stop #~(make-kill-destructor))))))
