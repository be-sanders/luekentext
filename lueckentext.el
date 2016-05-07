(require 'widget)

(setq my-name "Brian")

(defun hello()
  (insert "In einem groß[en] Haus lebten eine grau[e] Katze und eine braun[e] Maus."))

(defun brian/check-widget-value (widget &rest ignore)
  "Provide visual feedback for WIDGET."
  (cond
   ((string= (widget-value widget) "?")
    ;; Asking for hint
    (message "%s" (widget-get widget :correct))
    (widget-value-set widget ""))
   ;; Use string-match to obey case-fold-search 
   ((string-match 
     (concat "^"
             (regexp-quote (widget-get widget :correct))
             "$")
     (widget-value widget))
    (message "Correct")
    ;;(goto-char (widget-field-start widget))
    ;;(goto-char (line-end-position))
    ;;(insert "?")
    ;;(widget-forward 1)
    )))

(defun brian/make-luekentext (&optional context)
  "Create fill-in quiz"
  (interactive)
  ;;  (with-current-buffer (get-buffer-create "*test3*")
  (switch-to-buffer-other-window "*test3*")
  (kill-all-local-variables)
  (let ((inhibit-read-only t))
    (erase-buffer))
  (remove-overlays)
  (hello)
  (goto-char (point-min))
  (while (re-search-forward "[\[]" nil t)
    (progn 
      (let (beg end answer)
        (setq beg (point))
        (re-search-forward "[\]]" nil 2)
        (setq end (- (point) 1))
        (setq answer (buffer-substring beg end))
        (goto-char beg)
        (delete-char (length answer))
        
        (widget-create 'editable-field
                       :size 7
                       :format "%v"
                       :correct answer
                       :notify 'brian/check-widget-value))))
  ;;        (widget-insert "\n"))
  (use-local-map widget-keymap)
  (widget-setup)
  (goto-char (point-min))
  (widget-forward 1)
  )


