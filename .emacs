(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#2d3743" "#ff4242" "#74af68" "#dbdb95" "#34cae2" "#008b8b" "#00ede1" "#e1e1e0"])
 '(custom-enabled-themes (quote (tango-dark)))
 '(ecb-options-version "2.40")
 '(menu-bar-mode nil)
 '(package-selected-packages
   (quote
    (cmake-mode elpy multiple-cursors ycmd tern-auto-complete rtags projectile nlinum hlinum highlight-symbol ggtags function-args flycheck-flow company-c-headers ac-js2)))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family : "DejaVu Sans Mono" :foundry "PfEd" :slant normal :weight normal :height 95 :width normal)))))


;;;;;;;;;; Proxy configuration

;(setq url-proxy-services
;	  '(("no_proxy" . "^\\(localhost\\|10.*\\)")
;		("http" . "10.144.1.10:8080")
;		("ftp" . "10.144.1.10:8080")))

;;;;;;;;;; Melpa packages repository

(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   '("melpa" . "http://melpa.org/packages/")
   t)
  (package-initialize))


;;;;;;;;;; Editor customization

(setq-default indent-tabs-mode nil)                      ;; spaces instead of tabs
(setq tab-width 4)                                       ;; 4 spaces as tab
(show-paren-mode t)                                      ;; highlight the parentheses
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))      ;; one line at a time    
(setq mouse-wheel-progressive-speed nil)                 ;; don't accelerate scrolling    
(setq mouse-wheel-follow-mouse 't)                       ;; scroll window under mouse    
(setq scroll-step 1)                                     ;; keyboard scroll one line at a time
(savehist-mode 1)                                        ;; save command-line history

;;;;;;;;;; Backup files storage

(setq backup-directory-alist '(("" . "~/.emacs.d/emacs-backup")))

;;;;;;;;;; C++ customization

(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))   ;; treat .h as C++
(setq-default c-basic-offset 4                           ;; tabs as 4 spaces
              tab-width 4
              indent-tabs-mode nil)
(setq c-default-style "linux" c-basic-offset 4)          ;; C mode

(global-set-key [f4] 'ff-find-other-file)                ;; easly switch between h and cpp
;(add-hook 'prog-mode-hook #'hs-minor-mode)               ;; mode for callapse and expand of blocks
(setq compilation-scroll-output 'first-error)            ;; scroll compilation window

;;;;;;;;;; Function args

;(add-hook 'prog-mode-hook #'function-args-mode)

;;;;;;;;;; GGTAGS

(add-hook 'c++-mode-hook #'ggtags-mode)
(add-hook 'c-mode-hook #'ggtags-mode)
;(add-hook 'prog-mode-hook #'company-mode)
;(global-set-key (kbd "C-'") 'company-capf)

;;;;;;;;;; JavaScript

(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))  ;; enable js2 major mode for js files
(add-hook 'js2-mode-hook 'auto-complete-mode)            ;; enable ac mode in js2 
(setq js2-highlight-level 3)                             ;; what this gives?

(require 'flycheck)                                      ;; online checking of js code
(add-hook 'js2-mode-hook (lambda () (flycheck-mode t)))
;(require 'flycheck-flow)                                 ;; add flow to flycheck

(add-hook 'js-mode-hook (lambda () (tern-mode t)))       ;; tags and auto completion
(eval-after-load 'tern
   '(progn
      (require 'tern-auto-complete)
      (tern-ac-setup)))

;;;;;;;;;; Highlight symbol under cursor

(require 'highlight-symbol)
(global-set-key [f3] 'highlight-symbol)
(global-set-key [(ctrl f3)] 'highlight-symbol-next)
(global-set-key [(shift f3)] 'highlight-symbol-prev)
(global-set-key [(meta f3)] 'highlight-symbol-query-replace)

;;;;;;;;;; Lines

(add-hook 'prog-mode-hook #'nlinum-mode)                 ;; enable line numbers only for programming
(require 'nlinum)
;(set-face-background 'linum-highlight-face "#3e4446")
;(set-face-foreground 'linum-highlight-face "#eeeeec")
;(linum-activate)                                        ;; highlight linum
;(setq linum-delay t)                                    ;; Delay updates to give Emacs a chance for other changes
;(setq scroll-conservatively 100)                        ;; scrolling to always be a line at a time
(setq nlinum-format "%5d ")                              ;; linum format
(add-hook 'prog-mode-hook (lambda ()
    (hl-line-mode t)                                     ;; highlight current line ON
    (set-face-background 'hl-line "#3e4446")             ;; background
    (set-face-foreground 'highlight nil)                 ;; foreground from syntax
))

;;;;;;;;;; Projectile

(projectile-global-mode)
(setq projectile-indexing-method 'alien)
(setq projectile-enable-caching t)
(setq projectile-globally-ignored-directories (append '(".svn") projectile-globally-ignored-directories))
(setq projectile-globally-ignored-files (append '("*.svn-base" "*.o" "*.pyc") projectile-globally-ignored-files))

;;;;;;;;;; ansi colored compilation buffer

(require 'ansi-color)
(defun colorize-compilation-buffer ()
  (toggle-read-only)
  (ansi-color-apply-on-region compilation-filter-start (point))
  (toggle-read-only))
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)

;;;;;;;;;; Visual search and replace

(require 'visual-regexp)
(define-key global-map (kbd "C-c r") 'vr/replace)
(define-key global-map (kbd "C-c q") 'vr/query-replace)


;;;;;;;;;; Multiple cursors

(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)     ;; When you have an active region that spans
                                                        ;; multiple lines, the following will add cursor
                                                        ;; each line
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c m") 'mc/mark-all-like-this)


;;;;;;;;;; Python
(elpy-enable)
(setq elpy-rpc-python-command "python3") 

