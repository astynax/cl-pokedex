(in-package :cl-pokedex)

(defvar *update-cache-p* nil)

(defun simple-get (url)
  (handler-case
      (dex:get url :use-connection-pool nil)
    (dex:http-request-not-found ()
      (format *error-output* "GET ~A => Not Found!" url))
    (dex:http-request-failed (e)
      (format *error-output* "GET ~A => ~D" url (dex:response-status e)))
    (:no-error (body &rest _)
      body)))

(defun simple-get-list (url)
  (let* ((touch (simple-get
                 (quri:make-uri
                  :defaults url
                  :query '(("limit" . "1")))))
         (total (jsown:val (jsown:parse touch) "count"))
         (resp (simple-get
                (quri:make-uri
                 :defaults url
                 :query `(("limit" . ,(format nil "~A" total)))))))
    (jsown:to-json
     (jsown:val
      (jsown:parse resp)
      "results"))))

(defun cached-get (url &key (fetcher #'simple-get))
  (let ((raw (unless *update-cache-p* (get-from-db url))))
    (unless raw
      (let ((resp (funcall fetcher url)))
        (when resp
          (put-to-db url resp)
          (setf raw resp))))
    (and raw
         (jsown:parse raw))))

(defun list-pokemon ()
  (cached-get "https://pokeapi.co/api/v2/pokemon"
              :fetcher #'simple-get-list))
