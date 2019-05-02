;; Emacs Core Settings
(global-linum-mode t)
(setq linum-format "%3d ")

(xterm-mouse-mode 1)
(unless window-system
     (global-set-key (kbd "<mouse-4>") 'scroll-down-line)
     (global-set-key (kbd "<mouse-5>") 'scroll-up-line))

(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time
(setq ns-use-mwheel-momentum nil)

(setq visible-cursor nil)

(setq gc-cons-threshold 50000000)
(setq gnutls-min-prime-bits 4096)

(setq-default indent-tabs-mode nil)
;; (setq tab-width 2)

(fset 'yes-or-no-p 'y-or-n-p)

(setq require-final-newline nil)

;; (setq-default indent-tabs-mode nil)
;; (setq-default tab-width 8)
;; (setq indent-line-function 'insert-tab)



;; Key Bindings
(global-set-key (kbd "C-s") nil)


;; Package Manager Setup
(require 'package)
(setq custom-file "~/.emacs.d/custom")
(load custom-file)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents
   (package-install 'use-package)))
(eval-when-compile
    (require 'use-package)
    (use-package use-package-ensure-system-package :ensure t)
    ;(setq use-package-compute-statistics t) ;; check load time of each package
    (require 'use-package-ensure)
    (setq use-package-always-ensure t))


;; Package Settings
(use-package evil
    :config
    (with-eval-after-load 'evil-maps (define-key evil-motion-state-map (kbd ";") 'evil-ex))
    (evil-mode 1)
    (use-package evil-commentary
        :config
        (evil-commentary-mode))
    (use-package evil-surround
        :config
        (global-evil-surround-mode 1))
    (use-package vimish-fold)
    (use-package evil-vimish-fold
      :config
      (evil-vimish-fold-mode 1))
    )
(use-package smartparens
  :config
  (setq sp-highlight-pair-overlay nil)
  (setq sp-show-pair-delay 0.05)
  (show-smartparens-global-mode t)
  (smartparens-global-mode t))
(use-package prettier-js
  :ensure-system-package (prettier . "npm i -g prettier"))
;; (use-package vimish-fold
;;     :config
;;     (global-set-key (kbd "<menu> v f") #'vimish-fold)
;;     (global-set-key (kbd "<menu> v v") #'vimish-fold-delete))
(use-package telephone-line
    :config
    (telephone-line-mode 1))
(use-package seoul256-theme
    :config
    (setq seoul256-background 235)
    (load-theme 'seoul256 t))
