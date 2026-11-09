(in-package #:mfiano.lib.base.pkg)

(define-package #:mfiano.lib.gfx.pixel-format/test
  (:local-nicknames
   (#:pf #:mfiano.lib.gfx.pixel-format))
  (:use #:mfiano.lib.base.util #:1am))

(in-package #:mfiano.lib.gfx.pixel-format/test)

(defun load-as-fresh-image (form)
  (uiop:with-temporary-file (:pathname source :type "lisp")
    (with-open-file (out source :direction :output :if-exists :supersede)
      (let ((*package* (find-package '#:mfiano.lib.gfx.pixel-format/test)))
        (print '(in-package #:mfiano.lib.gfx.pixel-format/test) out)
        (print form out)))
    (uiop:with-temporary-file (:pathname fasl :type "fasl")
      (compile-file source :output-file fasl :verbose nil :print nil)
      (setf (symbol-plist (second form)) nil)
      (load fasl :verbose nil))))
