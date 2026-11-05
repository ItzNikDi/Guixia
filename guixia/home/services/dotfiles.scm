(define-module (guixia home services dotfiles)
  #:use-module (gnu services)
  #:use-module (gnu home services dotfiles)
  #:export (dotfiles-service))

(define dotfiles-service
  (service home-dotfiles-service-type
           (home-dotfiles-configuration
             (layout 'plain)
             (directories '("../../../home-files")))))
