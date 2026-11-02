(define-module (guixia home packages audio)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages audio)
  #:export (audio))

(define audio
  (list pipewire wireplumber))
