(in-package :cl-pokedex)

(defvar *db-connection* nil)

(defun stop-db ()
  (when *db-connection*
    (dbi:disconnect *db-connection*)
    (setq *db-connection* nil)))

(defun start-db ()
  (stop-db)
  (let* ((path (uiop:xdg-data-home "cl-pokedex.sqlite3"))
         (conn (dbi:connect :sqlite3
                            :database-name path)))
    (dbi:do-sql conn
      "CREATE TABLE IF NOT EXISTS cache (
key STRING PRIMARY KEY,
value BLOB
)")
    (dbi:do-sql conn
      "CREATE UNIQUE INDEX IF NOT EXISTS cache_key ON cache (key)")
    (setq *db-connection* conn)))

(defun put-to-db (key value)
  (dbi:do-sql
    *db-connection*
    "INSERT INTO cache (key, value) VALUES (?, ?)
ON CONFLICT (key) DO
UPDATE SET value = ?"
    (list key value value)))

(defun get-from-db (key)
  (second
   (dbi:fetch
    (dbi:execute
     (dbi:prepare
      *db-connection*
      "SELECT value FROM cache WHERE key = ?")
     (list key)))))
