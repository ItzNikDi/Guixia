(define-module (guixia system packages xerox-workcentre)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix build-system copy)
  #:use-module (guix licenses)
  #:use-module (gnu packages base)
  #:use-module (gnu packages cups)
  #:use-module (gnu packages elf)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages libusb)
  #:export (xerox-workcentre-3025))

(define xerox-workcentre-3025
  (package
    (name "xerox-workcentre-3025")
    (version "1.0.0") ;idfk
    (source
     (origin
       (method url-fetch)
       (uri
        "https://web.archive.org/web/20260207213159/https://download.support.xerox.com/pub/drivers/3020/drivers/linux/en_GB/Xerox_Phaser_3020_Linux-Driver.tar.gz") ;if this ever goes down it's over
       (sha256
        (base32 "1d6mrpp7s660n0k25f5ikzjmj9xpr8vgymaszyq6lsjp1537p9x7"))))
    (build-system copy-build-system)
    (arguments
     (list
      #:install-plan
      #~'(("x86_64/rastertospl" "lib/cups/filter/")
          ("x86_64/pstosecps" "lib/cups/filter/")
          ("x86_64/libscmssc.so" "lib/")
          ("noarch/share/ppd/Xerox_WorkCentre_3025.ppd"
           "share/cups/model/xerox/"))
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'install 'patch-elf
            (lambda _
              (let* ((out #$output)
                     (libc #$(this-package-input "glibc"))
                     (rpath (string-join (list (string-append out "/lib")
                                               (string-append libc "/lib")
                                               (string-append #$gcc:lib "/lib")
                                               (string-append #$(this-package-input
                                                                 "cups")
                                                              "/lib")
                                               (string-append #$(this-package-input
                                                                 "libusb")
                                                              "/lib")) ":")))
                (for-each (lambda (f)
                            (invoke "patchelf"
                                    "--set-interpreter"
                                    (string-append libc
                                     "/lib/ld-linux-x86-64.so.2")
                                    "--set-rpath"
                                    rpath
                                    f))
                          (list (string-append out
                                               "/lib/cups/filter/rastertospl")
                                (string-append out
                                               "/lib/cups/filter/pstosecps")))
                (invoke "patchelf" "--set-rpath" rpath
                        (string-append out "/lib/libscmssc.so"))))))))
    (native-inputs (list patchelf))
    (inputs (list glibc
                  `(,gcc "lib") cups libusb))
    (supported-systems '("x86_64-linux"))
    (home-page "https://www.xerox.com")
    (synopsis "Xerox WorkCentre 3025 printer driver")
    (description
     "Prebuilt CUPS filters and library for the Xerox WorkCentre 3025.")
    (license (non-copyleft "https://www.xerox.com" "Proprietary vendor driver"))))
