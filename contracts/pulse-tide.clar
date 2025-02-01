;; PulseTide Smart Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-not-owner (err u100))
(define-constant err-no-event (err u101))
(define-constant err-already-voted (err u102))
(define-constant err-invalid-rating (err u103))

;; Data Variables
(define-map events 
  { event-id: uint } 
  { 
    creator: principal,
    title: (string-ascii 64),
    timestamp: uint,
    active: bool,
    total-ratings: uint,
    cumulative-score: uint
  }
)

(define-map user-feedback 
  { event-id: uint, user: principal } 
  { rating: uint, timestamp: uint }
)

(define-data-var event-counter uint u0)

;; Public Functions
(define-public (create-event (title (string-ascii 64)))
  (let
    ((event-id (var-get event-counter)))
    (begin
      (asserts! (is-eq tx-sender contract-owner) err-not-owner)
      (map-set events 
        { event-id: event-id }
        { 
          creator: tx-sender,
          title: title,
          timestamp: block-height,
          active: true,
          total-ratings: u0,
          cumulative-score: u0
        }
      )
      (var-set event-counter (+ event-id u1))
      (ok event-id)
    )
  )
)

(define-public (submit-feedback (event-id uint) (rating uint))
  (let
    ((event (unwrap! (map-get? events {event-id: event-id}) err-no-event)))
    (begin
      (asserts! (>= rating u1) err-invalid-rating)
      (asserts! (<= rating u5) err-invalid-rating)
      (asserts! 
        (is-none (map-get? user-feedback {event-id: event-id, user: tx-sender}))
        err-already-voted
      )
      (map-set user-feedback
        {event-id: event-id, user: tx-sender}
        {rating: rating, timestamp: block-height}
      )
      (map-set events
        {event-id: event-id}
        (merge event
          {
            total-ratings: (+ (get total-ratings event) u1),
            cumulative-score: (+ (get cumulative-score event) rating)
          }
        )
      )
      (ok true)
    )
  )
)

;; Read Only Functions
(define-read-only (get-event (event-id uint))
  (map-get? events {event-id: event-id})
)

(define-read-only (get-event-rating (event-id uint))
  (let
    ((event (unwrap! (map-get? events {event-id: event-id}) err-no-event)))
    (if (is-eq (get total-ratings event) u0)
      (ok u0)
      (ok (/ (get cumulative-score event) (get total-ratings event)))
    )
  )
)

(define-read-only (get-user-feedback (event-id uint) (user principal))
  (map-get? user-feedback {event-id: event-id, user: user})
)
