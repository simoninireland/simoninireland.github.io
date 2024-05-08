;;; orgmode-conf.el -- Extra org mode configuration -*- lexical-binding: t; -*-

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

;; Extra set-up and functions for the orgmode plugin for Nikola. It
;; is copied into the orgmode plugin's directory during installation.
;; (Some of this code could possibly migrate to ox-attach-publish at some point.)

;;; Code:

;; Assume all the necessary pockages are available:
;; - org
;; - org-ref

;;; ---------- Citation and attachment handling ----------

;; Use org-ref for expanding citation and bibliography links
(require 'org-ref)
(setenv "BIBINPUTS" "~/personal/dict")
(setq bibtex-completion-bibliography (list (expand-file-name "~/personal/dict/refs.bib")
					   (expand-file-name "~/personal/dict/sd.bib")))
(setq org-ref-csl-default-locale "en-GB"
      org-ref-csl-default-style (expand-file-name "~/programming/simoninireland.github.io/files/online-citations.csl"))
(add-hook 'org-export-before-parsing-hook #'org-ref-process-buffer)

;; Use the development version of ox-attach-publish
(add-to-list 'load-path (concat (expand-file-name "~/programming/ox-attach-publish")))
(require 'ox-attach-publish)


;;; ---------- Project structure and styling ----------

;; Calculate the location of the project's key directories
;; relative to the plugin
(setq base-dir (let ((here (file-name-directory load-file-name)))
		 (expand-file-name "../.." here)))
;;(setq base-dir (expand-file-name "~/programming/simoninireland.github.io"))
(setq pub-dir (expand-file-name "./output" base-dir)
      attachments-base-dir (expand-file-name "./files/attachments" base-dir)
      attachments-pub-dir (expand-file-name "./attachments" pub-dir))

;; Styling for the project
;; (Should move to Nikola configuration file?)
(setq style-plist '(:with-toc nil
		    :with-tags nil
		    :archived-trees nil))


;;; ---------- Code evaluation ----------

;; Execute blocks when re-building, without prompting
(setq org-confirm-babel-evaluate nil)


;;; ---------- Export ----------

(defun sd/blog--post-or-page (fn)
  "Return the stem of the given post or page filename within the project.

This is essentially where it'll end up in the output directory."
  (let* ((path (org-attach-publish--split-path fn))
	 (proj (org-attach-publish--split-path base-dir))
	 (almost-path (org-attach-publish--remove-prefix proj path)))

    ;; drop the first element (pages/ or posts/)
    ;; (should we have an error check?)
    (org-attach-publish--join-path (cdr almost-path))))

(defun sd/blog--update-link-path (l rel)
  "Update a link L to use path REL.

This change the link to be the magic `img-url' type so
it doesn't get re-written."
  (org-element-put-property l :type "img-url")
  (org-element-put-property l :path rel))

(defun sd/blog--export-as-html (&optional async subtreep visible-only body-only ext-plist)
  "Export the current buffer to a new one containing its rendered HTML.

This uses the 'ox-attach-publish' machinery to handle attachments in pages,
re-directing attachment links to the correct published location.

We make use of the fact that we're a Nikola plug-in to find the locations
of the various Nikola content directories."
  (interactive)
  (let* ((old-hooks org-export-before-parsing-hook)
	 (org-export-before-parsing-hook old-hooks))  ; dynamic re-binding

    ;; remove the default link-expansion function from the hook
    (remove-hook 'org-export-before-parsing-hook #'org-attach-expand-links)

    (let* ((element (sd/blog--post-or-page (buffer-file-name (current-buffer))))
	   (fn (concat pub-dir "/" element))
	   (output-fn (concat (file-name-sans-extension fn) "/index.html")))

      ;; publish using the ox-attach-publish HTML backend, which will pick
      ;; up the restricted hook function using dynamic binding
      (let* ((proj `(:output-file ,output-fn
		     :attachments-base-directory ,attachments-base-dir
		     :attachments-publishing-directory ,attachments-pub-dir))
	     (plist (append ext-plist style-plist proj)))
	(org-export-to-buffer
	    'html-with-attachments "*Org HTML Export with Attachments*"
	    async subtreep visible-only body-only
	    plist
	    (lambda () (set-auto-mode t)))))))


;; Call this function instead of the standard one used within `nikola-html-export'
(advice-add 'org-html-export-as-html :override #'sd/blog--export-as-html)


;; Re-write image file links to use img-url: type
(advice-add 'org-attach-publish--update-link-path :override #'sd/blog--update-link-path)
