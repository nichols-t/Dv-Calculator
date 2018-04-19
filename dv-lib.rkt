#lang racket

;; SIMPLE DELTA-V CALCULATOR
;; this program uses the Tsiolkovsky Rocket Equation to calculate
;; the delta-v (Δv) of a rocket system.

;; This file provides the backend functionality needed to do the
;; computation.

;; PROVIDED FUNCTIONS

(provide
 Δv
 (rename-out [Δv deltav]
             [Δv delta-v])
 ve
 (rename-out [ve exhaust-velocity]
             [ve ex-vel])
 mr
 (rename-out [mr mass-ratio]))

;; DEPENDENCIES

(module+ test
  (require rackunit))

;; FUNCTIONS

;; R+ R+ R+ -> R+
;; Calculates the Δv of a rocket system with total mass m0, dry mass
;; mf, and exhaust velocity ve. The function assumes you have kept
;; consistent units.

(define (Δv m0 mf ve)
  (if (not (equal? mf 0))
      (* ve (log (/ m0 mf)))
      (raise-arguments-error 'Δv "Dry mass must not be zero")))

(module+ test
  ;; Can't test a ton with this but it's a trivial function
  (check-equal? (Δv 10 10 300) 0))

;; R+ R+ R+ -> R+
;; Calculates the exhaust velocity needed to reach the given Δv
;; given m0 and mf

(define (ve Δv m0 mf)
  (define mass-ratio (log (/ m0 mf)))
  (if (not (equal? mass-ratio 0))
      (/ Δv mass-ratio)
      (raise-arguments-error 've "Dry and Wet mass cannot be equal"
                             "m0" m0
                             "mf" mf)))

;; R+ R+ R+ -> R+
;; Calculates the needed mass ratio given an exhaust velocity and
;; a target Δv

(define (mr Δv ve)
  (if (not (equal? ve 0))
      (exp (/ Δv ve))
      (raise-arguments-error 'mr "Exhaust velocity cannot be 0")))