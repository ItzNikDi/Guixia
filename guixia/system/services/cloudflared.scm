(define-module (guixia system services cloudflared)
  #:use-module (gnu services)
  #:use-module (gnu services base)
  #:use-module (gnu services shepherd)
  #:use-module (gnu system accounts)
  #:use-module (gnu system shadow)
  #:use-module (gnu packages admin)
  #:use-module (guix gexp)
  #:use-module (guixia packages cloudflared)
  #:export (cloudflared-services))

(define cloudflared-services
  (list (simple-service 'cloudflared-account account-service-type
                        (list (user-group
                                (name "cloudflared")
                                (system? #t))
                              (user-account
                                (name "cloudflared")
                                (group "cloudflared")
                                (system? #t)
                                (comment "Cloudflare Tunnel")
                                (home-directory "/var/lib/cloudflared")
                                (shell (file-append shadow "/sbin/nologin")))))

        (simple-service 'cloudflared shepherd-root-service-type
                        (list (shepherd-service (provision '(cloudflared))
                                                (requirement '(networking))
                                                (documentation
                                                 "Cloudflare tunnel")
                                                (start #~(make-forkexec-constructor
                                                          (list #$(file-append
                                                                   cloudflared
                                                                   "/bin/cloudflared")
                                                           "--no-autoupdate"
                                                           "tunnel"
                                                           "run"
                                                           "--token-file"
                                                           "/var/lib/cloudflared/token")
                                                          #:user "cloudflared"
                                                          #:group
                                                          "cloudflared"
                                                          #:environment-variables
                                                          (list
                                                           "HOME=/var/lib/cloudflared"
                                                           "SSL_CERT_FILE=/run/current-system/profile/etc/ssl/certs/ca-certificates.crt")
                                                          #:log-file
                                                          "/var/log/cloudflared.log"))
                                                (stop #~(make-kill-destructor)))))))
