(define-module (guixia packages cloudflared)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (guix download)
  #:use-module (guix build-system copy)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:export (cloudflared))

(define cloudflared
  (package
    (name "cloudflared")
    (version "2026.10.7")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/cloudflare/cloudflared/releases/download/"
             version "/cloudflared-linux-amd64"))
       (file-name (string-append "cloudflared-" version))
       (sha256
        (base32 "0whqz6wpm8abfp9a75b237k7fanqj74pq2l7inxc5pl3id8zp68z"))))
    (build-system copy-build-system)
    (arguments
     (list
      #:strip-binaries? #f
      #:install-plan
      #~'(("cloudflared" "bin/"))
      #:phases
      #~(modify-phases %standard-phases
          (replace 'unpack
            (lambda* (#:key source #:allow-other-keys)
              (copy-file source "cloudflared")
              (chmod "cloudflared" #o755))))))
    (supported-systems '("x86_64-linux"))
    (home-page "https://github.com/cloudflare/cloudflared")
    (synopsis "Cloudflare Tunnel client (prebuilt upstream binary)")
    (description "Cloudflare Tunnel client.")
    (license license:asl2.0)))
