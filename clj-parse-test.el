;;; clj-parse-test.el --- Clojure/EDN parser

;; Copyright (C) 2017  Arne Brasseur

;; Author: Arne Brasseur <arne@arnebrasseur.net>
;; Version: 0.1.0

;; This program is free software; you can redistribute it and/or modify it under
;; the terms of the Mozilla Public License Version 2.0

;; This program is distributed in the hope that it will be useful, but WITHOUT
;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
;; FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
;; details.

;; You should have received a copy of the Mozilla Public License along with this
;; program. If not, see <https://www.mozilla.org/media/MPL/2.0/index.txt>.

;;; Commentary:

;; A reader for EDN data files and parser for Clojure source files.

;;; Code:

(require 'clj-parse)
(require 'ert)

(ert-deftest clj-parse-test ()
  (with-temp-buffer
    (insert "(1 2 3)")
    (goto-char 1)
    (should (equal (clj-parse) '((1 2 3)))))

  (with-temp-buffer
    (insert "()")
    (goto-char 1)
    (should (equal (clj-parse) '(()))))

  (with-temp-buffer
    (insert "(1)")
    (goto-char 1)
    (should (equal (clj-parse) '((1)))))

  (with-temp-buffer
    (insert "(nil true false hello-world)")
    (goto-char 1)
    (should (equal (clj-parse) '((nil t nil hello-world)))))

  (with-temp-buffer
    (insert "clojure.string/join")
    (goto-char 1)
    (should (equal (clj-parse) '(clojure.string/join))))

  (with-temp-buffer
    (insert "((.9 abc (true) (hello)))")
    (goto-char 1)
    (should (equal (clj-parse) '(((0.9 abc (t) (hello)))))))

  (with-temp-buffer
    (insert "\"abc hello \\t\\\"x\"")
    (goto-char 1)
    (should (equal (clj-parse) '("abc hello \t\"x"))))

  (with-temp-buffer
    (insert "(\"---\\f---\\\"-'\\'-\\\\-\\r\\n\")")
    (goto-char 1)
    (should (equal (clj-parse) '(("---\f---\"-''-\\-\r\n")))))

  (with-temp-buffer
    (insert "(\\newline \\return \\space \\tab \\a \\b \\c \\u0078 \\o171)")
    (goto-char 1)
    (should (equal (clj-parse) '((?\n ?\r ?\ ?\t ?a ?b ?c ?x ?y)))))

  (with-temp-buffer
    (insert "\"\\u0078 \\o171\"")
    (goto-char 1)
    (should (equal (clj-parse) '("x y"))))

  (with-temp-buffer
    (insert ":foo-bar")
    (goto-char 1)
    (should (equal (clj-parse) '(:foo-bar))))

  (with-temp-buffer
    (insert "[123]")
    (goto-char 1)
    (should (equal (clj-parse) '([123]))))

  (with-temp-buffer
    (insert "{:count 123}")
    (goto-char 1)
    (should (equal (clj-parse) '(((:count . 123))))))

  (with-temp-buffer
    (insert "#{:x}")
    (goto-char 1)
    (should (equal (clj-parse) '((:x)))))

  (with-temp-buffer
    (insert "(10 #_11 12 #_#_ 13 14)")
    (goto-char 1)
    (should (equal (clj-parse) '((10 12))))))

(provide 'clj-parse-test)

;;; clj-parse-test.el ends here
