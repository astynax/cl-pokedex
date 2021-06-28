(in-package :cl-pokedex)

(defvar *db-connection*
  (let* ((path (uiop:xdg-data-home "cl-pokedex.sqlite3"))
         (conn (dbi:connect :sqlite3
                            :database-name path)))
    (dbi:do-sql conn
      "CREATE TABLE IF NOT EXISTS cache (
key STRING PRIMARY KEY,
value STRING
)")
    (dbi:do-sql conn
      "CREATE UNIQUE INDEX IF NOT EXISTS cache_key ON cache (key)")
    conn))

(defun put-to-db (key value)
  (dbi:do-sql
    *db-connection*
    "INSERT INTO cache (key, value) VALUES (?, ?)"
    (list key value)))

(defun get-from-db (key)
  (second
   (dbi:fetch
    (dbi:execute
     (dbi:prepare
      *db-connection*
      "SELECT value FROM cache WHERE key = ?")
     (list key)))))
