(in-package #:mfiano.lib.gfx.pixel-format)

(deftype pixel-format/u8 () '(member abgr8888/u8 bgr888/u8 rgb888/u8 rgba8888/u8))

(deftype pixel-format/u16 () '(member ga1616/u16))

(deftype pixel-format/u32 () '(member abgr8888/u32 ga1616/u32 rgba8888/u32))

(deftype pixel-format/f32 () '(member abgr/f32 bgr/f32 rgb/f32 rgba/f32))

(deftype pixel-format/f64 () '(member abgr/f64 bgr/f64 rgb/f64 rgba/f64))

(deftype pixel-format ()
  '(or pixel-format/u8 pixel-format/u16 pixel-format/u32 pixel-format/f32 pixel-format/f64))

(deftype storage () '(member :u8 :u16 :u32 :f32 :f64))

(deftype buffer/u8 () '(u8-array (*)))

(deftype buffer/u16 () '(u16-array (*)))

(deftype buffer/u32 () '(u32-array (*)))

(deftype buffer/f32 () '(f32-array (*)))

(deftype buffer/f64 () '(f64-array (*)))

(deftype index () 'array-index)

(defun check-layout (layout)
  (let ((valid '(:packed :unpacked)))
    (unless (member layout valid)
      (error ":LAYOUT must be one of ~{~s~^, ~}. Got: ~s" valid layout))))

(defun check-storage (storage layout)
  (let ((valid '(:u8 :u16 :u32 :f32 :f64)))
    (unless (member storage valid)
      (error ":STORAGE must be one of ~{~s~^, ~}. Got: ~s" valid storage))
    (case storage
      ((:f32 :f64)
       (unless (eq layout :unpacked)
         (error ":LAYOUT must be :UNPACKED for :STORAGE :F32/F64. Got: ~s" layout))))))

(defun check-channels (channels)
  (let ((valid '(1 2 3 4)))
    (unless (member channels valid)
      (error ":CHANNELS must be one of ~{~s~^, ~}. Got: ~s" valid channels))))

(defun check-swizzle (swizzle channels)
  (unless (and (listp swizzle) (= (length swizzle) channels))
    (error ":SWIZZLE must be a list of one element per channel. Got: ~s" swizzle))
  (unless (= (length (remove-duplicates swizzle)) (length swizzle))
    (error ":SWIZZLE indices must be unique. Got: ~s" swizzle))
  (dolist (index swizzle)
    (unless (and (integerp index) (<= 0 index 3))
      (error ":SWIZZLE indices must be 0..~d. Got: ~s" 3 index))))

(defun check-encoder (encoder)
  (unless (symbolp encoder)
    (error "Encoder must be a symbol, got ~s" encoder)))

(defun check-decoder (decoder)
  (unless (symbolp decoder)
    (error "Decoder must be a symbol, got ~s" decoder)))

(defun update-properties (name properties)
  (let ((channels (getf properties :channels))
        (storage (getf properties :storage))
        (layout (getf properties :layout)))
    (do-plist (k v properties)
      (setf (get name (format-symbol #.*package* "%~a" k)) v))
    (when (eq layout :packed)
      (loop :with word-bits := (ecase storage (:u8 8) (:u16 16) (:u32 32))
            :with lane-bits := (truncate word-bits channels)
            :for lane-index :below channels
            :for shift := (- word-bits (* lane-bits (1+ lane-index)))
            :collect (list lane-bits shift) :into lanes
            :finally (setf (get name '%lanes) lanes)))))

(define-ftype layout (pixel-format) (member :packed :unpacked))
(declaim (inline layout))
(defun layout (pixel-format)
  (declare (optimize (speed 3)))
  (get pixel-format '%layout))

(define-ftype storage (pixel-format) storage)
(declaim (inline storage))
(defun storage (pixel-format)
  (declare (optimize (speed 3)))
  (get pixel-format '%storage))

(define-ftype channel-count (pixel-format) (integer 1 4))
(declaim (inline channel-count))
(defun channel-count (pixel-format)
  (declare (optimize (speed 3)))
  (get pixel-format '%channels))

(define-ftype encoder (pixel-format) fn)
(declaim (inline encoder))
(defun encoder (pixel-format)
  (declare (optimize (speed 3)))
  (get pixel-format '%encoder))

(define-ftype decoder (pixel-format) fn)
(declaim (inline decoder))
(defun decoder (pixel-format)
  (declare (optimize (speed 3)))
  (get pixel-format '%decoder))

(defun generate-encode-form (value bits)
  `(truncate (+ (* (s:clamp ,value 0d0 1d0) ,(1- (ash 1 bits))) 0.5d0)))

(defun generate-encode-form/packed (place value lane)
  (destructuring-bind (bits shift) lane
    `((ldb (byte ,bits ,shift) ,place) ,(generate-encode-form value bits))))

(defun generate-encode-form/unpacked (value storage)
  (ecase storage
    ((:u8 :u16 :u32)
     (generate-encode-form value (ecase storage (:u8 8) (:u16 16) (:u32 32))))
    (:f32
     `(f32 ,value))
    (:f64
     value)))

(defun generate-encoder (format)
  (let* ((name (get format '%encoder))
         (layout (get format '%layout))
         (storage (get format '%storage))
         (buffer-type (format-symbol #.*package* "BUFFER/~a" storage))
         (lanes (get format '%lanes))
         (stride (ecase layout (:packed 1) (:unpacked (get format '%channels))))
         (swizzle (get format '%swizzle)))
    `((define-ftype ,name ((f64-array (*)) index ,buffer-type index index) (values))
      (declaim (inline ,name))
      (defun ,name (src src-index dest dest-index count)
        (declare (optimize (speed 3)))
        (dotimes (i count)
          (let ((decoded-pixel-index (+ src-index (* i 4)))
                (encoded-pixel-index (* (+ dest-index i) ,stride))
                ,@(when (eq layout :packed)
                    '((pixel 0))))
            (setf
             ,@(loop :for lane-index :below (length swizzle)
                     :for lane := (nth lane-index lanes)
                     :for channel-index := (nth lane-index swizzle)
                     :for decoded := `(aref src (+ decoded-pixel-index ,channel-index))
                     :append (ecase layout
                               (:packed
                                (generate-encode-form/packed 'pixel decoded lane))
                               (:unpacked
                                `((aref dest (+ encoded-pixel-index ,lane-index))
                                  ,(generate-encode-form/unpacked decoded storage)))))
             ,@(when (eq layout :packed)
                 `((aref dest encoded-pixel-index) pixel)))))
        (values))
      (setf (get ',format '%encoder) (fdefinition ',name)))))

(defun generate-decode-form (value bits)
  `(* ,value (f64 ,(/ (1- (ash 1 bits))))))

(defun generate-decode-form/packed (value lane)
  (destructuring-bind (bits shift) lane
    (generate-decode-form `(ldb (byte ,bits ,shift) ,value) bits)))

(defun generate-decode-form/unpacked (value storage)
  (ecase storage
    ((:u8 :u16 :u32)
     (generate-decode-form value (ecase storage (:u8 8) (:u16 16) (:u32 32))))
    (:f32
     `(f64 ,value))
    (:f64
     value)))

(defun generate-decoder (format)
  (let* ((name (get format '%decoder))
         (layout (get format '%layout))
         (storage (get format '%storage))
         (buffer-type (format-symbol #.*package* "BUFFER/~a" storage))
         (lanes (get format '%lanes))
         (stride (ecase layout (:packed 1) (:unpacked (get format '%channels))))
         (swizzle (get format '%swizzle)))
    `((define-ftype ,name (,buffer-type index (f64-array (*)) index index) (values))
      (declaim (inline ,name))
      (defun ,name (src src-index dest dest-index count)
        (declare (optimize (speed 3)))
        (dotimes (i count)
          (let* ((decoded-pixel-index (+ dest-index (* i 4)))
                 (encoded-pixel-index (* (+ src-index i) ,stride))
                 ,@(when (eq layout :packed)
                     `((pixel (aref src encoded-pixel-index)))))
            (setf
             ,@(loop :for channel-index :below 4
                     :for lane-index := (position channel-index swizzle)
                     :for encoded := `(aref src (+ encoded-pixel-index ,lane-index))
                     :collect `(aref dest (+ decoded-pixel-index ,channel-index))
                     :collect (if lane-index
                                  (ecase layout
                                    (:packed
                                     (generate-decode-form/packed 'pixel (nth lane-index lanes)))
                                    (:unpacked
                                     (generate-decode-form/unpacked encoded storage)))
                                  (if (= channel-index 3) 1d0 0d0))))))
        (values))
      (setf (get ',format '%decoder) (fdefinition ',name)))))

(defmacro define-pixel-format (name &body (&rest args
                                           &key layout storage channels swizzle encoder decoder))
  (check-layout layout)
  (check-storage storage layout)
  (check-channels channels)
  (check-swizzle swizzle channels)
  (check-encoder encoder)
  (check-decoder decoder)
  (update-properties name args)
  `(progn
     (update-properties ',name ',args)
     ,@(generate-encoder name)
     ,@(generate-decoder name)))
