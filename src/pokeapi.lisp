(in-package :cl-pokedex)

(defvar *update-cache-p* nil)

(defparameter *api-uri*
  (quri:make-uri :scheme "https"
                 :host "pokeapi.co"
                 :path "/api/v2/"))

(defun make-api-path (&rest segments)
  (let ((new (quri:copy-uri *api-uri*)))
    (dolist (seg segments (quri:render-uri new))
      (setf (quri.uri:uri-path new)
            (format nil "~A~A/" (quri.uri:uri-path new) seg)))))

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
         (total (@ touch jsown:parse "count"))
         (resp (simple-get
                (quri:make-uri
                 :defaults url
                 :query `(("limit" . ,(format nil "~A" total)))))))
    (@ resp
        jsown:parse
        "results"
        jsown:to-json)))

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
  (cached-get (make-api-path "pokemon")
              :fetcher #'simple-get-list))

(defun pokemon (name)
  (let* ((p (cached-get (make-api-path "pokemon" name)))
         (type-names (iter (for x in (@ p "types"))
                       (collect (@ x "type" "name"))))
         (sprite-urls (let ((sprites nil))
                        (jsown:do-json-keys (k w) (@ p "sprites")
                          (when (stringp w)
                            (setq sprites (acons k w sprites))))
                        sprites)))
    `((:types . ,type-names)
      (:sprites . ,sprite-urls))))
