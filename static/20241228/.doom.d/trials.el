(defun +popup-set-modeline-on-enable-h ()
  "Don't show modeline in popup windows without a `modeline' window-parameter.
Possible values for this parameter are:

  t            show the mode-line as normal
  nil          hide the modeline entirely (the default)
  a function   `mode-line-format' is set to its return value

Any non-nil value besides the above will be used as the raw value for
`mode-line-format'."
  (when (bound-and-true-p +popup-buffer-mode)
    (let ((modeline (+popup-parameter 'modeline (get-buffer-window (current-buffer)))))
      (message "(selected-window) %s" (selected-window))
      (message "(buffer-name) %s" (buffer-name))
      (cond ((eq modeline 't)
             (message "modeline 't"))
            ((null modeline)
             (message "null modeline")
             ;; TODO use `mode-line-format' window parameter instead (emacs 26+)
             (hide-mode-line-mode +1))
            (
             (message "functionp modeline")
             (let ((hide-mode-line-format
                    (if (functionp modeline)
                        (funcall modeline)
                      modeline)))
               (hide-mode-line-mode +1)))))))
