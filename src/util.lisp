(in-package :cl-pokedex)

(defun at (obj key &rest keys)
  (let ((new (typecase key
               (function (funcall key obj))
               (number (nth key obj))
               (t (when (and (listp obj)
                             (or (stringp key)
                                 (keywordp key)))
                    (if (eql :obj (car obj))
                        (jsown:val obj key)
                        (cdr (assoc key obj))))))))
    (when new
      (if keys
          (apply #'at new keys)
          new))))
