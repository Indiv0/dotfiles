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
	mkdir -p $(HOME)/.gnupg
ifeq ($(MACHINE),work)
	$(SYMLINK) $(PWD)/.gnupg/gpg.conf.work $(HOME)/.gnupg/gpg.conf
else
	$(SYMLINK) $(PWD)/.gnupg/gpg.conf.personal $(HOME)/.gnupg/gpg.conf
endif
	find $(HOME)/.gnupg -type d -exec chmod 700 {} \;
	find $(HOME)/.gnupg -type f -exec chmod 600 {} \;
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
	rm -f $(HOME)/.gnupg/gpg.conf
	# bash
	rm -f $(HOME)/.bash_profile
	rm -f $(HOME)/.profile
