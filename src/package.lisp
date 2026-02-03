(in-package #:mfiano.lib.base.pkg)

(define-package #:mfiano.lib.gfx.pixel-format
  (:local-nicknames
   (#:s #:mfiano.lib.math.scalar.f64))
  (:use #:mfiano.lib.base.util)
  ;; type
  (:export
   #:pixel-format
   #:pixel-format/u8
   #:pixel-format/u16
   #:pixel-format/u32)
  ;; definer
  (:export
   #:define-pixel-format)
  ;; accessors
  (:export
   #:channel-count
   #:decoder
   #:encoder
   #:layout
   #:storage)
  ;; builtin formats
  (:export
   #:abgr8888/u8
   #:abgr8888/u32
   #:abgr/f32
   #:abgr/f64
   #:bgr888/u8
   #:bgr/f32
   #:bgr/f64
   #:ga1616/u16
   #:ga1616/u32
   #:rgb888/u8
   #:rgb/f32
   #:rgb/f64
   #:rgba8888/u8
   #:rgba8888/u32
   #:rgba/f32
   #:rgba/f64)
  ;; builtin codecs
  (:export
   #:encode-abgr8888/u8
   #:encode-abgr8888/u32
   #:encode/abgr/f32
   #:encode/abgr/f64
   #:encode-bgr888/u8
   #:encode-bgr/f32
   #:encode-bgr/f64
   #:encode-ga1616/u16
   #:encode-ga1616/u32
   #:encode-rgb888/u8
   #:encode-rgb/f32
   #:encode-rgb/f64
   #:encode-rgba8888/u8
   #:encode-rgba8888/u32
   #:encode-rgba/f32
   #:encode-rgba/f64
   #:decode-abgr8888/u8
   #:decode-abgr8888/u32
   #:decode-abgr/f32
   #:decode-abgr/f64
   #:decode-bgr888/u8
   #:decode-bgr/f32
   #:decode-bgr/f64
   #:decode-ga1616/u16
   #:decode-ga1616/u32
   #:decode-rgb888/u8
   #:decode-rgba8888/u8
   #:decode-rgba8888/u32
   #:decode-rgb/f32
   #:decode-rgb/f64
   #:decode-rgba/f32
   #:decode-rgba/f64))
