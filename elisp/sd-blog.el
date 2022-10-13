;;; sd-blog.el --- Blog publishing from Emacs with Nikola -*- lexical-binding: t -*-

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

;; This package contains the code needed to integrate Emacs publishing
;; with the Nikola static site builder (https://getnikola.com) in a very
;; basic way. It makes use of Nikola's Org mode plugin
;; (https://plugins.getnikola.com/v8/orgmode/) for the basic functionality,
;; and uses Org's capture templates to create posts.

;;; Code:

(require 'sd-parsebib)


;; ---------- Base variables ----------

(defvar sd/nikola-project (expand-file-name "~/programming/simoninireland.github.io")
  "Directory holding my blog.")

(defvar sd/nikola-venv (expand-file-name (concat sd/nikola-project "/venv3"))
  "Virtual environment to activate for using Nikola.

This can be nil if Nikola is installed into the base system.")

(defvar sd/nikola-post-format "orgmode"
  "Preferred format for blog posts.")


;; ---------- Nikola interface ----------

(defun sd/run-nikola (cmd args)
  "Run the Nikola script with the given CMD and ARGS.

The results are inserted into the current buffer at point."
  (let ((cmd (format "cd %s %s && nikola %s %s"
		     sd/nikola-project
		     (if sd/nikola-venv
			 (format "&& . %s/bin/activate" sd/nikola-venv)
		       "")
		     cmd args)))
    (call-process-shell-command cmd nil (current-buffer) nil)))

(defun sd/nikola-blog-post (title tags)
  "Create a new Nikola blog post with the given TITLE and TAGS.

Return the filename for the post within the blog project, or nil.
The format of the post is determined by the
`sd/nikola-post-format' variable. Posts are stored in a Nikola
project pointed to by the `sd/nikola-project' variable. Any
arguments in `sd/nikola-args' are passed to Nikola."
  (with-temp-buffer
    (let ((args (format "--date-path --title='%s' --tags='%s' --format=%s"
			title tags sd/nikola-post-format)))
      (sd/run-nikola "new_post" args)

      ;; see whether we succeeded, and extract the blog post filename if so
      (goto-char (point-min))
      (let ((match (re-search-forward "INFO: new_post: Your post's text is at: \\(.*\\)" nil t)))
	(if match
	    ;; yes, return the filename within the project
	    (match-string 1))))))


;; ---------- Blogging functions ----------

(defun sd/blog-post (title tags)
  "Create a new blog post using Nikola, and open a buffer on it.

TITLE contains the title of the post, TAGS any tags added to it."
  (interactive "MTitle: \nMTags: ")
  (let ((fn (sd/nikola-blog-post title tags)))
    (if fn
	;; create a buffer onto the file
	(let* ((blogfn (concat sd/nikola-project "/" fn))
	       (buf (org-capture-target-buffer blogfn)))
	  (set-buffer buf)

	  ;; make sure attachments get published
	  (goto-char (point-min))
	  (let ((rel "../../../../files/attachments"))
	    ;; insert attachment link
	    (insert (format "# -*- org-attach-id-dir: \"%s\"; -*-\n" rel))
	    (newline)

	    ;; set the attachments directory for the capture
	    (make-local-variable 'org-attach-id-dir)
	    (setq org-attach-id-dir rel))

	  ;; skip the leading comments (metadata) if present
	  (let ((match (search-forward "#+END_COMMENT" nil t)))
	    (when match
	      ;; jump the commments
	      (forward-line)
	      (beginning-of-line)))

	  ;; insert the title
	  (insert (format "\n* %s\n" title))

	  ;; delete everything from here to the end
	  (save-excursion
	    (let ((start (point))
		  (end (goto-char (point-max))))
	      (delete-region start end)))
	  (newline-and-indent 2)
	  (goto-char (point-max))

	  (message (format "Created blog post '%s' at %s" title fn))
	  buf)

      ;; uninformatively fail if we couldn't get the filename
      (error "Failed to create a new blog post"))))

(defun sd/blog-post-from-capture ()
  "Create a blog post from a capture template,

This reads the title and tags explicitly and passes them to `sd/blog-post'."
  (let ((title (read-string "Post title: "))
	(tags (read-string "Tags: ")))
    (sd/blog-post title tags)))


;; ---------- Capture templates ----------

;;(setq org-capture-templates '())

(add-to-list 'org-capture-templates
	     '("b" "Blog at simondobson.org"))
(add-to-list 'org-capture-templates
	     '("bg" "Blog post"
	       plain
	       (function sd/blog-post-from-capture)
	       "\n%i"
	       :unnarrowed t
	       :jump-to-captured t))


(provide 'sd-blog)
;;; sd-blog.el ends here
