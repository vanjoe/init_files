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

;;hideshow mode
(add-hook 'c-mode-common-hook
  (lambda()
    (local-set-key (kbd "C-c <right>") 'hs-show-block)
    (local-set-key (kbd "C-c <left>")  'hs-hide-block)
    (local-set-key (kbd "C-c <up>")    'hs-hide-level)
    (local-set-key (kbd "C-c <down>")  'hs-show-all)
    (hs-minor-mode t)))

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

;;set color theme
(package-initialize)
(require 'color-theme)
(setq color-theme-is-global t)
(color-theme-initialize)
(color-theme-clarity)
(add-to-list 'default-frame-alist '(background-color . "grey15"))

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
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)
(require 'auto-complete-c-headers)
(add-to-list 'ac-sources 'ac-source-c-headers)

(require 'auto-complete-clang-async)
(setq ac-clang-flags
      (mapcar (lambda (item)(concat "-I" item))
              (split-string
               "
 /nfs/home/joel/Documents/vblox.pristine/software/lib/altdemo
 /nfs/home/joel/Documents/vblox.pristine/software/lib/bsp
 /nfs/home/joel/Documents/vblox.pristine/software/lib/libfixmath
 /nfs/home/joel/Documents/vblox.pristine/software/lib/scalar
 /nfs/home/joel/Documents/vblox.pristine/software/lib/vbxapi
 /nfs/home/joel/Documents/vblox.pristine/software/lib/vbxint
 /nfs/home/joel/Documents/vblox.pristine/software/lib/vbxlib
 /nfs/home/joel/Documents/vblox.pristine/software/lib/vbxsim
 /nfs/home/joel/Documents/vblox.pristine/software/lib/vbxtest
 /nfs/home/joel/Documents/vblox.pristine/software/lib/vbxware
 /usr/include/c++/4.6
 /usr/include/c++/4.6/x86_64-linux-gnu/.
 /usr/include/c++/4.6/backward
 /usr/lib/gcc/x86_64-linux-gnu/4.6/include
 /usr/local/include
 /usr/lib/gcc/x86_64-linux-gnu/4.6/include-fixed
 /usr/include/x86_64-linux-gnu
 /usr/include
 /usr/lib/gcc/x86_64-linux-gnu/4.6/include
 /usr/local/include
 /usr/lib/gcc/x86_64-linux-gnu/4.6/include-fixed
 /usr/include/x86_64-linux-gnu


"
               )))
(defun ac-cc-mode-setup ()
  (setq ac-clang-complete-executable "~/.emacs.d/clang-complete")
  (setq ac-sources '(ac-source-clang-async))
  (ac-clang-launch-completion-process)
)

(defun my-ac-config ()
  (add-hook 'c-mode-common-hook 'ac-cc-mode-setup)
  (add-hook 'auto-complete-mode-hook 'ac-common-setup)
  (global-auto-complete-mode t))
(my-ac-config)
(put 'upcase-region 'disabled nil)
;dont break hard links
(setq backup-by-copying-when-linked t)

;;case insensitive file name completion
(setq read-file-name-completion-ignore-case t)
(setq read-buffer-completion-ignore-case t)

