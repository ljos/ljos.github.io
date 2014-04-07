.PHONY: all clean

EMACS?=emacs

all:
	$(EMACS) --no-init-file --batch --script publish.el

clean:
	rm -r .org-timestamps
	rm -r html
	rm -r .elpa
