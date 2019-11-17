(defpackage :sqlite-ffi
  (:use :cl :cffi)
  (:export :error-code
           :p-sqlite3
           :sqlite3-open
           :sqlite3-close
           :sqlite3-errmsg
           :sqlite3-busy-timeout
           :p-sqlite3-stmt
           :sqlite3-prepare
           :sqlite3-finalize
           :sqlite3-step
           :sqlite3-reset
           :sqlite3-clear-bindings
           :sqlite3-column-count
           :sqlite3-column-type
           :sqlite3-column-text
           :sqlite3-column-int64
           :sqlite3-column-double
           :sqlite3-column-bytes
           :sqlite3-column-blob
           :sqlite3-column-name
           :sqlite3-bind-parameter-count
           :sqlite3-bind-parameter-name
           :sqlite3-bind-parameter-index
           :sqlite3-bind-double
           :sqlite3-bind-int64
           :sqlite3-bind-null
           :sqlite3-bind-text
           :sqlite3-bind-blob
           :destructor-transient
           :destructor-static
           :sqlite3-last-insert-rowid

   :sqlite3-context
   :sqlite3-value

   :+sqlite-utf8+
   :+sqlite-utf16le+
   :+sqlite-utf16be+
   :+sqlite-utf16+
   :+sqlite-any+
   :+sqlite-utf16-aligned+
   :+sqlite-static+
   :+sqlite-transient+

   :sqlite3-result-blob
   :sqlite3-result-double
   :sqlite3-result-error
   :sqlite3-result-error16
   :sqlite3-result-error16
   :sqlite3-result-error-toobig
   :sqlite3-result-error-nomem
   :sqlite3-result-error-code
   :sqlite3-result-int
   :sqlite3-result-int64
   :sqlite3-result-null
   :sqlite3-result-text
   :sqlite3-result-text16
   :sqlite3-result-text16le
   :sqlite3-result-text16be
   :sqlite3-result-value
   :sqlite3-result-zeroblob

   :sqlite3-value-zeroblob
   :sqlite3-value-bytes
   :sqlite3-value-bytes16
   :sqlite3-value-double
   :sqlite3-value-int
   :sqlite3-value-int64
   :sqlite3-value-text
   :sqlite3-value-text16
   :sqlite3-value-text16le
   :sqlite3-value-text16be
   :sqlite3-value-type
   :sqlite3-value-numeric-type

   :sqlite3-create-function
))

(in-package :sqlite-ffi)

(define-foreign-library sqlite3-lib
  (:darwin (:default "libsqlite3"))
  (:unix (:or "libsqlite3.so.0" "libsqlite3.so"))
  (t (:or (:default "libsqlite3") (:default "sqlite3"))))

(use-foreign-library sqlite3-lib)

(defcenum error-code
  (:OK 0)
  (:ERROR 1)
  (:INTERNAL 2)
  (:PERM 3)
  (:ABORT 4)
  (:BUSY 5)
  (:LOCKED 6)
  (:NOMEM 7)
  (:READONLY 8)
  (:INTERRUPT 9)
  (:IOERR 10)
  (:CORRUPT 11)
  (:NOTFOUND 12)
  (:FULL 13)
  (:CANTOPEN 14)
  (:PROTOCOL 15)
  (:EMPTY 16)
  (:SCHEMA 17)
  (:TOOBIG 18)
  (:CONSTRAINT 19)
  (:MISMATCH 20)
  (:MISUSE 21)
  (:NOLFS 22)
  (:AUTH 23)
  (:FORMAT 24)
  (:RANGE 25)
  (:NOTADB 26)
  (:ROW 100)
  (:DONE 101))

(defcstruct sqlite3)

#-clisp ;madhu 191117
;; PRINT: not enough stack space for carrying out circularity analysis
(defctype p-sqlite3 (:pointer (:struct sqlite3)))
#+clisp
(defctype p-sqlite3 :pointer)

(defcfun sqlite3-open error-code
  (filename :string)
  (db (:pointer p-sqlite3)))

(defcfun sqlite3-close error-code
  (db p-sqlite3))

(defcfun sqlite3-errmsg :string
  (db p-sqlite3))

(defcfun sqlite3-busy-timeout :int
  (db p-sqlite3)
  (ms :int))

(defcstruct sqlite3-stmt)

(defctype p-sqlite3-stmt (:pointer (:struct sqlite3-stmt)))

(defcfun (sqlite3-prepare "sqlite3_prepare_v2") error-code
  (db p-sqlite3)
  (sql :string)
  (sql-length-bytes :int)
  (stmt (:pointer p-sqlite3-stmt))
  (tail (:pointer (:pointer :char))))

(defcfun sqlite3-finalize error-code
  (statement p-sqlite3-stmt))

(defcfun sqlite3-step error-code
  (statement p-sqlite3-stmt))

(defcfun sqlite3-reset error-code
  (statement p-sqlite3-stmt))

(defcfun sqlite3-clear-bindings error-code
  (statement p-sqlite3-stmt))

(defcfun sqlite3-column-count :int
  (statement p-sqlite3-stmt))

(defcenum type-code
  (:integer 1)
  (:float 2)
  (:text 3)
  (:blob 4)
  (:null 5))

(defcfun sqlite3-column-type type-code
  (statement p-sqlite3-stmt)
  (column-number :int))

(defcfun sqlite3-column-text :string
  (statement p-sqlite3-stmt)
  (column-number :int))

(defcfun sqlite3-column-int64 :int64
  (statement p-sqlite3-stmt)
  (column-number :int))

(defcfun sqlite3-column-double :double
  (statement p-sqlite3-stmt)
  (column-number :int))

(defcfun sqlite3-column-bytes :int
  (statement p-sqlite3-stmt)
  (column-number :int))

(defcfun sqlite3-column-blob :pointer
  (statement p-sqlite3-stmt)
  (column-number :int))

(defcfun sqlite3-column-name :string
  (statement p-sqlite3-stmt)
  (column-number :int))

(defcfun sqlite3-bind-parameter-count :int
  (statement p-sqlite3-stmt))

(defcfun sqlite3-bind-parameter-name :string
  (statement p-sqlite3-stmt)
  (column-number :int))

(defcfun sqlite3-bind-parameter-index :int
  (statement p-sqlite3-stmt)
  (name :string))

(defcfun sqlite3-bind-double error-code
  (statement p-sqlite3-stmt)
  (parameter-index :int)
  (value :double))

(defcfun sqlite3-bind-int64 error-code
  (statement p-sqlite3-stmt)
  (parameter-index :int)
  (value :int64))

(defcfun sqlite3-bind-null error-code
  (statement p-sqlite3-stmt)
  (parameter-index :int))

(defcfun sqlite3-bind-text error-code
  (statement p-sqlite3-stmt)
  (parameter-index :int)
  (value :string)
  (octets-count :int)
  (destructor :pointer))

(defcfun sqlite3-bind-blob error-code
  (statement p-sqlite3-stmt)
  (parameter-index :int)
  (value :pointer)
  (bytes-count :int)
  (destructor :pointer))

#-clisp					;madhu 191117
(defconstant destructor-transient-address (mod -1 (expt 2 (* 8 (cffi:foreign-type-size :pointer)))))
#+clisp
(defvar destructor-transient-address (mod -1 (expt 2 (* 8 (cffi:foreign-type-size :pointer)))))

(defun destructor-transient () (cffi:make-pointer destructor-transient-address))

(defun destructor-static () (cffi:make-pointer 0))

(defcfun sqlite3-last-insert-rowid :int64
  (db p-sqlite3))


;;; ----------------------------------------------------------------------
;;;
;;; ;madhu 180407
;;;
;; text encodings supported by SQLite.
(defvar +SQLITE-UTF8+ 1)
(defvar +SQLITE-UTF16LE+ 2)
(defvar +SQLITE-UTF16BE+ 3)
(defvar +SQLITE-UTF16+ 4)	       ; native byte order
(defvar +SQLITE-ANY+ 5)
(defvar +SQLITE-UTF16-ALIGNED 8)       ; sqlite3_create_collation only

(defcstruct sqlite3-context)
(defcstruct sqlite3-value)

(defctype p-sqlite3-context (:pointer (:struct sqlite3-context)))
(defctype p-sqlite3-value (:pointer (:struct sqlite3-value)))
(defctype p-p-sqlite3-value (:pointer (:pointer (:struct sqlite3-value))))

(defvar +SQLITE-STATIC+ (sqlite-ffi:destructor-static))
(defvar +SQLITE-TRANSIENT+ (sqlite-ffi:destructor-transient))

;; typedef void (*sqlite3_destructor_type)(void*);
;; void sqlite3_result_blob(sqlite3_context*, const void*, int, void(*)(void*));

;; FIXME: this is autoconverted by cffi with 0-terminated strings only!

;; If the 3rd parameter to the sqlite3_result_text* interfaces is
;; negative, then SQLite takes result text from the 2nd parameter
;; through the first zero character. If the 3rd parameter to the
;; sqlite3_result_text* interfaces is non-negative, then as many bytes
;; (not characters) of the text pointed to by the 2nd parameter are
;; taken as the application-defined function result.

;;  If the 4th parameter to the sqlite3_result_text* interfaces or
;;  sqlite3_result_blob is a non-NULL pointer, then SQLite calls that
;;  function as the destructor on the text or BLOB result when it has
;;  finished using that result. If the 4th parameter to the
;;  sqlite3_result_text* interfaces or sqlite3_result_blob is the
;;  special constant SQLITE_STATIC, then SQLite assumes that the text
;;  or BLOB result is in constant space and does not copy the it or
;;  call a destructor when it has finished using that result. If the
;;  4th parameter to the sqlite3_result_text* interfaces or
;;  sqlite3_result_blob is the special constant SQLITE_TRANSIENT then
;;  SQLite makes a copy of the result into space obtained from from
;;  sqlite3_malloc() before it returns.

(defcfun sqlite3-result-blob :pointer
  (ctx p-sqlite3-context)
  (buf :pointer)
  (n :int)
  (func :pointer))

(defcfun sqlite3-result-double :void
  (ctx p-sqlite3-context)
  (val :double))

(defcfun sqlite3-result-error :void
  (ctx p-sqlite3-context)
  (msg :string)
  (len :int))

(defcfun sqlite3-result-error16 :void
  (ctx p-sqlite3-context)
  (msg :string)
  (len :int))

(defcfun sqlite3-result-error-toobig :void
  (ctx p-sqlite3-context))

(defcfun sqlite3-result-error-nomem :void
  (ctx p-sqlite3-context))

(defcfun sqlite3-result-error-code :void
  (ctx p-sqlite3-context)
  (code :int))

(defcfun sqlite3-result-int :void
  (ctx p-sqlite3-context)
  (val :int))

(defcfun sqlite3-result-int64 :void
  (ctx p-sqlite3-context)
  (val :int64))

(defcfun sqlite3-result-null :void
  (ctx p-sqlite3-context))

(defcfun sqlite3-result-text :void
  (ctx p-sqlite3-context)
  (str :string)
  (len :int)
  (destructor :pointer))

(defcfun sqlite3-result-text16 :void
  (ctx p-sqlite3-context)
  (str :string)
  (len :int)
  (destructor :pointer))

(defcfun sqlite3-result-text16le :void
  (ctx p-sqlite3-context)
  (str :string)
  (len :int)
  (destructor :pointer))

(defcfun sqlite3-result-text16be :void
  (ctx p-sqlite3-context)
  (str :string)
  (len :int)
  (destructor :pointer))

(defcfun sqlite3-result-value :void
  (ctx p-sqlite3-context)
  (val (:pointer (:struct sqlite3-value))))

(defcfun sqlite3-result-zeroblob :void
  (ctx p-sqlite3-context)
  (len :int))

(defcfun sqlite3-value-blob :pointer
  (val (:pointer (:struct sqlite3-value))))

(defcfun sqlite3-value-bytes :int
  (val (:pointer (:struct sqlite3-value))))

(defcfun sqlite3-value-bytes16 :int
  (val (:pointer (:struct sqlite3-value))))

(defcfun sqlite3-value-double :double
  (val (:pointer (:struct sqlite3-value))))

(defcfun sqlite3-value-int :int
  (val (:pointer (:struct sqlite3-value))))

(defcfun sqlite3-value-int64 :int64
  (val (:pointer (:struct sqlite3-value))))

(defcfun sqlite3-value-text :string
  (val (:pointer (:struct sqlite3-value))))

(defcfun sqlite3-value-text16 :pointer
  (val (:pointer (:struct sqlite3-value))))

(defcfun sqlite3-value-text16le :pointer
  (val (:pointer (:struct sqlite3-value))))

(defcfun sqlite3-value-text16be :pointer
  (val (:pointer (:struct sqlite3-value))))

;;The sqlite3_value_type() family of interfaces require protected
;;sqlite3_value objects.

(defcfun sqlite3-value-type :int
  (val (:pointer (:struct sqlite3-value))))

(defcfun sqlite3-value-numeric-type :int
  (val (:pointer (:struct sqlite3-value))))

;;

(defcfun sqlite3-create-function sqlite-ffi::error-code
  (db p-sqlite3)
  (fname :string)
  (nargs :int)
  (extetrep :int)			; text encoding SQLITE_ANY
  (papp (:pointer :void))		; user data
  (xfunc (:pointer :void))
  (xstep (:pointer :void))
  (xfinal (:pointer :void))
  )

;;  void (*xFunc)(sqlite3_context*,int,sqlite3_value**),
;;  void (*xStep)(sqlite3_context*,int,sqlite3_value**),
;;  void (*xFinal)(sqlite3_context*)

;; EXAMPLE:
#+nil
(cffi:defcallback log_e :void
    ((ctx (:pointer (:struct sqlite3-context)))
     (n :int)
     (arg (:pointer (:pointer (:struct sqlite3-value)))))
  (let* ((ptr (cffi:mem-ref arg '(:pointer (:struct sqlite3-value))))
	 (par (sqlite3-value-double ptr))
	 (ret (cffi:foreign-funcall "log" :double par :double)))
    (format t "log_e ~A => ~A ignoring n=~A" par ret n)
    (sqlite3-result-double ctx ret)))

#+nil
(sqlite-ffi::sqlite3-create-function (sqlite::handle *db*)
				     "log_e"  ;name
				     1	      ;nargs
				     1	      ;text encoding
				     (cffi:null-pointer) ;user data
				     (cffi:callback log_e) ;xfunc
				     (cffi:null-pointer)   ;xstep
				     (cffi:null-pointer))  ;xfinal

#+nil
(sqlite:execute-to-list *db* "SELECT log_e(100)")
