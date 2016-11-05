(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

(package-initialize)
(require 'color-theme)

(if (display-graphic-p)
    (color-theme-solarized))
  
(nyan-mode 1)
(tool-bar-mode -1)

(global-linum-mode 1)

(set-face-attribute 'default nil :height 130)

(setq inhibit-startup-message t)

(add-hook 'rust-mode-hook 'cargo-minor-mode)

(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (cargo rust-mode nyan-mode jedi helm color-theme-solarized))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
