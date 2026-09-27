# Makefile — cheatsheets

ritual:
	@cat RITUAL.txt

board:
	~/Avalhla/scripts/ava-board
	@echo "Board cache: ~/.cache/avalhla/board.txt"

bin:
	@mkdir -p bin
	@for f in scripts/*; do \
		[ -x "$$f" ] || continue; \
		n="$$(basename "$$f")"; \
		[ -e "bin/$$n" ] && continue; \
		ln -s "../$$f" "bin/$$n" && echo "+ bin/$$n"; \
	done
.PHONY: bin
