(define-module (guixia packages browser)
  #:use-module (gnu packages librewolf)
  #:export (browser))

(define browser
  (list librewolf))
