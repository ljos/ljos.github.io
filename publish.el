(setq package-user-dir (concat default-directory "elpa/"))

(require 'package)

(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/")
             t)

(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(setq ljos/packages
      '((htmlize 20130207)
        (org     20140407)))

(while ljos/packages
  (let ((package (car ljos/packages)))
    (unless (package-installed-p (car package) (cdr package))
      (package-install (car package))))
  (setq ljos/packages (cdr ljos/packages)))

(require 'org)

(setq org-publish-timestamp-directory
      (concat default-directory "org-timestamps/"))

;; Hack to get java fontification to work.
(setq c-standard-font-lock-fontify-region-function
      'font-lock-default-fontify-region)

(setq dired-use-ls-dired nil)

(mapc (lambda (file)
        (find-file file)
        (org-babel-tangle)
        (kill-buffer))
      (file-expand-wildcards "org/posts/*.org" t))

(setq org-html-style
      "<link rel=\"stylesheet\" type=\"text/css\" href=\"../css/stylesheet.css\" />")

(setq org-publish-project-alist
      `(("posts"
         :base-directory ,(concat default-directory "org/")
         :base-extension "org"
         :publishing-directory ,default-directory
         :recursive t
         :auto-sitemap t
         :sitemap-filename "index.org"
         :sitemap-title "Index"
         :sitemap-sort-files anti-chronologically
         :sitemap-file-entry-format "%d %t"
         :with-toc nil
         :html-preamble nil
         :html-postamble nil
         :publishing-function org-html-publish-to-html)))
