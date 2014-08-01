(setq package-user-dir (concat default-directory "elpa/"))

(require 'package)

(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)

(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(setq ljos/packages
      '((htmlize 20130207)
        (org-plus-contrib 20140602)
        (ess 20140716)))

(while ljos/packages
  (let ((package (car ljos/packages)))
    (unless (package-installed-p (car package) (cdr package))
      (package-install (car package))))
  (setq ljos/packages (cdr ljos/packages)))

(require 'org)
(require 'ox-publish)
(require 'htmlize)

(setq
 ;; Hack to get java fontification to work.
 c-standard-font-lock-fontify-region-function 'font-lock-default-fontify-region

 ess-ask-for-ess-directory nil
 ess-history-file nil

 make-backup-files nil

 org-confirm-babel-evaluate nil
 org-export-htmlize-output-type 'css
 org-export-with-section-numbers nil
 org-export-with-toc nil
 org-publish-timestamp-directory (concat default-directory "org-timestamps/"))

(set-locale-environment "utf-8")
(setenv "LANG" "en_US.UTF-8")

(org-babel-do-load-languages
 'org-babel-load-languages
 '((R . t)))

(defadvice org-babel-execute-src-block (before
                                        remove-coderefs-from-body
                                        (&optional arg info params)
                                        activate)
  (let* ((information (org-babel-get-src-block-info))
         (switches (nth 3 information)))
    (when  (and (stringp switches)
                (string-match "-r" switches))
      (let ((cref-fmt (or (and (string-match "-l \"\\(.+\\)\"" switches)
                               (match-string 1 switches))
                          org-coderef-label-format)))
        (setcar (cdr information)
                (with-temp-buffer
                  (insert (nth 1 information))
                  (goto-char (point-min))
                  (while (re-search-forward
                          (replace-regexp-in-string "%s" ".+" cref-fmt) nil t)
                    (replace-match ""))
                  (buffer-string)))
        (setf info information)))))

(defadvice org-babel-merge-params
  (after ljos/make-directory first () activate)
  (let* ((path (cdr (assoc :tangle ad-return-value)))
         (dir (file-name-directory path)))
    (unless (or (not dir) (file-exists-p dir))
      (make-directory dir 'parents))))

(unless (file-exists-p "src/")
  (make-directory "src/"))

(mapc (lambda (file)
        (find-file file)
        (setq default-directory
              (concat default-directory "../../src/"))
        (org-babel-tangle)
        (kill-buffer))
      (file-expand-wildcards "org/posts/*.org" t))

(setq org-html-style
      "<link rel=\"stylesheet\" type=\"text/css\" href=\"../css/stylesheet.css\" />")

(setq org-publish-project-alist
      `(("posts"
         :auto-sitemap t
         :base-directory ,(concat default-directory "org/")
         :base-extension "org"
         :html-postamble nil
         :html-preamble nil
         :htmlized-source t
         :publishing-directory ,default-directory
         :publishing-function org-html-publish-to-html
         :recursive t
         :sitemap-file-entry-format "%d %t"
         :sitemap-filename "index.org"
         :sitemap-sort-files anti-chronologically
         :sitemap-title "Index"
         :with-toc nil)
        ("images"
         :base-directory ,(concat default-directory "org/")
         :base-extension "png\\|jpg\\|gif\\|pdf"
         :publishing-directory ,default-directory
         :recursive t
         :publishing-function org-publish-attachment)))
