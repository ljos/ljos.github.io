(setq package-user-dir (concat default-directory ".elpa/"))

(require 'package)

(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/")
             t)

(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(unless (package-installed-p 'htmlize)
  (package-install 'htmlize))

(unless (package-installed-p 'org '(20140407))
  (package-install 'org))

(require 'org)

(setq org-publish-timestamp-directory
      (concat default-directory ".org-timestamps/"))

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
