(in-package :cl-pokedex)

(defun get-by (key obj)
  (when (and (listp obj)
             (or (stringp key)
                 (keywordp key)))
    (if (eql :obj (car obj))
        (jsown:val obj key)
        (cdr (assoc key obj)))))

(defmacro @ (obj &body keys)
    (dolist (key keys obj)
      (setf obj
            (cond
              ((and (symbolp key)
                    (not (keywordp key)))
               `(,key ,obj))
              ((numberp key) `(nth ,key ,obj))
              (t `(get-by ,key ,obj))))))
