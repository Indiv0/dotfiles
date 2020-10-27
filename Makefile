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
ifeq ($(MACHINE),work)
	$(SYMLINK) $(PWD)/.gitconfig.work $(HOME)/.gitconfig
else
	$(SYMLINK) $(PWD)/.gitconfig.personal $(HOME)/.gitconfig
endif
	# gnupg
	$(SYMLINK) $(PWD)/.gnupg $(HOME)
	chmod 700 $(HOME)/.gnupg
	# bash
	$(SYMLINK) $(PWD)/.bash_profile $(HOME)
	$(SYMLINK) $(PWD)/.profile $(HOME)

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
	# gnupg
	rm -f $(HOME)/.gnupg
	# bash
	rm -f $(HOME)/.bash_profile
	rm -f $(HOME)/.profile
