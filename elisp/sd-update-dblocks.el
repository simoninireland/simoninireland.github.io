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

;; A script to update all the dblocks in a set of files.

;;; Code:

(package-initialize)

;; We nee to use the latest version of org in order to use
;; the latest version of org-ref. To make this happen, we
;; use straight.el as package manager

(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)

;; Load straight.el as package manager
(defvar bootstrap-version)

(let ((bootstrap-file (expand-file-name "straight/repos/straight.el/bootstrap.el"
					(or (bound-and-true-p straight-base-dir)
					    user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
	(url-retrieve-synchronously
	 "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
	 'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))

  (load bootstrap-file nil 'nomessage))

;; Load org, rather than necessarily using the built-in version
(straight-use-package 'org)

(require 'org)
(require 'org-ref)
(require 'sd-parsebib)

(defun sd/update-dblocks-in-file (fn)
  "Update all the dblocks in FN and store the updates back to it."
  (save-excursion
    (let ((buf (create-file-buffer fn)))
      (set-buffer buf)
      (insert-file-contents fn)
      (set-visited-file-name fn)
      (org-mode)
      (org-update-all-dblocks)
      (write-file fn)
      (kill-buffer buf))))


(defun sd/update-dblocks-in-file (fn)
  "Update all the dblocks in FN and store the updates back to it."
  (with-current-buffer (find-file-noselect fn)
    (org-mode)
    (org-update-all-dblocks)
    (save-buffer)))
