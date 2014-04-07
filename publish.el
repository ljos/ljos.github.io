(require 'package)
(setq package-user-dir
      (concat default-directory ".elpa/"))

(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(unless (package-installed-p 'htmlize '(20130207))
  (package-install 'htmlize))

(unless (package-installed-p 'org '(20140407))
  (package-install 'org))

(require 'org)
(require 'org-publish)

(setq org-publish-timestamp-directory
      (concat default-directory ".org-timestamps/"))

(setq org-publish-project-alist
      `(("posts"
         :base-directory ,(concat default-directory "org/")
         :base-extension "org"
         :recursive t
         :publishing-directory ,(concat default-directory "html/")
         :with-toc nil
         :html-preamble nil
         :html-postamble nil
         :publishing-function org-html-publish-to-html)))

(org-publish-all)
