(in-package #:mfiano.lib.gfx.pixel-format)

(define-pixel-format rgba8888/u8
  :layout :unpacked
  :channels 4
  :swizzle (0 1 2 3)
  :storage :u8
  :encoder encode-rgba8888/u8
  :decoder decode-rgba8888/u8)

(define-pixel-format rgba8888/u32
  :layout :packed
  :channels 4
  :swizzle (0 1 2 3)
  :storage :u32
  :encoder encode-rgba8888/u32
  :decoder decode-rgba8888/u32)

(define-pixel-format rgba/f32
  :layout :unpacked
  :channels 4
  :swizzle (0 1 2 3)
  :storage :f32
  :encoder encode-rgba/f32
  :decoder decode-rgba/f32)

(define-pixel-format rgba/f64
  :layout :unpacked
  :channels 4
  :swizzle (0 1 2 3)
  :storage :f64
  :encoder encode-rgba/f64
  :decoder decode-rgba/f64)

(define-pixel-format abgr8888/u8
  :layout :unpacked
  :channels 4
  :swizzle (3 2 1 0)
  :storage :u8
  :encoder encode-abgr8888/u8
  :decoder decode-abgr8888/u8)

(define-pixel-format abgr8888/u32
  :layout :packed
  :channels 4
  :swizzle (3 2 1 0)
  :storage :u32
  :encoder encode-abgr8888/u32
  :decoder decode-abgr8888/u32)

(define-pixel-format abgr/f32
  :layout :unpacked
  :channels 4
  :swizzle (3 2 1 0)
  :storage :f32
  :encoder encode-abgr/f32
  :decoder decode-abgr/f32)

(define-pixel-format abgr/f64
  :layout :unpacked
  :channels 4
  :swizzle (3 2 1 0)
  :storage :f64
  :encoder encode-abgr/f64
  :decoder decode-abgr/f64)

(define-pixel-format rgb888/u8
  :layout :unpacked
  :channels 3
  :swizzle (0 1 2)
  :storage :u8
  :encoder encode-rgb888/u8
  :decoder decode-rgb888/u8)

(define-pixel-format rgb/f32
  :layout :unpacked
  :channels 3
  :swizzle (0 1 2)
  :storage :f32
  :encoder encode-rgb/f32
  :decoder decode-rgb/f32)

(define-pixel-format rgb/f64
  :layout :unpacked
  :channels 3
  :swizzle (0 1 2)
  :storage :f64
  :encoder encode-rgb/f64
  :decoder decode-rgb/f64)

(define-pixel-format bgr888/u8
  :layout :unpacked
  :channels 3
  :swizzle (2 1 0)
  :storage :u8
  :encoder encode-bgr888/u8
  :decoder decode-bgr888/u8)

(define-pixel-format bgr/f32
  :layout :unpacked
  :channels 3
  :swizzle (2 1 0)
  :storage :f32
  :encoder encode-bgr/f32
  :decoder decode-bgr/f32)

(define-pixel-format bgr/f64
  :layout :unpacked
  :channels 3
  :swizzle (2 1 0)
  :storage :f64
  :encoder encode-bgr/f64
  :decoder decode-bgr/f64)

(define-pixel-format ga1616/u16
  :layout :unpacked
  :channels 2
  :swizzle (0 3)
  :storage :u16
  :encoder encode-ga1616/u16
  :decoder decode-ga1616/u16)

(define-pixel-format ga1616/u32
  :layout :packed
  :channels 2
  :swizzle (0 3)
  :storage :u32
  :encoder encode-ga1616/u32
  :decoder decode-ga1616/u32)
