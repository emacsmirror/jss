(require 'js2-mode)
(require 'deferred)

(defvar jss-super-mode-map
  (let ((map (make-sparse-keymap)))
    (set-keymap-parent map (make-composed-keymap button-buffer-map text-mode-map))
    map))

(define-derived-mode jss-super-mode text-mode "Generic JSS Mode"
  "Functionality common to all JSS modes."
  t)

(define-key jss-super-mode-map (kbd "RET") 'jss-invoke-default-action)

(defun jss-insert-button (label default-action &rest other-properties)
  (apply 'insert-text-button
         label
         'action (lambda (button)
                   (call-interactively 'jss-invoke-default-action))
         'jss-default-action default-action
         other-properties))

(defun jss-invoke-default-action ()
  (interactive)
  (let ((default-action (get-text-property (point) 'jss-default-action)))
    (unless default-action
      (warn "No default action at point."))
    (call-interactively default-action)))

(defun jss-log-event (event)
  (with-current-buffer (get-buffer-create " *jss-events*")
    (insert (format ";; %s\n" (format-time-string "%Y-%m-%dT%T")))
    (dolist (event-part event)
      (insert (prin1-to-string event-part) "\n"))
    (insert ";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;\n")))

(require 'jss-browser-api)
(require 'jss-browser-chrome)
(require 'jss-browser-firefox)
(require 'jss-browser-mode)
(require 'jss-console-mode)
(require 'jss-network-inspector)

(provide 'jss)
