;;; sd-parsebib.el -- Parsing bibentries for keywords, categories, etc -*- lexical-binding: t; -*-

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

;; Functions for managing bibliographies within notes.

;;; Code:

(require 's)
(require 'dash)
(require 'parsebib)


;; ---------- Finding entries from point ----------

(defun sd/parsebib--point-on-line (pt)
  "Test whether point lies on the same line as PT."
  (save-excursion
    (let ((bol (progn
		 (beginning-of-line)
		 (point)))
	  (eol (progn
		 (end-of-line)
		 (point))))
      (and (>= pt bol)
	   (<= pt eol)))))

(defun sd/parsebib--back-to-item ()
  "Track back up the file looking for the start of an item.

Items include prambles, stringsd, and comments, as well as
actual references (\"entries\").

Returns the item type with point positioned immediately after it,
of nil if there was no entry found."
  (beginning-of-line)
  (catch 'result
    (while t
      (let* ((pt (point))
	     (type (parsebib-find-next-item pt)))
	(cond ((null type)
	       (throw 'result nil))
	      ((sd/parsebib--point-on-line pt)
	       (throw 'result type))
	      (t
	       (if (equal pt (point-min))
		   (throw 'result nil)
		 (progn
		   (goto-char pt)
		   (forward-line -1)
		   (beginning-of-line)))))))))

(defun sd/parsebib--parse-entry-at-point ()
  "Find the entry that contains point in the current buffer and parse it.

Returns an alist of fields in the entry, or nil if point was not in
an entry. Point is left unchanged across this function."
  (save-excursion
    (let ((item (sd/parsebib--back-to-item)))
      (cond ((null item)
	     nil)
	    ((member item '("string" "preamble" "comment"))
	     nil)
	    (t
	     (parsebib-read-entry item))))))


;; ---------- Look for values in any field ----------

;; We do this by jumping through the buffer looking for the value and,
;; whenever we find it, searching backwards to find the containing reference
;; entry record, parsing it, and checking that the value appears in the
;; right field. This is a lot faster than parsing a large BibTeX file in one
;; go and then traversing every entry -- usually, anyway.
;;
;; Should possibly split the field and look only for whole words, space- or
;; comma-delimited.

(defun sd/parsebib--find-entry-by-key-value (key value)
  "Find the next entry having VALUE as an element of KEY.

Returns the parsed entry with point positioned at its start, or nil."
  (catch 'result
    (while t
      (let ((pt (search-forward-regexp value nil t)))
	(if (null pt)
	    (throw 'result nil)
	  (let ((entry (sd/parsebib--parse-entry-at-point)))
	    (if (null entry)
		(throw 'result nil)
	      (let ((vs (cdr-safe (assoc key entry))))
		(if (and (not (null vs))
			 (s-contains? value vs))
		    (throw 'result entry)
		  (forward-line))))))))))

(defun sd/parsebib--find-entries-by-key-value (key value)
  "Return a list of parsed entries having VALUE in the KEY field.

The value of point is unaffected across this function."
  (save-excursion
    (goto-char (point-min))
    (let (entries)
      (catch 'result
	(while t
	  (let ((entry (sd/parsebib--find-entry-by-key-value key value)))
	    (if (null entry)
		(throw 'result entries)
	      (progn
		(if (null entries)
		    (setq entries (list entry))
		  (push entry entries))

		;; move out of this item before searching again
		(parsebib-find-next-item)))))))))

(defun sd/parsebib--keys-from-entries (entries)
  "Extract the keys from ENTRIES."
  (mapcar #'(lambda (entry)
	      (cdr (assoc "=key=" entry)))
	  entries))


;; ---------- Find entries from bibliographies ----------

(defun sd/parsebib--find-entries-by-key-value-in-file (key value bibfile)
  "Return a list of entries with VALUE in the field KEY in the given BIBFILE."
  (with-temp-buffer
    (insert-file-contents bibfile)
    (sd/parsebib--find-entries-by-key-value key value)))

(defun sd/parsebib--find-entries-by-key-value-in-files (key value file-or-files)
  "Return a list of entries with VALUE in field KEY from bibliographies.

FILE-OR-FILES may be a file or a list of files."
  (if (listp file-or-files)
      (-mapcat #'(lambda (file)
		   (sd/parsebib--find-entries-by-key-value-in-file key value file))
	       file-or-files)
    (sd/parsebib--find-entries-by-key-value-in-file key value file-or-files)))

(defun sd/parsebib--find-entries-by-year-in-files (year file-or-files)
  "Return a list of entries from YEAR from bibliographies.

FILE-OR-FILES may be a file or a list of files."
  (if (listp file-or-files)
      (-mapcat #'(lambda (file)
		   (sd/parsebib--find-entries-by-key-value-in-file "year" year file))
	       file-or-files)
    (sd/parsebib--find-entries-by-key-value-in-file "year" year file-or-files)))


;; ---------- Interface with org-ref for rendering ----------

;; We create a temporary org buffer and write the citations into it
;; together with an appropriate bibliography: link, then let org-ref
;; process the file and cut-out the formatted bibliography.

(defun sd/vars ()
  (interactive)
  (let ((csl-style (org-collect-keywords '("CSL-STYLE" "CSL-LOCALE"))))
    (princ csl-style)
    (princ (assoc  "CSL-STYLE" csl-style))))

(defun sd/parsebib--create-bibliography (backend keys file-or-files csl-style-locale)
  "Return the bibliography consisting of the references KEYS from FILE-OR-FILES.

The bibliography is formatted using BACKEND, and uses 'org-ref' to process
the bibliography. The style of the bibliography can be changed using the
'CSL-STYLE' and 'CSL-LOCALE' variables, which can be defined globally,locally
within the buffer that is current when this function is called, or be passed
in CSL-STYLE-LOCALE in a form extrcated by `org-collect-keywords'. See
`org-ref-process-buffer' for details."
  (with-temp-buffer
    ;; insert the style and locale from the calling buffer, if present
    (let ((csl-styles (assoc "CSL-STYLE" csl-style-locale)))
      (if csl-styles
	  (let* ((styles (car (cdr csl-styles)))
		 (style (if (listp styles)
			    (car styles)
			  styles)))
	    (insert (format "#+CSL-STYLE: %s\n" style)))))
    (let ((csl-locales (assoc "CSL-LOCALE" csl-style-locale)))
      (if csl-locales
	  (let* ((locales (car (cdr csl-locales)))
		 (locale (if (listp locales)
			     (car locales)
			   locales)))
	    (insert (format "#+CSL-LOCALE: %s\n" locale)))))
    (newline)

    ;; insert citations followed by a seperator
    (let ((sep (format "----- %d -----\n" (random)))
	  (inc (if (listp file-or-files)
		   (s-join "," file-or-files)
		 file-or-files)))
      (mapcar #'(lambda (key)
		  (insert (format "cite:%s\n" key)))
	      keys)
      (insert sep)

      ;; insert bibliography link
      (insert (format "[[bibliography:%s]]\n" inc))

      ;; process the buffer to create the bibliography
      (org-ref-process-buffer backend)

      ;; cut out the citations leaving only the bibliography
      (search-backward sep)
      (forward-line 1)
      (let ((end (point)))
	(goto-char (point-min))
	(kill-region (point) end))

      ;; return the bibliography as a string
      (string-trim (buffer-string)))))

(defun sd/parsebib--create-bibliography-year (backend year file csl-style-locale)
  "Create a bibliography of all entries for the given YEAR in FILE.

The bibliography is formatted using `sd/parsebib--create-bibliography' with
BACKEND and the formatting variables in CSL-STYLE-LOCALE."
    (with-temp-buffer
      (let* ((entries (sd/parsebib--find-entries-by-year-in-files (int-to-string year) file))
	     (keys (sd/parsebib--keys-from-entries entries))
	     (bib (sd/parsebib--create-bibliography 'org keys file csl-style-locale)))
	(insert bib))

      ;; return the bibliography as a string
      (string-trim (buffer-string))))


;; ---------- Dynamic blocks containing a bibliography ----------

(defun org-dblock-write:sd/bibliography (params)
  "Update a dynamic block with a bibliography.

PARAMS should contain a ':key' indicating the field in a reference and a
':value' containing its value. The function fills-in the block with all
the references from the `bibtex-completion-bibliography' list that have
that value in that key."
  (let* ((key (cond ((plist-member params :key)
		     (prin1-to-string (plist-get params :key)))
		    (t
		     (error "No :key specified"))))
	 (value (cond ((plist-member params :value)
		       (prin1-to-string (plist-get params :value)))
		      (t
		       (error "No :value specified"))))
	 (csl-style-locale (org-collect-keywords '("CSL-STYLE" "CSL-LOCALE")))
	 (entries (sd/parsebib--find-entries-by-key-value-in-files key value
								   bibtex-completion-bibliography))
	 (keys (sd/parsebib--keys-from-entries entries))
	 (bib (sd/parsebib--create-bibliography 'org keys bibtex-completion-bibliography csl-style-locale)))
    (insert bib)))

(defun org-dblock-write:sd/bibliography-by-year (params)
  "Update a dynamic block containing publications organised by year.

PARAMS should contain a key ':file' pointing to a bibfile that will be presented."

  ;; we create a buffer to write each year into, working backwards from now
  (let* ((bibfile (cond ((plist-member params :file)
			 ;; remove any escapes within the string
			 (replace-regexp-in-string (rx "\\" (group anything)) "\\1" (prin1-to-string (plist-get params :file))))
			(t
			 (error "No :file specified"))))
	 (csl-style-locale (org-collect-keywords '("CSL-STYLE" "CSL-LOCALE")))
	 (bib (with-temp-buffer
	       ;; cycle back through the years
	       ;; (needs to be made more automatic)
	       ;; (also needs to be forward or backwards)
	       (dolist (year (number-sequence 2022 1994 -1))
		 (let ((bibyear (sd/parsebib--create-bibliography-year 'org year bibfile csl-style-locale)))
		   (insert (format "\n** %d\n" year))
		   (newline)
		   (insert bibyear)
		   (newline)))

	       ;; return the bibliography as a string
	       (string-trim (buffer-string)))))
    (insert bib)))


(provide 'sd-parsebib)
