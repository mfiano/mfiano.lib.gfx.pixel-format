(in-package #:mfiano.lib.base.pkg)

(define-package #:mfiano.lib.gfx.pixel-format/test
  (:local-nicknames
   (#:pf #:mfiano.lib.gfx.pixel-format))
  (:use #:mfiano.lib.base.util #:1am))

(in-package #:mfiano.lib.gfx.pixel-format/test)

(test pixel-format.rgba8888/u8
  (let ((dest (make-f64-array 4))
        (src (to-u8-array '(255 128 32 8)))
        (decoded #(1d0 0.5019607843137255d0 0.12549019607843137d0 0.03137254901960784d0)))
    (pf:decode-rgba8888/u8 src 0 dest 0 1)
    (pf:encode-rgba8888/u8 dest 0 src 0 1)
    (is (equalp src #(255 128 32 8)))
    (is (equalp dest decoded))))

(test pixel-format.rgba8888/u32
  (let ((dest (make-f64-array 4))
        (src (to-u32-array `(,(logior (ash 255 24) (ash 128 16) (ash 32 8) 8))))
        (decoded #(1d0 0.5019607843137255d0 0.12549019607843137d0 0.03137254901960784d0)))
    (pf:decode-rgba8888/u32 src 0 dest 0 1)
    (pf:encode-rgba8888/u32 dest 0 src 0 1)
    (is (equalp src #(4286586888)))
    (is (equalp dest decoded))))

(test pixel-format.abgr8888/u8
  (let ((dest (make-f64-array 4))
        (src (to-u8-array '(255 128 32 8)))
        (decoded #(0.03137254901960784d0 0.12549019607843137d0 0.5019607843137255d0 1d0)))
    (pf:decode-abgr8888/u8 src 0 dest 0 1)
    (pf:encode-abgr8888/u8 dest 0 src 0 1)
    (is (equalp src #(255 128 32 8)))
    (is (equalp dest decoded))))

(test pixel-format.abgr8888/u32
  (let ((dest (make-f64-array 4))
        (src (to-u32-array `(,(logior (ash 255 24) (ash 128 16) (ash 32 8) 8))))
        (decoded #(0.03137254901960784d0 0.12549019607843137d0 0.5019607843137255d0 1d0)))
    (pf:decode-abgr8888/u32 src 0 dest 0 1)
    (pf:encode-abgr8888/u32 dest 0 src 0 1)
    (is (equalp src #(4286586888)))
    (is (equalp dest decoded))))

(test pixel-format.rgb888/u8
  (let ((dest (make-f64-array 4))
        (src (to-u8-array '(255 128 32)))
        (decoded #(1d0 0.5019607843137255d0 0.12549019607843137d0 1d0)))
    (pf:decode-rgb888/u8 src 0 dest 0 1)
    (pf:encode-rgb888/u8 dest 0 src 0 1)
    (is (equalp src #(255 128 32)))
    (is (equalp dest decoded))))

(test pixel-format.bgr888/u8
  (let ((dest (make-f64-array 4))
        (src (to-u8-array '(255 128 32)))
        (decoded #(0.12549019607843137d0 0.5019607843137255d0 1d0 1d0)))
    (pf:decode-bgr888/u8 src 0 dest 0 1)
    (pf:encode-bgr888/u8 dest 0 src 0 1)
    (is (equalp src #(255 128 32)))
    (is (equalp dest decoded))))

(test pixel-format.ga1616/u16
  (let ((dest (make-f64-array 4))
        (src (to-u16-array '(65535 32768)))
        (decoded #(1d0 0d0 0d0 0.5000076295109483d0)))
    (pf:decode-ga1616/u16 src 0 dest 0 1)
    (pf:encode-ga1616/u16 dest 0 src 0 1)
    (is (equalp src #(65535 32768)))
    (is (equalp dest decoded))))

(test pixel-format.ga1616/u32
  (let ((dest (make-f64-array 4))
        (src (to-u32-array `(,(logior (ash 65535 16) 32768))))
        (decoded #(1d0 0d0 0d0 0.5000076295109483d0)))
    (pf:decode-ga1616/u32 src 0 dest 0 1)
    (pf:encode-ga1616/u32 dest 0 src 0 1)
    (is (equalp src #(4294934528)))
    (is (equalp dest decoded))))

(test pixel-format.decode.count-and-indices.rgba8888/u8
  (let ((dest (make-f64-array 32))
        (src (to-u8-array '(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20))))
    (pf:decode-rgba8888/u8 src 1 dest 8 2)
    (is (equalp (subseq dest 8 16)
                #(#.(/ 5d0 255d0) #.(/ 6d0 255d0) #.(/ 7d0 255d0) #.(/ 8d0 255d0)
                  #.(/ 9d0 255d0) #.(/ 10d0 255d0) #.(/ 11d0 255d0) #.(/ 12d0 255d0))))))

(test pixel-format.encode.count-and-indices.rgba8888/u8
  (let ((src (make-f64-array 32))
        (dest (to-u8-array '(99 99 99 99 99 99 99 99 99 99 99 99 99 99 99 99 99 99 99 99))))
    (setf (aref src 8) (/ 1d0 255d0)
          (aref src 9) (/ 2d0 255d0)
          (aref src 10) (/ 3d0 255d0)
          (aref src 11) (/ 4d0 255d0)
          (aref src 12) (/ 250d0 255d0)
          (aref src 13) (/ 251d0 255d0)
          (aref src 14) (/ 252d0 255d0)
          (aref src 15) (/ 253d0 255d0))
    (pf:encode-rgba8888/u8 src 8 dest 2 2)
    (is (equalp dest #(99 99 99 99 99 99 99 99 1 2 3 4 250 251 252 253 99 99 99 99)))))

(test pixel-format.decode.count-and-indices.rgba8888/u32
  (let ((dest (make-f64-array 32))
        (src (to-u32-array (list
                            (logior (ash 1 24) (ash 2 16) (ash 3 8) 4)
                            (logior (ash 5 24) (ash 6 16) (ash 7 8) 8)
                            (logior (ash 9 24) (ash 10 16) (ash 11 8) 12)
                            (logior (ash 13 24) (ash 14 16) (ash 15 8) 16)))))
    (pf:decode-rgba8888/u32 src 1 dest 8 2)
    (is (equalp (subseq dest 8 16)
                #(#.(/ 5d0 255d0) #.(/ 6d0 255d0) #.(/ 7d0 255d0) #.(/ 8d0 255d0)
                  #.(/ 9d0 255d0) #.(/ 10d0 255d0) #.(/ 11d0 255d0) #.(/ 12d0 255d0))))))

(test pixel-format.encode.count-and-indices.rgba8888/u32
  (let ((src (make-f64-array 32))
        (dest (to-u32-array '(0 0 0 0 0))))
    (setf (aref src 8) (/ 1d0 255d0)
          (aref src 9) (/ 2d0 255d0)
          (aref src 10) (/ 3d0 255d0)
          (aref src 11) (/ 4d0 255d0)
          (aref src 12) (/ 250d0 255d0)
          (aref src 13) (/ 251d0 255d0)
          (aref src 14) (/ 252d0 255d0)
          (aref src 15) (/ 253d0 255d0))
    (pf:encode-rgba8888/u32 src 8 dest 2 2)
    (is (equalp dest
                #(0 0
                  #.(logior (ash 1 24) (ash 2 16) (ash 3 8) 4)
                  #.(logior (ash 250 24) (ash 251 16) (ash 252 8) 253)
                  0)))))

(test pixel-format.encode.ignores-alpha.rgb888/u8
  (let ((src-a (make-f64-array 4))
        (src-b (make-f64-array 4))
        (dest-a (to-u8-array '(0 0 0)))
        (dest-b (to-u8-array '(0 0 0))))
    (setf (aref src-a 0) (/ 8d0 255d0)
          (aref src-a 1) (/ 16d0 255d0)
          (aref src-a 2) (/ 32d0 255d0)
          (aref src-a 3) 0d0)
    (setf (aref src-b 0) (/ 8d0 255d0)
          (aref src-b 1) (/ 16d0 255d0)
          (aref src-b 2) (/ 32d0 255d0)
          (aref src-b 3) 1d0)
    (pf:encode-rgb888/u8 src-a 0 dest-a 0 1)
    (pf:encode-rgb888/u8 src-b 0 dest-b 0 1)
    (is (equalp dest-a dest-b))))

(test pixel-format.encode.ignores-alpha.bgr888/u8
  (let ((src-a (make-f64-array 4))
        (src-b (make-f64-array 4))
        (dest-a (to-u8-array '(0 0 0)))
        (dest-b (to-u8-array '(0 0 0))))
    (setf (aref src-a 0) (/ 8d0 255d0)
          (aref src-a 1) (/ 16d0 255d0)
          (aref src-a 2) (/ 32d0 255d0)
          (aref src-a 3) 0d0)
    (setf (aref src-b 0) (/ 8d0 255d0)
          (aref src-b 1) (/ 16d0 255d0)
          (aref src-b 2) (/ 32d0 255d0)
          (aref src-b 3) 1d0)
    (pf:encode-bgr888/u8 src-a 0 dest-a 0 1)
    (pf:encode-bgr888/u8 src-b 0 dest-b 0 1)
    (is (equalp dest-a dest-b))))

(test pixel-format.encode.ignores-unused-channels.ga1616/u16
  (let ((src-a (make-f64-array 4))
        (src-b (make-f64-array 4))
        (dest-a (to-u16-array '(0 0)))
        (dest-b (to-u16-array '(0 0))))
    (setf (aref src-a 0) (/ 10000d0 65535d0)
          (aref src-a 1) 0.25d0
          (aref src-a 2) 0.75d0
          (aref src-a 3) (/ 20000d0 65535d0))
    (setf (aref src-b 0) (/ 10000d0 65535d0)
          (aref src-b 1) 0.99d0
          (aref src-b 2) 0.01d0
          (aref src-b 3) (/ 20000d0 65535d0))
    (pf:encode-ga1616/u16 src-a 0 dest-a 0 1)
    (pf:encode-ga1616/u16 src-b 0 dest-b 0 1)
    (is (equalp dest-a dest-b))))

(test pixel-format.decode.default-alpha.rgb888/u8
  (let ((dest (make-f64-array 4))
        (src (to-u8-array '(1 2 3))))
    (pf:decode-rgb888/u8 src 0 dest 0 1)
    (is (= (aref dest 3) 1d0))))

(test pixel-format.decode.default-alpha.bgr888/u8
  (let ((dest (make-f64-array 4))
        (src (to-u8-array '(1 2 3))))
    (pf:decode-bgr888/u8 src 0 dest 0 1)
    (is (= (aref dest 3) 1d0))))

(test pixel-format.decode.missing-channels.ga1616/u16
  (let ((dest (make-f64-array 4))
        (src (to-u16-array '(65535 0))))
    (pf:decode-ga1616/u16 src 0 dest 0 1)
    (is (equalp dest #(1d0 0d0 0d0 0d0)))))

(test pixel-format.decode.missing-channels.ga1616/u32
  (let ((dest (make-f64-array 4))
        (src (to-u32-array (list (logior (ash 65535 16) 0)))))
    (pf:decode-ga1616/u32 src 0 dest 0 1)
    (is (equalp dest #(1d0 0d0 0d0 0d0)))))

(test pixel-format.encode.clamps-and-quantizes.u8
  (let ((src (make-f64-array 4))
        (dest (to-u8-array '(0 0 0 0)))
        (decoded (make-f64-array 4)))
    (setf (aref src 0) -10d0
          (aref src 1) 10d0
          (aref src 2) -1d0
          (aref src 3) 2d0)
    (pf:encode-rgba8888/u8 src 0 dest 0 1)
    (pf:decode-rgba8888/u8 dest 0 decoded 0 1)
    (is (equalp decoded #(0d0 1d0 0d0 1d0)))))

(test pixel-format.encode.clamps-and-quantizes.u16
  (let ((src (make-f64-array 4))
        (dest (to-u16-array '(0 0)))
        (decoded (make-f64-array 4)))
    (setf (aref src 0) -10d0
          (aref src 3) 10d0)
    (pf:encode-ga1616/u16 src 0 dest 0 1)
    (pf:decode-ga1616/u16 dest 0 decoded 0 1)
    (is (= (aref decoded 0) 0d0))
    (is (= (aref decoded 3) 1d0))))

(test pixel-format.packed-unpacked.equivalence.rgba
  (let ((src (make-f64-array 4))
        (dest-u8 (to-u8-array '(0 0 0 0)))
        (dest-u32 (to-u32-array '(0)))
        (decoded-u8 (make-f64-array 4))
        (decoded-u32 (make-f64-array 4)))
    (setf (aref src 0) (/ 8d0 255d0)
          (aref src 1) (/ 16d0 255d0)
          (aref src 2) (/ 32d0 255d0)
          (aref src 3) (/ 64d0 255d0))
    (pf:encode-rgba8888/u8 src 0 dest-u8 0 1)
    (pf:encode-rgba8888/u32 src 0 dest-u32 0 1)
    (pf:decode-rgba8888/u8 dest-u8 0 decoded-u8 0 1)
    (pf:decode-rgba8888/u32 dest-u32 0 decoded-u32 0 1)
    (is (equalp decoded-u8 decoded-u32))))

(test pixel-format.packed-unpacked.equivalence.abgr
  (let ((src (make-f64-array 4))
        (dest-u8 (to-u8-array '(0 0 0 0)))
        (dest-u32 (to-u32-array '(0)))
        (decoded-u8 (make-f64-array 4))
        (decoded-u32 (make-f64-array 4)))
    (setf (aref src 0) (/ 8d0 255d0)
          (aref src 1) (/ 16d0 255d0)
          (aref src 2) (/ 32d0 255d0)
          (aref src 3) (/ 64d0 255d0))
    (pf:encode-abgr8888/u8 src 0 dest-u8 0 1)
    (pf:encode-abgr8888/u32 src 0 dest-u32 0 1)
    (pf:decode-abgr8888/u8 dest-u8 0 decoded-u8 0 1)
    (pf:decode-abgr8888/u32 dest-u32 0 decoded-u32 0 1)
    (is (equalp decoded-u8 decoded-u32))))

(test pixel-format.packed-unpacked.equivalence.ga1616
  (let ((src (make-f64-array 4))
        (dest-u16 (to-u16-array '(0 0)))
        (dest-u32 (to-u32-array '(0)))
        (decoded-u16 (make-f64-array 4))
        (decoded-u32 (make-f64-array 4)))
    (setf (aref src 0) (/ 12345d0 65535d0)
          (aref src 3) (/ 54321d0 65535d0))
    (pf:encode-ga1616/u16 src 0 dest-u16 0 1)
    (pf:encode-ga1616/u32 src 0 dest-u32 0 1)
    (pf:decode-ga1616/u16 dest-u16 0 decoded-u16 0 1)
    (pf:decode-ga1616/u32 dest-u32 0 decoded-u32 0 1)
    (is (equalp decoded-u16 decoded-u32))))

(test pixel-format.zero-count.no-op.decode
  (let ((dest (make-f64-array 8))
        (src-u8 (to-u8-array '(1 2 3 4 5 6 7 8))))
    (setf (aref dest 0) 123d0
          (aref dest 1) 456d0
          (aref dest 2) 789d0
          (aref dest 3) 321d0)
    (pf:decode-rgba8888/u8 src-u8 0 dest 0 0)
    (is (= (aref dest 0) 123d0))
    (is (= (aref dest 1) 456d0))
    (is (= (aref dest 2) 789d0))
    (is (= (aref dest 3) 321d0))))

(test pixel-format.zero-count.no-op.encode
  (let ((src (make-f64-array 8))
        (dest-u8 (to-u8-array '(9 9 9 9 9 9 9 9))))
    (setf (aref src 0) 0.25d0
          (aref src 1) 0.5d0
          (aref src 2) 0.75d0
          (aref src 3) 1d0)
    (pf:encode-rgba8888/u8 src 0 dest-u8 0 0)
    (is (equalp dest-u8 #(9 9 9 9 9 9 9 9)))))

(test pixel-format.roundtrip.multi-pixel.rgba8888/u8
  (let ((src (to-u8-array '(1 2 3 4 8 16 32 64 100 101 102 103 200 201 202 203)))
        (decoded (make-f64-array 16)))
    (pf:decode-rgba8888/u8 src 0 decoded 0 4)
    (pf:encode-rgba8888/u8 decoded 0 src 0 4)
    (is (equalp src #(1 2 3 4 8 16 32 64 100 101 102 103 200 201 202 203)))))

(test pixel-format.roundtrip.multi-pixel.rgba8888/u32
  (let ((src (to-u32-array (list
                            (logior (ash 1 24) (ash 2 16) (ash 3 8) 4)
                            (logior (ash 8 24) (ash 16 16) (ash 32 8) 64)
                            (logior (ash 100 24) (ash 101 16) (ash 102 8) 103)
                            (logior (ash 200 24) (ash 201 16) (ash 202 8) 203))))
        (decoded (make-f64-array 16)))
    (pf:decode-rgba8888/u32 src 0 decoded 0 4)
    (pf:encode-rgba8888/u32 decoded 0 src 0 4)
    (is (equalp src
                #(#.(logior (ash 1 24) (ash 2 16) (ash 3 8) 4)
                  #.(logior (ash 8 24) (ash 16 16) (ash 32 8) 64)
                  #.(logior (ash 100 24) (ash 101 16) (ash 102 8) 103)
                  #.(logior (ash 200 24) (ash 201 16) (ash 202 8) 203))))))

(test pixel-format.roundtrip.multi-pixel.abgr8888/u8
  (let ((src (to-u8-array '(1 2 3 4 8 16 32 64 100 101 102 103 200 201 202 203)))
        (decoded (make-f64-array 16)))
    (pf:decode-abgr8888/u8 src 0 decoded 0 4)
    (pf:encode-abgr8888/u8 decoded 0 src 0 4)
    (is (equalp src #(1 2 3 4 8 16 32 64 100 101 102 103 200 201 202 203)))))

(test pixel-format.roundtrip.multi-pixel.abgr8888/u32
  (let ((src (to-u32-array (list
                            (logior (ash 1 24) (ash 2 16) (ash 3 8) 4)
                            (logior (ash 8 24) (ash 16 16) (ash 32 8) 64)
                            (logior (ash 100 24) (ash 101 16) (ash 102 8) 103)
                            (logior (ash 200 24) (ash 201 16) (ash 202 8) 203))))
        (decoded (make-f64-array 16)))
    (pf:decode-abgr8888/u32 src 0 decoded 0 4)
    (pf:encode-abgr8888/u32 decoded 0 src 0 4)
    (is (equalp src
                #(#.(logior (ash 1 24) (ash 2 16) (ash 3 8) 4)
                  #.(logior (ash 8 24) (ash 16 16) (ash 32 8) 64)
                  #.(logior (ash 100 24) (ash 101 16) (ash 102 8) 103)
                  #.(logior (ash 200 24) (ash 201 16) (ash 202 8) 203))))))

(test pixel-format.roundtrip.multi-pixel.rgb888/u8
  (let ((src (to-u8-array '(1 2 3 8 16 32 100 101 102 200 201 202)))
        (decoded (make-f64-array 16)))
    (pf:decode-rgb888/u8 src 0 decoded 0 4)
    (pf:encode-rgb888/u8 decoded 0 src 0 4)
    (is (equalp src #(1 2 3 8 16 32 100 101 102 200 201 202)))))

(test pixel-format.roundtrip.multi-pixel.bgr888/u8
  (let ((src (to-u8-array '(1 2 3 8 16 32 100 101 102 200 201 202)))
        (decoded (make-f64-array 16)))
    (pf:decode-bgr888/u8 src 0 decoded 0 4)
    (pf:encode-bgr888/u8 decoded 0 src 0 4)
    (is (equalp src #(1 2 3 8 16 32 100 101 102 200 201 202)))))

(test pixel-format.roundtrip.multi-pixel.ga1616/u16
  (let ((src (to-u16-array '(0 65535 1 2 32768 32767 65535 0)))
        (decoded (make-f64-array 16)))
    (pf:decode-ga1616/u16 src 0 decoded 0 4)
    (pf:encode-ga1616/u16 decoded 0 src 0 4)
    (is (equalp src #(0 65535 1 2 32768 32767 65535 0)))))

(test pixel-format.roundtrip.multi-pixel.ga1616/u32
  (let ((src (to-u32-array (list
                            (logior (ash 0 16) 65535)
                            (logior (ash 1 16) 2)
                            (logior (ash 32768 16) 32767)
                            (logior (ash 65535 16) 0))))
        (decoded (make-f64-array 16)))
    (pf:decode-ga1616/u32 src 0 decoded 0 4)
    (pf:encode-ga1616/u32 decoded 0 src 0 4)
    (is (equalp src
                #(#.(logior (ash 0 16) 65535)
                  #.(logior (ash 1 16) 2)
                  #.(logior (ash 32768 16) 32767)
                  #.(logior (ash 65535 16) 0))))))

(test pixel-format.checkers.swizzle-length-and-uniqueness
  (signals error (pf::check-swizzle '(0 0 1 2) 4)))

(test pixel-format.invariants.encode-clamps-integer
  (let ((src (make-f64-array 4))
        (u8 (to-u8-array #(9 9 9 9))))
    (setf (aref src 0) -1d0
          (aref src 1) 0d0
          (aref src 2) 0.5d0
          (aref src 3) 2d0)
    (pf:encode-rgba8888/u8 src 0 u8 0 1)
    (is (equalp u8 #(0 0 128 255))))
  (let ((src (make-f64-array 4))
        (u16 (to-u16-array #(9 9))))
    (setf (aref src 0) -10d0
          (aref src 3) 10d0)
    (pf:encode-ga1616/u16 src 0 u16 0 1)
    (is (equalp u16 #(0 65535))))
  (let ((src (make-f64-array 4))
        (u32 (make-u32-array 1)))
    (setf (aref src 0) -1d0
          (aref src 1) 0d0
          (aref src 2) 0.5d0
          (aref src 3) 2d0)
    (pf:encode-rgba8888/u32 src 0 u32 0 1)
    (is (= (aref u32 0) (logior (ash 0 24) (ash 0 16) (ash 128 8) 255)))))

(test pixel-format.invariants.count-zero-noop
  (let* ((src (make-u8-array 8))
         (src-copy (copy-seq src))
         (dest (make-f64-array 16))
         (dest-copy (copy-seq dest)))
    (pf:decode-rgba8888/u8 src 0 dest 0 0)
    (is (equalp dest dest-copy))
    (pf:encode-rgba8888/u8 dest 0 src 0 0)
    (is (equalp src src-copy))))
