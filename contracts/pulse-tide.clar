;; PulseTide Smart Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-not-owner (err u100))
(define-constant err-no-event (err u101))
(define-constant err-already-voted (err u102))
(define-constant err-invalid-rating (err u103))
(define-constant err-event-inactive (err u104))
(define-constant err-invalid-timestamp (err u105))
(define-constant err-invalid-length (err u106))

;; Data Variables
(define-map events 
  { event-id: uint } 
  { 
    creator: principal,
    title: (string-ascii 64),
    description: (string-ascii 256),
    timestamp: uint,
    active: bool,
    total-ratings: uint,
    cumulative-score: uint,
    weighted-score: uint
  }
)

(define-map user-feedback 
  { event-id: uint, user: principal } 
  { rating: uint, timestamp: uint }
)

(define-data-var event-counter uint u0)

;; Private Functions
(define-private (validate-event-input (title (string-ascii 64)) (description (string-ascii 256)))
  (begin
    (asserts! (> (len title) u3) err-invalid-length)
    (asserts! (> (len description) u10) err-invalid-length)
    (ok true)
  )
)

(define-private (calculate-weighted-score (total-ratings uint) (cumulative-score uint))
  (let
    ((base-score (/ (* cumulative-score u100) (max total-ratings u1))))
    (if (< total-ratings u5)
      (/ (* base-score u80) u100)
      base-score
    )
  )
)

;; Public Functions
(define-public (create-event (title (string-ascii 64)) (description (string-ascii 256)))
  (let
    ((event-id (var-get event-counter)))
    (begin
      (try! (validate-event-input title description))
      (asserts! (is-eq tx-sender contract-owner) err-not-owner)
      (map-set events 
        { event-id: event-id }
        { 
          creator: tx-sender,
          title: title,
          description: description,
          timestamp: block-height,
          active: true,
          total-ratings: u0,
          cumulative-score: u0,
          weighted-score: u0
        }
      )
      (var-set event-counter (+ event-id u1))
      (ok event-id)
    )
  )
)

;; [Rest of the contract functions remain unchanged]

;; New Read-only Functions
(define-read-only (get-active-events)
  (filter active (map-to-list events))
)
