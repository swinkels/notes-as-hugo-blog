(use-modules (guix inferior) (guix channels)
             (srfi srfi-1))   ;for 'first'

(define channels
  (list (channel
         (name 'guix)
         (url "https://git.savannah.gnu.org/git/guix.git")
         (commit
          "aae61f54ff6acf5cc0e0355dc85babf29f625660"))))

(define inferior
  ;; An inferior representing the above revision.
  (inferior-for-channels channels))

(packages->manifest
 (list (first (lookup-inferior-packages inferior "emacs"))))
