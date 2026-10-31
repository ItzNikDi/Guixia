(define-module (guixia packages av)
  #:use-module (gnu packages window-management)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages audio)
  #:export (av))

(define av
  (list kanshi pipewire wireplumber))
