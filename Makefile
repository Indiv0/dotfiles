.PHONY: all clean

SYMLINK=ln --symbolic --force

all:
	# xinitrc
	$(SYMLINK) $(PWD)/.xinitrc $(HOME)
	$(SYMLINK) $(PWD)/.config $(HOME)
	# Xresources
	$(SYMLINK) $(PWD)/.Xresources $(HOME)
	# cargo
	$(SYMLINK) $(PWD)/.cargo $(HOME)
	# git
	$(SYMLINK) $(PWD)/.gitconfig $(HOME)

clean:
	# xinitrc
	rm -f $(HOME)/.xinitrc
	rm -f $(HOME)/.config
	# Xresources
	rm -f $(HOME)/.Xresources
	# cargo
	rm -f $(HOME)/.cargo
	# git
	rm -f $(HOME)/.gitconfig
