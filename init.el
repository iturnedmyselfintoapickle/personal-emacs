;;; Disabling annoying warning messages
(setq warning-minimum-level :error)

;;; Setting up package repos
(setq package-archives
	     '(("melpa" . "https://melpa.org/packages/")
	      ("org" . "https://orgmode.org/elpa")
	      ("elpa" . "https://elpa.gnu.org/packages/")))

;;; Bootstrapping use-package
(package-initialize)
(setq use-package-always-ensure t)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile (require 'use-package))
;; use if melpa is being stupid
;; (package-refresh-contents)

;; Setting global variables
(setq search-dir nil) ; This is the dir Rg and FZF will search

;; TRAMP Settings
(require 'tramp)
(add-to-list 'tramp-remote-path "/home/dh_3aqt9p/usr/bin")

;;; PACKAGES

;; UNDO
(use-package undo-fu)

;; which-key
(use-package which-key
  :config
  (which-key-mode t))

;; Vim Bindings
(use-package evil
	     :demand t
	     :bind (("<escape>" . keyboard-escape-quit))
	     :init
	     ;; allows for using cgn
	     ;; (setq evil-search-module 'evil-search)
	     (setq evil-want-keybinding nil)
	     ;; no vim insert bindings
	     (setq evil-undo-system 'undo-fu)
	     :config
	     (evil-mode 1))

;; Vim Bindings Everywhere Else
(use-package evil-collection
	     :after evil
	     :config
	     (setq evil-want-integration t)
	     (evil-collection-init))

;; Setting up Ivy
(use-package counsel :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) "))
;; Ivy Mode Key Buffers
(global-set-key (kbd "C-s") 'swiper-isearch)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> l") 'counsel-find-library)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
(global-set-key (kbd "<f2> j") 'counsel-set-variable)
(global-set-key (kbd "C-x b") 'ivy-switch-buffer)
(global-set-key (kbd "C-c v") 'ivy-push-view)
(global-set-key (kbd "C-c V") 'ivy-pop-view)

;; Ivy interface to system tools
(global-set-key (kbd "C-c k") 'counsel-rg-with-dir)
(global-set-key (kbd "C-c n") 'counsel-fzf-with-dir)

;; LSP
(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-l")
  :hook
  ((XXX-mode . lsp-deferred)
  (lsp-enable-which-key-integration t))
  :commands lsp lsp-deferred)

;; LSP Additions
(use-package lsp-ui :commands lsp-ui-mode)
;; (use-package helm-lsp :commands helm-lsp-workspace-symbol) 
(use-package dap-mode :after lsp-mode :config (dap-auto-configure-mode))
(use-package dap-java :ensure nil)
(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
;;(use-package lsp-treemacs :commands lsp-treemacs-errors-list)


;; Typescript LSP Support
(use-package typescript-mode
  :mode "\\.ts\\'"
  :hook (typescript-mode . lsp-deferred)
  :config
  (setq typescript-indent-level 2))

;; Java LSP Support
(use-package lsp-java :config (add-hook 'java-mode-hook 'lsp))

;; ALL-THE-ICONS
(use-package all-the-icons
  :if (display-graphic-p))

;; Gruvbox Theme
;;(use-package gruvbox-theme
;;  :config
;;  (load-theme 'gruvbox t))

;; Doom-One Theme
(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  ;;(load-theme 'doom-tokyo-night t)
  (load-theme 'doom-one t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-neotree-config)
  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

;;; Further Customization

;; Font
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8-unix)

(add-to-list 'default-frame-alist
	     '(font . "DejaVu Sans Mono-12"))

;; Org Mode Additions
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

;; When a TODO is set to a done state, record a timestamp
(setq org-agenda-files (list "~/Dropbox/org/")
 org-log-done 'time)

;; Follow the links
(setq org-return-follows-link  t)

;; Nicer-looking indentation
(add-hook 'org-mode-hook 'org-indent-mode)

;; Hide the markers so you just see bold text as BOLD-TEXT and not *BOLD-TEXT*
(setq org-hide-emphasis-markers t)

;; Basic TODO States
(setq org-todo-keywords
      '((sequence "TODO" "STARTED" "BLOCKED" "|" "DONE" "DROPPED")))

;; Follow links in Org with RET
(setq org-return-follows-link t)

;; Open Links in Same Window
(setf (cdr (assoc 'file org-link-frame-setup)) 'find-file)
;;(setf (cdr (rassoc 'find-file-other-window org-link-frame-setup)) 'find-file)

;; Wrap the lines in org mode so that things are easier to read
(add-hook 'org-mode-hook 'visual-line-mode)

;; When you want to change the level of an org item, use SMR
(define-key org-mode-map (kbd "C-c C-g C-r") 'org-shiftmetaright)

(defun set-search-dir (dir)
  (interactive "sEnter Directory Name: ")
  (setq search-dir dir))

(defun clear-search-dir ()
  (interactive)
  (setq search-dir nil))

(global-set-key (kbd "C-c d d") 'set-search-dir)
(global-set-key (kbd "C-c x x") 'clear-search-dir)

(defun counsel-rg-with-dir ()
  "Using RipGrep with a default directory set.
If none is set, use the directory of the current buffer."
  (interactive)
  (if search-dir
      (counsel-rg nil search-dir nil nil)
   (counsel-rg nil default-directory)))

(defun counsel-fzf-with-dir ()
  "Using FZF with a default directory set.
If none is set, use the directory of the current buffer."
  (interactive)
  (if search-dir
      (counsel-fzf nil search-dir nil)
   (counsel-fzf nil default-directory nil)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("7b8f5bbdc7c316ee62f271acf6bcd0e0b8a272fdffe908f8c920b0ba34871d98" default))
 '(package-selected-packages
   '(typescript-mode lsp-mode which-key use-package undo-fu gruvbox-theme evil-collection)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

