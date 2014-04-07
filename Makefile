.PHONY: all clean

EMACS?=emacs

all:
	$(EMACS) -Q -l publish.el -f save-buffers-kill-terminal

clean:
	rm -r .elpa
	rm -r .org-timestamps
	rm -r *.html
