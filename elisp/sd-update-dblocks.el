;;; sd-update-dblocks.el --- Batch-update dblocks -*- lexical-binding: t -*-

;; Copyright (c) 2022 Simon Dobson <simoninireland@gmail.com>

;; Author: Simon Dobson <simoninireland@gmail.com>
;; Maintainer: Simon Dobson <simoninireland@gmail.com>
;; Version: 0.1.1
;; Keywords: hypermedia, multimedia
;; Homepage: https://simondobson.org
;; Package-Requires: ((emacs "27.2") (org "8.0"))

;; This file is NOT part of GNU Emacs.
;;
;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; A script to update all ther dblocks in a set of files.

;;; Code:

;; Load the dependencies
(setq package-load-list '((s t)
			  (f t)
			  (dash t)
			  (parsebib t)
			  (org t)
			  ))
(package-initialize)

(require 'org)
(require 'sd-parsebib)

(dolist (f '("pages/research/publications.org"))
  (with-temp-buffer
    (insert-file-contents f)
    (set-auto-mode t)
    (org-update-all-dblocks)
    (write-file "ttt.org")))
