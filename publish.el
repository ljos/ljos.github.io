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

(setq org-publish-timestamp-directory
      (concat default-directory ".org-timestamps/"))

(setq org-publish-project-alist
      `(("posts"
         :base-directory ,(concat default-directory "org/")
         :base-extension "org"
         :publishing-directory ,default-directory
         :recursive t
         :with-toc nil
         :html-preamble nil
         :html-postamble nil
         :publishing-function org-html-publish-to-html)))

(org-publish-all)
