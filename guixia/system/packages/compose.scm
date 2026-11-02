(define-module (guixia system packages compose)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix build-system copy)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:export (docker-compose-v2))

(define docker-compose-v2
  (package
    (name "docker-compose-v2")
    (version "5.6.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/docker/compose/releases/download/v" version
             "/docker-compose-linux-x86_64"))
       (file-name (string-append "docker-compose-" version))
       (sha256
        (base32 "1h5qbl5im08rj53akhxlhf3ha67hz01m56cifbmcrlz66r17yws7"))))
    (build-system copy-build-system)
    (arguments
     (list
      #:strip-binaries? #f
      #:install-plan
      #~'(("docker-compose" "bin/")
          ("docker-compose" "lib/docker/cli-plugins/"))
      #:phases
      #~(modify-phases %standard-phases
          (replace 'unpack
            (lambda* (#:key source #:allow-other-keys)
              (copy-file source "docker-compose")
              (chmod "docker-compose" #o755))))))
    (supported-systems '("x86_64-linux"))
    (home-page "https://github.com/docker/compose")
    (synopsis "Compose v2 (prebuilt upstream binary)")
    (description "Docker Compose v2 as a standalone binary and CLI plugin.")
    (license license:asl2.0)))
