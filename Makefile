
LN=ln 
RM=rm -f
.phony:all
all: $(HOME)/.zshrc $(HOME)/.oh-my-zsh $(HOME)/.bashrc $(HOME)/.emacs.d  $(HOME)/.emacs

$(HOME)/.zshrc: .zshrc
	$(RM) $@
	$(LN) $< $@

$(HOME)/.oh-my-zsh: /usr/bin/git
	curl -L http://install.ohmyz.sh | sh

$(HOME)/.bashrc: .bashrc
	$(RM) $@	
	$(LN) $< $@	

$(HOME)/.emacs.d: .emacs.d
	$(RM) $@	
	$(LN) $< $@

$(HOME)/.emacs: .emacs
	$(RM) $@	
	$(LN) $< $@
