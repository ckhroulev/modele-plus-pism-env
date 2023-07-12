all: run

rules.mk: notes.org
	emacs -Q --batch -l org $^ -f org-babel-tangle

include rules.mk
