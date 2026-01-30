(in-package #:mfiano.lib.base.pkg)

(define-package #:mfiano.lib.gfx.pixel-format/test
  (:local-nicknames
   (#:pf #:mfiano.lib.gfx.pixel-format))
  (:use #:mfiano.lib.base.util #:1am))

(in-package #:mfiano.lib.gfx.pixel-format/test)

(test pixel-format.rgba8888/u8
  (let ((dest (make-f64-array 4))
        (src (to-u8-array '(255 128 32 8)))
        (decoded #(1.0d0 0.5019607843137255d0 0.12549019607843137d0 0.03137254901960784d0)))
    (pf:decode-rgba8888/u8 src 0 dest 0 1)
    (pf:encode-rgba8888/u8 dest 0 src 0 1)
    (is (equalp src #(255 128 32 8)))
    (is (equalp dest decoded))))

(test pixel-format.rgba8888/u32
  (let ((dest (make-f64-array 4))
        (src (to-u32-array `(,(logior (ash 255 24) (ash 128 16) (ash 32 8) 8))))
        (decoded #(1.0d0 0.5019607843137255d0 0.12549019607843137d0 0.03137254901960784d0)))
    (pf:decode-rgba8888/u32 src 0 dest 0 1)
    (pf:encode-rgba8888/u32 dest 0 src 0 1)
    (is (equalp src #(4286586888)))
    (is (equalp dest decoded))))

(test pixel-format.abgr8888/u8
  (let ((dest (make-f64-array 4))
        (src (to-u8-array '(255 128 32 8)))
        (decoded #(0.03137254901960784d0 0.12549019607843137d0 0.5019607843137255d0 1.0d0)))
    (pf:decode-abgr8888/u8 src 0 dest 0 1)
    (pf:encode-abgr8888/u8 dest 0 src 0 1)
    (is (equalp src #(255 128 32 8)))
    (is (equalp dest decoded))))

(test pixel-format.abgr8888/u32
  (let ((dest (make-f64-array 4))
        (src (to-u32-array `(,(logior (ash 255 24) (ash 128 16) (ash 32 8) 8))))
        (decoded #(0.03137254901960784d0 0.12549019607843137d0 0.5019607843137255d0 1.0d0)))
    (pf:decode-abgr8888/u32 src 0 dest 0 1)
    (pf:encode-abgr8888/u32 dest 0 src 0 1)
    (is (equalp src #(4286586888)))
    (is (equalp dest decoded))))

(test pixel-format.rgb888/u8
  (let ((dest (make-f64-array 4))
        (src (to-u8-array '(255 128 32)))
        (decoded #(1.0d0 0.5019607843137255d0 0.12549019607843137d0 0.0d0)))
    (pf:decode-rgb888/u8 src 0 dest 0 1)
    (pf:encode-rgb888/u8 dest 0 src 0 1)
    (is (equalp src #(255 128 32)))
    (is (equalp dest decoded))))

(test pixel-format.bgr888/u8
  (let ((dest (make-f64-array 4))
        (src (to-u8-array '(255 128 32)))
        (decoded #(0.12549019607843137d0 0.5019607843137255d0 1.0d0 0.0d0)))
    (pf:decode-bgr888/u8 src 0 dest 0 1)
    (pf:encode-bgr888/u8 dest 0 src 0 1)
    (is (equalp src #(255 128 32)))
    (is (equalp dest decoded))))

(test pixel-format.ga1616/u16
  (let ((dest (make-f64-array 4))
        (src (to-u16-array '(65535 32768)))
        (decoded #(1.0d0 0.0d0 0.0d0 0.5000076295109483d0)))
    (pf:decode-ga1616/u16 src 0 dest 0 1)
    (pf:encode-ga1616/u16 dest 0 src 0 1)
    (is (equalp src #(65535 32768)))
    (is (equalp dest decoded))))

(test pixel-format.ga1616/u32
  (let ((dest (make-f64-array 4))
        (src (to-u32-array `(,(logior (ash 65535 16) 32768))))
        (decoded #(1.0d0 0.0d0 0.0d0 0.5000076295109483d0)))
    (pf:decode-ga1616/u32 src 0 dest 0 1)
    (pf:encode-ga1616/u32 dest 0 src 0 1)
    (is (equalp src #(4294934528)))
    (is (equalp dest decoded))))
