#lang racket/gui

;; SIMPLE DELTA-V CALCULATOR
;; this program uses the Tsiolkovsky Rocket Equation to calculate
;; the delta-v (Δv) of a rocket system.

;; This file provides the GUI functionality for the calculator

;; DEPENDENCIES
(require "dv-lib.rkt")

;; CONSTANTS

(define window-height 300)
(define window-width 200)
(define window-label "Δv")

(define m0-label "m0: ")
(define m0-init "Initial Mass")

(define mf-label "mf: ")
(define mf-init "Dry Mass")

(define ve-label "ve: ")
(define ve-init "Exhaust Velocity")

(define Δv-label "Δv: ")
(define Δv-init "Delta-V")

(define tf-width 80)

(define calc-label "Compute")

(define computed-color (make-object color% 240 50 50))

;; FUNCTIONS

;; The callback for calculating. Gets the numbers in the text fields
;; and determines the proper function to call

(define (calc-cb button event)
  ;; We need to determine which of the text fields have numbers in them
  (define m0 (string->number (send m0-field get-value)))
  (define mf (string->number (send mf-field get-value)))
  (define ve (string->number (send ve-field get-value)))
  (define Δv (string->number (send Δv-field get-value)))
  (cond
    ;; Given all three unknowns in the Rocket Equation, calculate Δv
    [(and m0 mf ve)
     (define the-ans (number->string (delta-v m0 mf ve)))
     (update-field Δv-field the-ans)]
    ;; Given the mass Ratio and Δv, calculate the exhaust velocity
    [(and m0 mf Δv)
     (define the-ans (number->string (ex-vel Δv m0 mf)))
     (update-field ve-field the-ans)]
    ;; Given the Δv and ve, calculate the needed mass ratio
    ;; assume mf to be 1
    [(and Δv ve)
     (define the-ans (number->string (mr Δv ve)))
     (update-field mf-field "1")
     (update-field m0-field the-ans)]
    [else void]))

;; TextField String -> Void
;; Updates the given field with a computed value and changes its
;; background color

(define (update-field field val)
  (send field set-field-background computed-color)
  (send field set-value val))

;; TextField ControlEvent -> Void
;; Resets the color of the text field to the default

(define (reset-color text-field event)
  (send text-field set-field-background default-textfield-backg))


;; WINDOW ELEMENTS

;; Main window frame
(define the-frame (new frame%
                       [width window-width]
                       [height window-height]
                       [label window-label]
                       [alignment '(left top)]))

;; Panel to hold the text fields and their corresponding buttons
;; This is a 3x2 grid

(define values-rows (new vertical-panel%
                         [parent the-frame]
                         [stretchable-width #f]
                         [min-width 200]
                         [stretchable-height #f]))

;; Text fields to enter the necessary numbers
(define m0-field (new text-field%
                      [label m0-label]
                      [parent values-rows]
                      [init-value m0-init]
                      [callback reset-color]))

(define mf-field (new text-field%
                      [label mf-label]
                      [parent values-rows]
                      [init-value mf-init]
                      [callback reset-color]))

(define ve-field (new text-field%
                      [label ve-label]
                      [parent values-rows]
                      [init-value ve-init]
                      [callback reset-color]))

(define Δv-field (new text-field%
                      [label Δv-label]
                      [parent values-rows]
                      [init-value Δv-init]
                      [callback reset-color]))

;; Button to calculate the values:
(define calc-button (new button%
                         [label calc-label]
                         [parent values-rows]
                         [callback calc-cb]))

(define default-textfield-backg (send ve-field get-field-background))
                      

;; Shows the frame
(send the-frame show #t)

