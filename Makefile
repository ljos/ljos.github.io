.PHONY: all clean

EMACS?=emacs

all:
	$(EMACS) --batch                    \
	         --load publish.el          \
	         --eval "(org-publish-all)"

clean:
	rm -r posts/*
	rm -r elpa
	rm -r org-timestamps
