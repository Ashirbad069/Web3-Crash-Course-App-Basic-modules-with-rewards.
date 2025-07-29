(define-fungible-token reward-token)

;; Constants and errors
(define-constant contract-owner tx-sender)
(define-constant err-already-completed (err u100))
(define-constant err-not-owner (err u101))
(define-constant err-invalid-amount (err u102))

;; State: Track completed modules
(define-map completions principal bool)
(define-data-var total-rewards uint u0)

;; Public Function 1: Complete module and claim reward
(define-public (complete-module)
  (begin
    ;; Check if already completed
    (asserts! (is-none (map-get? completions tx-sender)) err-already-completed)

    ;; Mark as completed
    (map-set completions tx-sender true)

    ;; Mint reward token (fixed amount)
    (try! (ft-mint? reward-token u100 tx-sender))
    (var-set total-rewards (+ (var-get total-rewards) u100))

    (ok true)
  )
)

;; Public Function 2: Owner can mint and distribute extra tokens
(define-public (distribute-reward (recipient principal) (amount uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-not-owner)
    (asserts! (> amount u0) err-invalid-amount)
    (try! (ft-mint? reward-token amount recipient))
    (var-set total-rewards (+ (var-get total-rewards) amount))
    (ok true)
  )
)
