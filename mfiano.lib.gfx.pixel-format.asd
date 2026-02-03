(asdf:defsystem #:mfiano.lib.gfx.pixel-format
  :description "A small code-generated pixel format system"
  :author "Michael Fiano <michael.fiano@gmail.com>"
  :license "MIT"
  :homepage "https://github.com/mfiano/mfiano.lib.gfx.pixel-format"
  :encoding :utf-8
  :depends-on
  (#:mfiano.lib.base
   #:mfiano.lib.math.scalar)
  :in-order-to ((test-op (test-op #:mfiano.lib.gfx.pixel-format/test)))
  :pathname "src"
  :serial t
  :components
  ((:file "package")
   (:file "pixel-format")
   (:file "definitions")))

(asdf:defsystem #:mfiano.lib.gfx.pixel-format/test
  :description "Unit tests for mfiano.lib.gfx.pixel-format"
  :author "Michael Fiano <michael.fiano@gmail.com>"
  :license "MIT"
  :homepage "https://github.com/mfiano/mfiano.lib.gfx.pixel-format"
  :encoding :utf-8
  :depends-on
  (#:1am
   #:mfiano.lib.gfx.pixel-format)
  :perform (test-op (o c) (symbol-call '#:1am '#:run))
  :pathname "test"
  :serial t
  :components
  ((:file "test")))
