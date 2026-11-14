(define-module (guixia system services wireguard)
  #:use-module (gnu services)
  #:use-module (gnu services vpn)
  #:export (wireguard-service))

(define wireguard-service
  (service wireguard-service-type
    (wireguard-configuration
      (interface "wg0")
      (addresses '("10.10.0.1/24"))
      (port 51820)
      (private-key "/etc/wireguard/private.key")
      (peers
        (list
          (wireguard-peer
            (name "phone")
            (public-key "FaxjvBjt3cbL+Z/RNDDf/dBnEN9ZeY4sNtQT/WEwQF8=")
            (allowed-ips '("10.10.0.2/32"))))))))
