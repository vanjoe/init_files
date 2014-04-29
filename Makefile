

.phony:all
all: $(HOME)/.zshrc $(HOME)/.oh-my-zsh $(HOME)/.bashrc $(HOME)/.emacs.d  $(HOME)/.emacs

$(HOME)/.zshrc: .zshrc
	ln -s $^ $<

$(HOME)/.oh-my-zsh: /usr/bin/git
	curl -L http://install.ohmyz.sh | sh

$(HOME)/.bashrc: .bashrc
	ln -s $^ $<

$(HOME)/.emacs.d: .emacs.d
	ln -s $^ $<

$(HOME)/.emacs: .emacs
	ln -s $^ $<
