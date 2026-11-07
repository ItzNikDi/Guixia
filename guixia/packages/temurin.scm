(define-module (guixia packages temurin)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system gnu)
  #:use-module (gnu packages base)
  #:use-module (gnu packages elf)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages linux)
  #:use-module (guix gexp)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (srfi srfi-13)
  #:export (temurin-jdk-21 temurin-jdk-25))

(define (temurin-major-version version)
  (let ((dot (string-index version #\.)))
    (unless dot
      (error "Invalid Temurin version" version))
    (substring version 0 dot)))

(define (temurin-archive-version version)
  (string-map (lambda (char)
                (if (char=? char #\+) #\_ char)) version))

(define (temurin-url-version version)
  (let ((plus (string-index version #\+)))
    (if plus
        (string-append (substring version 0 plus) "%2B"
                       (substring version
                                  (+ plus 1))) version)))
(define (make-temurin version hash)
  (let* ((major (temurin-major-version version))
         (archive-version (temurin-archive-version version))
         (url-version (temurin-url-version version))
         (archive (string-append "OpenJDK" major "U-jdk_x64_linux_hotspot_"
                                 archive-version ".tar.gz")))
    (package
      (name (string-append "temurin-jdk-" major))
      (version version)
      (source
       (origin
         (method url-fetch)
         (uri (string-append "https://github.com/adoptium/temurin"
                             major
                             "-binaries/releases/download/jdk-"
                             url-version
                             "/"
                             archive))
         (sha256
          (base32 hash))))
      (build-system gnu-build-system)
      (arguments
       (list
        #:tests? #f
        #:phases
        #~(modify-phases %standard-phases
            (delete 'configure)
            (delete 'build)
            (delete 'check)

            (add-after 'unpack 'patch-elf
              (lambda* (#:key inputs #:allow-other-keys)
                (let* ((patchelf (search-input-file inputs "/bin/patchelf"))
                       (glibc #$(this-package-input "glibc"))
                       (glibc-lib (string-append glibc "/lib"))
                       (interpreter (string-append glibc-lib
                                                   "/ld-linux-x86-64.so.2"))
                       (lib-rpath (string-append "$ORIGIN:$ORIGIN/server:"
                                                 glibc-lib))
                       (bin-rpath (string-append
                                   "$ORIGIN/../lib:$ORIGIN/../lib/server:"
                                   glibc-lib))
                       (desktop-rpath (string-join (list lib-rpath
                                                         (string-append #$(this-package-input
                                                                           "libx11")
                                                          "/lib")
                                                         (string-append #$(this-package-input
                                                                           "libxext")
                                                          "/lib")
                                                         (string-append #$(this-package-input
                                                                           "libxi")
                                                          "/lib")
                                                         (string-append #$(this-package-input
                                                                           "libxrender")
                                                          "/lib")
                                                         (string-append #$(this-package-input
                                                                           "libxtst")
                                                          "/lib")
                                                         (string-append #$(this-package-input
                                                                           "alsa-lib")
                                                          "/lib")) ":"))
                       (desktop-libs '("lib/libjawt.so" "lib/libawt_xawt.so"
                                       "lib/libsplashscreen.so"
                                       "lib/libjsound.so")))

                  (for-each (lambda (file)
                              (invoke patchelf
                                      "--set-interpreter"
                                      interpreter
                                      "--set-rpath"
                                      bin-rpath
                                      file))
                            (find-files "bin" ".*"))

                  (for-each (lambda (file)
                              (when (file-exists? file)
                                (invoke patchelf
                                        "--set-interpreter"
                                        interpreter
                                        "--set-rpath"
                                        glibc-lib
                                        file)))
                            '("lib/jspawnhelper" "lib/jexec"))

                  (for-each (lambda (file)
                              (unless (member file desktop-libs)
                                (invoke patchelf "--set-rpath" lib-rpath file)))
                            (find-files "lib" "\\.so$"))

                  (for-each (lambda (file)
                              (when (file-exists? file)
                                (invoke patchelf "--set-rpath" desktop-rpath
                                        file))) desktop-libs))))

            (replace 'install
              (lambda* (#:key outputs #:allow-other-keys)
                (let ((out (assoc-ref outputs "out")))
                  (mkdir-p out)
                  (copy-recursively "." out)))))))
      (inputs (list glibc
                    libx11
                    libxext
                    libxi
                    libxrender
                    libxtst
                    alsa-lib))
      (native-inputs (list patchelf))
      (supported-systems '("x86_64-linux"))
      (home-page "https://adoptium.net/temurin")
      (synopsis "Eclipse Temurin JDK")
      (description "Eclipse Temurin OpenJDK distribution.")
      (license license:gpl2+))))

(define-public temurin-jdk-21
  (make-temurin "21.0.13+9"
                "073dsv3l19vy8jml3w0nw0sg5lx7hrsvjjgm1yvh4aashv7xbxfp"))

(define-public temurin-jdk-25
  (make-temurin "25.0.5+8"
                "1yypg2qxmswp1gd711j3pccb3y0g4ymcakl2dgpd0mwjhqljb638"))
