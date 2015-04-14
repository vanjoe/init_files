;;
;; COPYRIGHT (C) 2013, 2014 Joel Vandergriendt
;;
(add-to-list 'load-path "~/.emacs.d")
(add-to-list 'load-path "~/.emacs.d/elpa")
(setq inhibit-startup-message t)


;; Save all tempfiles in $TMPDIR/emacs$UID/
(defconst emacs-tmp-dir (format "%s/%s%s/" temporary-file-directory "emacs" (user-uid)))
(setq backup-directory-alist
      `((".*" . ,emacs-tmp-dir)))
(setq auto-save-file-name-transforms
      `((".*" ,emacs-tmp-dir t)))
(setq auto-save-list-file-prefix
      emacs-tmp-dir)

;;disable toolbar
(tool-bar-mode -1)
;;remove scroll bar
(scroll-bar-mode -1)

;;set color theme
(package-initialize)
(require 'color-theme)
(setq color-theme-is-global t)
(color-theme-initialize)
(color-theme-clarity)
(add-to-list 'default-frame-alist '(background-color . "grey15"))

;;hideshow mode

(defun add-hs-mode()
  (local-set-key (kbd "C-c <right>") 'hs-show-block)
  (local-set-key (kbd "C-c <left>")  'hs-hide-block)
  (local-set-key (kbd "C-c <up>")    'hs-hide-level)
  (local-set-key (kbd "C-c <down>")  'hs-show-all)
  (hs-minor-mode t)
)
(add-hook 'c-mode-common-hook 'add-hs-mode)
(add-hook 'python-mode-hook 'add-hs-mode)

;;show matching parthenthesis
(show-paren-mode 1)

;;show line numbers
(global-linum-mode t)




;; http://www.emacswiki.org/emacs/SmartTabs
(autoload 'smart-tabs-mode "smart-tabs-mode"
  "Intelligently indent with tabs, align with spaces!")
(autoload 'smart-tabs-mode-enable "smart-tabs-mode")
(autoload 'smart-tabs-advice "smart-tabs-mode")
(autoload 'smart-tabs-insinuate "smart-tabs-mode")

(smart-tabs-insinuate 'c 'c++ 'java 'javascript 'cperl 'python 'ruby )
(setq-default tab-width 3)


(when (display-graphic-p)
    (lambda (global-hl-line-mode t)))


(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;;save history over sessions
(savehist-mode 1)

;;delete trailing whitespace on Save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
  )

;;recompile keybinding
(global-set-key [f5] 'recompile)
(setq compilation-ask-about-save nil)
(setq compilation-scroll-output 'first-error)
;;smoother scrolling
;;http://www.emacswiki.org/emacs/download/smooth-scroll.el
(require 'smooth-scroll)
(smooth-scroll-mode t)
;;smaller font
;(set-face-attribute 'default nil :height 100)

(defun kill-other-buffers ()
    "Kill all other buffers."
    (interactive)
    (mapc 'kill-buffer
          (delq (current-buffer)
                (remove-if-not 'buffer-file-name (buffer-list)))))

;;enable downcase region command

(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
;dont break hard links
(setq backup-by-copying-when-linked t)

;;case insensitive file name completion
(setq read-file-name-completion-ignore-case t)
(setq read-buffer-completion-ignore-case t)
;rebind C-x d from some dired thing to delete region
(global-unset-key "\C-x d")
(global-set-key (kbd "C-x d") 'delete-region)

(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

(defun add-c-header-guard ()
  (interactive)
  (if (buffer-file-name)
		(let*
			 ((fName (file-name-nondirectory (file-name-sans-extension buffer-file-name)))
			  (guard (upcase (concat fName "_" (file-name-nondirectory (file-name-extension buffer-file-name)))))
			  (ifDef (concat "#ifndef " guard "\n#define " guard "\n"))
			  (begin (point-marker))
			  )
		  (progn
			 ;;Insert the Header Guard
			 (goto-char (point-min))
			 (insert ifDef)
			 (goto-char (point-max))
			 (insert "\n#endif" " //" guard)
			 (goto-char begin))
		  )
	 ;;else
	 (message (concat "Buffer " (buffer-name) " must have a filename"))
	 )
  )



(defun surround (begin end )
  "Put OPEN at START and CLOSE at END of the region.
If you omit CLOSE, it will reuse OPEN."
  (interactive  "")
  (save-excursion
    (goto-char end)
    (insert "hello")
    (goto-char begin)
    (insert "goodbye")))

;;add upto as keyword to c++ mode
(font-lock-add-keywords 'c++-mode
  '(("upto" . font-lock-keyword-face)))

;; use Shift+arrow_keys to move cursor around split panes
(windmove-default-keybindings)
;; when cursor is on edge, move to the other side, as in a toroidal space
(setq windmove-wrap-around t )

(require 'tablegen-mode)
