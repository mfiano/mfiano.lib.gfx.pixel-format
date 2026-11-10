(in-package #:mfiano.lib.base.pkg)

(define-package #:mfiano.lib.gfx.pixel-format/test
  (:local-nicknames
   (#:pf #:mfiano.lib.gfx.pixel-format))
  (:use #:mfiano.lib.base.util #:1am))

(in-package #:mfiano.lib.gfx.pixel-format/test)

(defun pixel-formats ()
  (let ((formats nil))
    (do-symbols (symbol '#:mfiano.lib.gfx.pixel-format formats)
      (when (typep symbol 'pf:pixel-format)
        (pushnew symbol formats)))))

(defun codec-exports ()
  (let ((codecs nil))
    (do-external-symbols (symbol '#:mfiano.lib.gfx.pixel-format codecs)
      (let ((name (symbol-name symbol)))
        (when (or (eql 0 (search "ENCODE" name))
                  (eql 0 (search "DECODE" name)))
          (push symbol codecs))))))

(defun exported? (name)
  (eq (nth-value 1 (find-symbol name '#:mfiano.lib.gfx.pixel-format)) :external))

(defun exported-function? (name)
  (and (exported? name)
       (fboundp (find-symbol name '#:mfiano.lib.gfx.pixel-format))))

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
