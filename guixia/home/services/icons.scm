(define-module (guixia home services icons)
  #:use-module (gnu home services)
  #:use-module (guix gexp)
  #:export (icons-services))

(define icons-services
  (list (simple-service 'qogir-icons home-xdg-data-files-service-type
                        `(("icons/Qogir-Manjaro" ,(local-file
                                                   "../../../files/.local/share/icons/Qogir-Manjaro"
                                                   #:recursive? #t))))
        (simple-service 'gtk-default-icons
                        home-xdg-configuration-files-service-type
                        `(("gtk-3.0/settings.ini" ,(local-file
                                                    "../../../files/.config/gtk-3.0/settings.ini"))
                          ("gtk-4.0/settings.ini" ,(local-file
                                                    "../../../files/.config/gtk-4.0/settings.ini"))))))
