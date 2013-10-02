;;; -*- coding: utf-8; mode: emacs-lisp; -*-

(eval-when-compile (require 'cl))
(require 'helm)
(require 'skk-vars)
(require 'skk)
(require 'skk-azik)

(defvar helm-skk-rules-list
  (append
   skk-rom-kana-base-rule-list
   skk-rom-kana-rule-list
   skk-azik-additional-rom-kana-rule-list))

(defun helm-get-skk-rules-init ()
  (let ((get-rules
         (lambda ()
           (loop with sep = " "
                 with check-str = (lambda (obj)
                                    (if (stringp obj)
                                        obj
                                      ""))
                 with check = (lambda (list)
                                (loop for val in list
                                      if (stringp val)
                                      collect (funcall check-str val)
                                      else if (and (not (null val)) (consp val))
                                      collect (concat (cdr val) sep (car val))))
                 for l in helm-skk-rules-list
                 for pair = (list (nth 0 l) (nth 1 l) (nth 2 l))
                 collect (mapconcat 'identity (funcall check pair) sep)))))
    (unless (helm-candidate-buffer)
      (helm-init-candidates-in-buffer
       'global
       (funcall get-rules)))))

(defvar helm-skk-rules-sources
  '((name . "helm-skk-rules")
    (init . helm-get-skk-rules-init)
    (candidates-in-buffer)
    (delayed)))

(defun helm-skk-rules ()
  (interactive)
  (helm :sources helm-skk-rules-sources
        :prompt "skk-rules: "
        :buffer "*helm skk rules"))

(provide 'helm-skk-rules)
