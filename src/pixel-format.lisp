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
   #:pixel-format/u24
   #:pixel-format/u32)
  ;; definer
  (:export
   #:define-pixel-format)
  ;; accessors
  (:export
   #:get-bpp
   #:get-channel-count
   #:get-decoder
   #:get-encoder
   #:get-storage)
  ;; builtin formats
  (:export
   #:abgr8888/u8
   #:abgr8888/u32
   #:bgr888/u8
   #:ga1616/u16
   #:ga1616/u32
   #:rgb888/u8
   #:rgba8888/u8
   #:rgba8888/u32)
  ;; builtin codecs
  (:export
   #:encode-abgr8888/u8
   #:encode-abgr8888/u32
   #:encode-bgr888/u8
   #:encode-ga1616/u16
   #:encode-ga1616/u32
   #:encode-rgb888/u8
   #:encode-rgba8888/u8
   #:encode-rgba8888/u32
   #:decode-abgr8888/u8
   #:decode-abgr8888/u32
   #:decode-bgr888/u8
   #:decode-ga1616/u16
   #:decode-ga1616/u32
   #:decode-rgb888/u8
   #:decode-rgba8888/u8
   #:decode-rgba8888/u32))

(in-package #:mfiano.lib.gfx.pixel-format)

(deftype pixel-format/u8 () '(member abgr8888/u8 bgr888/u8 rgb888/u8 rgba8888/u8))

(deftype pixel-format/u16 () '(member ga1616/u16))

(deftype pixel-format/u24 () '(member))

(deftype pixel-format/u32 () '(member abgr8888/u32 rgba8888/u32))

(deftype pixel-format () '(or pixel-format/u8 pixel-format/u16 pixel-format/u24 pixel-format/u32))

(deftype bpp () '(member 8 16 24 32))

(deftype storage () '(member :u8 :u16 :u24 :u32))

(deftype buffer/u8 () '(u8-array (*)))

(deftype buffer/u16 () '(u16-array (*)))

(deftype buffer/u24 () '(u24-array (*)))

(deftype buffer/u32 () '(u32-array (*)))

(deftype index () 'array-index)

(define-ftype get-encoder (pixel-format) fn)
(declaim (inline get-encoder))
(defun get-encoder (pixel-format)
  (declare (optimize (speed 3)))
  (get pixel-format :encoder))

(define-ftype get-decoder (pixel-format) fn)
(declaim (inline get-decoder))
(defun get-decoder (pixel-format)
  (declare (optimize (speed 3)))
  (get pixel-format :decoder))

(define-ftype get-channel-count (pixel-format) (integer 1 4))
(declaim (inline get-channel-count))
(defun get-channel-count (pixel-format)
  (declare (optimize (speed 3)))
  (get pixel-format :channels))

(define-ftype get-bpp (pixel-format) bpp)
(declaim (inline get-bpp))
(defun get-bpp (pixel-format)
  (declare (optimize (speed 3)))
  (get pixel-format :bpp))

(define-ftype get-storage (pixel-format) storage)
(declaim (inline get-storage))
(defun get-storage (pixel-format)
  (declare (optimize (speed 3)))
  (get pixel-format :storage))

(define-ftype ref/le8 (buffer/u8 index) u8)
(declaim (inline ref/le8))
(defun ref/le8 (buffer index)
  (declare (optimize (speed 3)))
  (aref buffer index))

(define-ftype ref/le16 (buffer/u8 index) u16)
(declaim (inline ref/le16))
(defun ref/le16 (buffer index)
  (declare (optimize (speed 3)))
  (let ((value 0))
    (setf (ldb (byte 8 0) value) (aref buffer (+ index 0))
          (ldb (byte 8 8) value) (aref buffer (+ index 1)))
    value))

(define-ftype ref/le24 (buffer/u8 index) u24)
(declaim (inline ref/le24))
(defun ref/le24 (buffer index)
  (declare (optimize (speed 3)))
  (let ((value 0))
    (setf (ldb (byte 8 0) value) (aref buffer (+ index 0))
          (ldb (byte 8 8) value) (aref buffer (+ index 1))
          (ldb (byte 8 16) value) (aref buffer (+ index 2)))
    value))

(define-ftype ref/le32 (buffer/u8 index) u32)
(declaim (inline ref/le32))
(defun ref/le32 (buffer index)
  (declare (optimize (speed 3)))
  (let ((value 0))
    (setf (ldb (byte 8 0) value) (aref buffer (+ index 0))
          (ldb (byte 8 8) value) (aref buffer (+ index 1))
          (ldb (byte 8 16) value) (aref buffer (+ index 2))
          (ldb (byte 8 24) value) (aref buffer (+ index 3)))
    value))

(define-ftype ref/be8 (buffer/u8 index) u8)
(declaim (inline ref/be8))
(defun ref/be8 (buffer index)
  (declare (optimize (speed 3)))
  (aref buffer index))

(define-ftype ref/be16 (buffer/u8 index) u16)
(declaim (inline ref/be16))
(defun ref/be16 (buffer index)
  (declare (optimize (speed 3)))
  (let ((value 0))
    (setf (ldb (byte 8 8) value) (aref buffer (+ index 0))
          (ldb (byte 8 0) value) (aref buffer (+ index 1)))
    value))

(define-ftype ref/be24 (buffer/u8 index) u24)
(declaim (inline ref/be24))
(defun ref/be24 (buffer index)
  (declare (optimize (speed 3)))
  (let ((value 0))
    (setf (ldb (byte 8 16) value) (aref buffer (+ index 0))
          (ldb (byte 8 8) value) (aref buffer (+ index 1))
          (ldb (byte 8 0) value) (aref buffer (+ index 2)))
    value))

(define-ftype ref/be32 (buffer/u8 index) u32)
(declaim (inline ref/be32))
(defun ref/be32 (buffer index)
  (declare (optimize (speed 3)))
  (let ((value 0))
    (setf (ldb (byte 8 24) value) (aref buffer (+ index 0))
          (ldb (byte 8 16) value) (aref buffer (+ index 1))
          (ldb (byte 8 8) value) (aref buffer (+ index 2))
          (ldb (byte 8 0) value) (aref buffer (+ index 3)))
    value))

(define-ftype (setf ref/le8) (u8 buffer/u8 index) (values))
(declaim (inline (setf ref/le8)))
(defun (setf ref/le8) (value buffer index)
  (declare (optimize (speed 3)))
  (setf (aref buffer index) value)
  (values))

(define-ftype (setf ref/le16) (u16 buffer/u8 index) (values))
(declaim (inline (setf ref/le16)))
(defun (setf ref/le16) (value buffer index)
  (declare (optimize (speed 3)))
  (setf (aref buffer (+ index 0)) (ldb (byte 8 0) value)
        (aref buffer (+ index 1)) (ldb (byte 8 8) value))
  (values))

(define-ftype (setf ref/le24) (u24 buffer/u8 index) (values))
(declaim (inline (setf ref/le24)))
(defun (setf ref/le24) (value buffer index)
  (declare (optimize (speed 3)))
  (setf (aref buffer (+ index 0)) (ldb (byte 8 0) value)
        (aref buffer (+ index 1)) (ldb (byte 8 8) value)
        (aref buffer (+ index 2)) (ldb (byte 8 16) value))
  (values))

(define-ftype (setf ref/le32) (u32 buffer/u8 index) (values))
(declaim (inline (setf ref/le32)))
(defun (setf ref/le32) (value buffer index)
  (declare (optimize (speed 3)))
  (setf (aref buffer (+ index 0)) (ldb (byte 8 0) value)
        (aref buffer (+ index 1)) (ldb (byte 8 8) value)
        (aref buffer (+ index 2)) (ldb (byte 8 16) value)
        (aref buffer (+ index 3)) (ldb (byte 8 24) value))
  (values))

(define-ftype (setf ref/be8) (u8 buffer/u8 index) (values))
(declaim (inline (setf ref/be8)))
(defun (setf ref/be8) (value buffer index)
  (setf (aref buffer index) value)
  (values))

(define-ftype (setf ref/be16) (u16 buffer/u8 index) (values))
(declaim (inline (setf ref/be16)))
(defun (setf ref/be16) (value buffer index)
  (declare (optimize (speed 3)))
  (setf (aref buffer (+ index 0)) (ldb (byte 8 8) value)
        (aref buffer (+ index 1)) (ldb (byte 8 0) value))
  (values))

(define-ftype (setf ref/be24) (u24 buffer/u8 index) (values))
(declaim (inline (setf ref/be24)))
(defun (setf ref/be24) (value buffer index)
  (declare (optimize (speed 3)))
  (setf (aref buffer (+ index 0)) (ldb (byte 8 16) value)
        (aref buffer (+ index 1)) (ldb (byte 8 8) value)
        (aref buffer (+ index 2)) (ldb (byte 8 0) value))
  (values))

(define-ftype (setf ref/be32) (u32 buffer/u8 index) (values))
(declaim (inline (setf ref/be32)))
(defun (setf ref/be32) (value buffer index)
  (declare (optimize (speed 3)))
  (setf (aref buffer (+ index 0)) (ldb (byte 8 24) value)
        (aref buffer (+ index 1)) (ldb (byte 8 16) value)
        (aref buffer (+ index 2)) (ldb (byte 8 8) value)
        (aref buffer (+ index 3)) (ldb (byte 8 0) value))
  (values))

(define-ftype ref/le32/u16 (buffer/u16 index) u32)
(declaim (inline ref/le32/u16))
(defun ref/le32/u16 (buffer index)
  (declare (optimize (speed 3)))
  (let ((value 0))
    (setf (ldb (byte 16 0) value) (aref buffer (+ index 0))
          (ldb (byte 16 16) value) (aref buffer (+ index 1)))
    value))

(define-ftype ref/be32/u16 (buffer/u16 fixnum) u32)
(declaim (inline ref/be32/u16))
(defun ref/be32/u16 (buffer index)
  (declare (optimize (speed 3)))
  (let ((value 0))
    (setf (ldb (byte 16 16) value) (aref buffer (+ index 0))
          (ldb (byte 16 0) value) (aref buffer (+ index 1)))
    value))

(define-ftype (setf ref/le32/u16) (u32 buffer/u16 fixnum) (values))
(declaim (inline (setf ref/le32/u16)))
(defun (setf ref/le32/u16) (value buffer index)
  (declare (optimize (speed 3)))
  (setf (aref buffer (+ index 0)) (ldb (byte 16 0) value)
        (aref buffer (+ index 1)) (ldb (byte 16 16) value))
  (values))

(define-ftype (setf ref/be32/u16) (u32 buffer/u16 fixnum) (values))
(declaim (inline (setf ref/be32/u16)))
(defun (setf ref/be32/u16) (value buffer index)
  (declare (optimize (speed 3)))
  (setf (aref buffer (+ index 0)) (ldb (byte 16 16) value)
        (aref buffer (+ index 1)) (ldb (byte 16 0) value))
  (values))

(eval-always
  (defun check-pixel-format (name bpp endianness lanes swizzle storage encoder decoder)
    (unless (symbolp name)
      (error "Pixel codec name must be a symbol, got ~s" name))
    (unless (typep bpp 'bpp)
      (error "Only bpp 8/16/24/32 supported, got ~s" bpp))
    (unless (member endianness '(:le :be))
      (error "Endianness must be :LE or :BE, got ~s" endianness))
    (unless (and (listp lanes) (<= 1 (length lanes) 4))
      (error "Lanes must be a list of 1 to 4 (size position) forms, got ~s" lanes))
    (dolist (lane lanes)
      (unless (listp lane)
        (error "Lane must be a list of (size position), got ~s" lane))
      (destructuring-bind (size position) lane
        (unless (and (integerp size) (<= 1 size bpp))
          (error "Lane size must be 1..~d, got ~s" size bpp))
        (unless (and (integerp position) (<= 0 position (1- bpp)))
          (error "Lane position must be 0..~d, got ~s" (1- bpp) position))
        (when (> (+ position size) bpp)
          (error "Lane overruns pixel: (~d ~d) > bpp" size position))))
    (unless (and (listp swizzle) (= (length swizzle) (length lanes)))
      (error "Swizzle must be a list of the same length as lanes, got ~s" swizzle))
    (dolist (index swizzle)
      (unless (and (integerp index) (<= 0 index 3))
        (error "Swizzle indices must be 0..~d, got ~s" 3 index)))
    (unless (typep storage 'storage)
      (error "Storage must be one of :U8, :U16, :U24, :U32, got ~s" storage))
    (unless (symbolp encoder)
      (error "Encoder must be a symbol, got ~s" encoder))
    (unless (symbolp decoder)
      (error "Decoder must be a symbol, got ~s" decoder))))

(eval-always
  (defun get-storage-stride (storage bpp)
    (unless (typep bpp 'bpp)
      (error "only bpp 8/16/24/32 supported, got: ~d" bpp))
    (case storage
      (:u8
       (truncate bpp 8))
      (:u16
       (unless (or (= bpp 16) (= bpp 32))
         (error "storage ~s requires 16bpp or 32bpp, got ~d" storage bpp))
       (truncate bpp 16))
      (:u24
       (unless (= bpp 24)
         (error "storage ~s requires 24bpp, got ~d" storage bpp))
       1)
      (:u32
       (unless (= bpp 32)
         (error "storage ~s requires 32bpp, got: ~d" storage bpp))
       1)
      (t
       (error "unsupported storage type: ~s" storage)))))

(eval-always
  (defun get-storage-ref-symbol (storage endian bytes)
    (ecase storage
      (:u8
       (ecase endian
         (:le
          (ecase bytes
            (1 'ref/le8)
            (2 'ref/le16)
            (3 'ref/le24)
            (4 'ref/le32)))
         (:be
          (ecase bytes
            (1 'ref/be8)
            (2 'ref/be16)
            (3 'ref/be24)
            (4 'ref/be32)))))
      (:u16
       (ecase endian
         (:le
          (ecase bytes
            (1 'aref)
            (2 'ref/le32/u16)))
         (:be
          (ecase bytes
            (1 'aref)
            (2 'ref/be32/u16)))))
      ((:u24 :u32)
       'aref))))

(eval-always
  (defun get-storage-buffer-type (storage)
    (ecase storage
      (:u8 'buffer/u8)
      (:u16 'buffer/u16)
      (:u24 'buffer/u24)
      (:u32 'buffer/u32))))

(eval-always
  (defun lane->f64-form (lane lanes value-var)
    (if-let ((spec (nth lane lanes)))
      (destructuring-bind (bits shift) spec
        `(* (ldb (byte ,bits ,shift) ,value-var) ,(/ (f64 (1- (ash 1 bits))))))
      0d0)))

(eval-always
  (defun f64->lane-form (lane lanes value-var lane-var)
    (destructuring-bind (bits shift) (nth lane lanes)
      (let* ((clamped `(s:clamp ,lane-var 0d0 1d0))
             (value `(truncate (+ (* ,clamped ,(1- (ash 1 bits))) 0.5d0))))
        `(setf (ldb (byte ,bits ,shift) ,value-var) ,value)))))

(eval-always
  (defun generate-decoder (name buffer-type stride lanes swizzle ref)
    `((define-ftype ,name (,buffer-type index (f64-array (*)) index index) (values))
      (declaim (inline ,name))
      (defun ,name (src src-index dest dest-index count)
        (declare (optimize (speed 3)))
        (dotimes (i count)
          (let* ((index (+ dest-index (* i 4)))
                 (value (,ref src (* (+ src-index i) ,stride))))
            (declare (type index index))
            (setf ,@(loop :for lane-index :below (length lanes)
                          :for channel-index := (nth lane-index swizzle)
                          :collect `(aref dest (+ index ,channel-index))
                          :collect (lane->f64-form lane-index lanes 'value)))))
        (values)))))

(eval-always
  (defun generate-encoder (name buffer-type stride lanes swizzle ref)
    `((define-ftype ,name ((f64-array (*)) index ,buffer-type index index) (values))
      (declaim (inline ,name))
      (defun ,name (src src-index dest dest-index count)
        (declare (optimize (speed 3)))
        (dotimes (i count)
          (let ((index (+ src-index (* i 4)))
                (value 0))
            (declare (type index index))
            ,@(loop :for lane-index :below (length lanes)
                    :for channel-index := (nth lane-index swizzle)
                    :for ref-form := `(aref src (+ index ,channel-index))
                    :collect (f64->lane-form lane-index lanes 'value ref-form)
                      :into forms
                    :finally (return (remove nil forms)))
            (setf (,ref dest (* (+ dest-index i) ,stride)) value)))
        (values)))))

(defmacro define-pixel-format
    (name &body (&key bpp endianness lanes swizzle storage encoder decoder))
  `(progn
     (check-pixel-format ',name ',bpp ',endianness ',lanes ',swizzle ',storage ',encoder ',decoder)
     ,@(let* ((stride (get-storage-stride storage bpp))
              (ref (get-storage-ref-symbol storage endianness stride))
              (buffer-type (get-storage-buffer-type storage)))
         `(,@(generate-encoder encoder buffer-type stride lanes swizzle ref)
           ,@(generate-decoder decoder buffer-type stride lanes swizzle ref)
           (setf (get ',name :encoder) (fdefinition ',encoder)
                 (get ',name :decoder) (fdefinition ',decoder)
                 (get ',name :storage) ,storage
                 (get ',name :channels) ,(length lanes)
                 (get ',name :bpp) ,bpp)))))

(define-pixel-format rgba8888/u8
  :bpp 32
  :endianness :le
  :lanes ((8 0) (8 8) (8 16) (8 24))
  :swizzle (0 1 2 3)
  :storage :u8
  :encoder encode-rgba8888/u8
  :decoder decode-rgba8888/u8)

(define-pixel-format rgba8888/u32
  :bpp 32
  :endianness :le
  :lanes ((8 24) (8 16) (8 8) (8 0))
  :swizzle (0 1 2 3)
  :storage :u32
  :encoder encode-rgba8888/u32
  :decoder decode-rgba8888/u32)

(define-pixel-format abgr8888/u8
  :bpp 32
  :endianness :le
  :lanes ((8 0) (8 8) (8 16) (8 24))
  :swizzle (3 2 1 0)
  :storage :u8
  :encoder encode-abgr8888/u8
  :decoder decode-abgr8888/u8)

(define-pixel-format abgr8888/u32
  :bpp 32
  :endianness :le
  :lanes ((8 24) (8 16) (8 8) (8 0))
  :swizzle (3 2 1 0)
  :storage :u32
  :encoder encode-abgr8888/u32
  :decoder decode-abgr8888/u32)

(define-pixel-format rgb888/u8
  :bpp 24
  :endianness :le
  :lanes ((8 0) (8 8) (8 16))
  :swizzle (0 1 2)
  :storage :u8
  :encoder encode-rgb888/u8
  :decoder decode-rgb888/u8)

(define-pixel-format bgr888/u8
  :bpp 24
  :endianness :le
  :lanes ((8 0) (8 8) (8 16))
  :swizzle (2 1 0)
  :storage :u8
  :encoder encode-bgr888/u8
  :decoder decode-bgr888/u8)

(define-pixel-format ga1616/u16
  :bpp 32
  :endianness :le
  :lanes ((16 0) (16 16))
  :swizzle (0 3)
  :storage :u16
  :encoder encode-ga1616/u16
  :decoder decode-ga1616/u16)

(define-pixel-format ga1616/u32
  :bpp 32
  :endianness :be
  :lanes ((16 16) (16 0))
  :swizzle (0 3)
  :storage :u32
  :encoder encode-ga1616/u32
  :decoder decode-ga1616/u32)
