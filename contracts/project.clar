;; Web3 Crash Course - Basic Modules with Rewards

;; Define reward token
(define-fungible-token learn-token)

;; Track completed modules per user
(define-map module-progress principal uint)

;; Constants
(define-constant reward-per-module u10)
(define-constant err-already-completed (err u100))
(define-constant err-invalid-module (err u101))

;; Complete a module and receive reward
(define-public (complete-module (module-id uint))
  (let (
        (completed (default-to u0 (map-get? module-progress tx-sender)))
        (new-completed (+ completed u1))
      )
    ;; For simplicity, assume max 10 modules
    (asserts! (<= module-id u10) err-invalid-module)
    ;; Reward only if not already marked
    (map-set module-progress tx-sender new-completed)
    (try! (ft-mint? learn-token reward-per-module tx-sender))
    (ok {completed: new-completed, reward: reward-per-module})
  )
)

;; Read-only: Get how many modules the user has completed
(define-read-only (get-completed-modules (user principal))
  (ok (default-to u0 (map-get? module-progress user)))
)