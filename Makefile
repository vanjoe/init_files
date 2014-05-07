

.phony:all
all: $(HOME)/.zshrc $(HOME)/.oh-my-zsh $(HOME)/.bashrc $(HOME)/.emacs.d  $(HOME)/.emacs

$(HOME)/.zshrc: .zshrc
	ln -sf $< $@

$(HOME)/.oh-my-zsh: /usr/bin/git
	curl -L http://install.ohmyz.sh | sh

$(HOME)/.bashrc: .bashrc
	ln -sf $< $@

$(HOME)/.emacs.d: .emacs.d
	ln -sf $< $@

$(HOME)/.emacs: .emacs
	ln -sf $< $@
