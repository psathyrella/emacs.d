(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
;; (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.2")
(require 'tls)
(push "/usr/local/etc/libressl/cert.pem" gnutls-trustfiles)

;;----------------------------------------------------------------------------------------
;; load separate init files
(defconst user-init-dir
  (cond ((boundp 'user-emacs-directory)
         user-emacs-directory)
        ((boundp 'user-init-directory)
         user-init-directory)
        (t "~/.emacs.d/")))

(defun load-user-file (file)
  (interactive "f")
  "Load a file in current user's configuration directory"
  (load-file (expand-file-name file user-init-dir)))

(load-user-file "functions.el")

;; not sure what this was for. does shit break when I comment it?
;; (add-to-list 'load-path "~/.emacs.d/")
;;(add-to-list `load-path "~/.emacs.d/vlfi")

;; ;; edit server for chrome extension (NOTE doesn't seem to work without xemacs)
;; (add-to-list 'load-path "~/.emacs.d/edit-server")
;; (require 'edit-server)
;; (edit-server-start)

(require 'package)
;;(require 'ess-site)
(add-to-list 'package-archives
	     '("melpa-stable" . "https://stable.melpa.org/packages/"))
;; (add-to-list 'package-archives
;;              '("melpa" . "http://melpa.milkbox.net/packages/") t)
;; (add-to-list 'package-archives
;;              '("melpa" . "http://melpa.org/packages/") t)
;; '(package-archives   '(("gnu" . "http://elpa.gnu.org/packages/")     ("melpa" . "http://www.mirrorservice.org/sites/stable.melpa.org/packages/")))
;; (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; don't load this unless I'm actually using it
;;(load "~/.emacs.d/floobits/floobits.el")

;;----------------------------------------------------------------------------------------
;; these were in the default init.el, not sure what they do, really
(when (fboundp 'global-font-lock-mode) ;; turn on font-lock mode
  (global-font-lock-mode t))
(setq transient-mark-mode t) ;; enable visual feedback on selections
(setq same-window-regexps '(".")) ;; stop popping up all these stupid new windows
(setq frame-title-format ;; default to better frame titles
      (concat  "%b - emacs@" (system-name)))

;; ----------------------------------------------------------------------------------------
(setq diff-switches "-u") ;; default to unified diffs

;; ----------------------------------------------------------------------------------------
;; gloabl key bindings
(global-unset-key (kbd "C-x o")) ;; only want to use the ones below for window switching

;; window movements
(global-unset-key (kbd "M-h"))
(global-set-key (kbd "M-h") 'windmove-left)  ;; NOTE this used to be "M-[" (well, also used to be slightly different fcn call), but if you set _anything_ to "M-[", the middle-mouse-button pasting breaks (pastes extra characters). I think this also resolved the extra special characters on opening some files? but not sure)
(global-set-key (kbd "M-l") 'windmove-right)
(global-set-key (kbd "M-j") 'windmove-down)
(global-set-key (kbd "M-k") 'windmove-up)

;;----------------------------------------------------------------------------------------
(defvar my-keys-minor-mode-map (make-keymap) "my-keys-minor-mode keymap.")

(define-key my-keys-minor-mode-map (kbd "C-c C-c") 'comment-or-uncomment-region)
(define-key my-keys-minor-mode-map (kbd "C-c -") 'insert-dashed-comment-line)
(define-key my-keys-minor-mode-map (kbd "C-c C-p") 'move-ten-lines-up)
(define-key my-keys-minor-mode-map (kbd "C-c C-n") 'move-ten-lines-down)
(define-key my-keys-minor-mode-map (kbd "C-c C-c") 'comment-or-uncomment-region)
(define-key my-keys-minor-mode-map (kbd "C-c u") 'kill-line-backward)
(define-key my-keys-minor-mode-map (kbd "C-c q") 'query-replace-regexp)
(define-key my-keys-minor-mode-map (kbd "C-?") 'backward-delete-char)
(define-key my-keys-minor-mode-map (kbd "C-h") 'backward-delete-char)
(define-key my-keys-minor-mode-map (kbd "C-M-h") 'backward-kill-word)
(define-key my-keys-minor-mode-map (kbd "C-c g") 'toggle-truncate-lines)
(define-key my-keys-minor-mode-map (kbd "C-c r") 'string-insert-rectangle)
(define-key my-keys-minor-mode-map (kbd "C-c d") 'ediff-buffers)
(define-key my-keys-minor-mode-map (kbd "C-c s") 'magit-status)
(define-key my-keys-minor-mode-map (kbd "C-x g") 'keyboard-quit)

(define-minor-mode my-keys-minor-mode
  "A minor mode so that my key settings override annoying major modes."
  t " my-keys" 'my-keys-minor-mode-map)

(my-keys-minor-mode 1)

;;----------------------------------------------------------------------------------------
;; mode-specific things
(add-hook 'c++-mode-hook (lambda ()
			   (local-set-key (kbd "\C-cw")  'insert-setw)
			   (local-set-key (kbd "\C-c\C-e") 'insert-cendl)
			   ))

(add-hook 'git-commit-mode-hook (lambda ()
			     (local-set-key (kbd "C-c c")    'git-commit-commit)
			     ))

(add-hook 'diff-mode-hook (lambda ()
			     (local-set-key (kbd "C-c h")    'magit-refine-next-hunk)
			     ))

(add-hook 'magit-mode-hook (lambda ()
			     (local-set-key (kbd "C-c h")    'magit-refine-next-hunk)
			     ))

(add-hook 'emacs-lisp-mode-hook (lambda()
			     (local-set-key (kbd "C-c e")    'eval-buffer)
			     ))

(add-hook 'latex-mode-hook (lambda()
			     (flyspell-mode)
			     (local-unset-key (kbd "\C-cj"))
			     (local-unset-key (kbd "\C-c\C-p"))
			     (local-set-key (kbd "\C-ci") 'insert-itemize)
			     (local-set-key (kbd "\C-cc") 'insert-columns)
			     (local-set-key (kbd "\C-ce") 'insert-center)
			     (local-set-key (kbd "\C-cf") 'insert-frame)
			     (local-set-key (kbd "\C-cl") 'insert-beamer-url)
			     (local-set-key (kbd "\C-co") 'insert-beamer-color)
			     (local-set-key (kbd "\C-cj") 'electric-newline-and-maybe-indent)
			     ))

;; ;;----------------------------------------------------------------------------------------
(setq make-backup-files nil)
;; ;; backup settings. this is actually kinda silly since I really just use dropbox and git
;; (setq auto-save-default t)
;; (setq backup-directory-alist `(("." . "~/.emacs.d/backups"))) ;; put all backup files in one directory
;; (setq make-backup-files t               ; backup of a file the first time it is saved.
;;       backup-by-copying t               ; don't clobber symlinks
;;       version-control t                 ; version numbers for backup files
;;       delete-old-versions t             ; delete excess backup files silently
;;       delete-by-moving-to-trash t
;;       kept-old-versions 6               ; oldest versions to keep when a new numbered backup is made (default: 2)
;;       kept-new-versions 9               ; newest versions to keep when a new numbered backup is made (default: 2)
;;       auto-save-default t               ; auto-save every buffer that visits a file
;;       auto-save-timeout 20              ; number of seconds idle time before auto-save (default: 30)
;;       auto-save-interval 200            ; number of keystrokes between auto-saves (default: 300)
;;       )

;;----------------------------------------------------------------------------------------
;;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(case-fold-search t)
 '(line-number-display-limit-width 10000)
 '(menu-bar-mode nil)
 '(package-selected-packages
   '(magit dash yaml-mode transient markdown-mode git-commit floobits))
 '(truncate-lines t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(diff-refine-added ((t (:inherit diff-refine-changed :background "unspecified"))))
 '(diff-refine-changed ((t (:background "unspecified" :inverse-video t))))
 '(diff-refine-removed ((t (:inherit diff-refine-changed :background "unspecified"))))
 '(ediff-current-diff-B ((t (:background "yellow3" :foreground "black" :weight bold))))
 '(ediff-fine-diff-A ((t (:background "white" :foreground "black" :weight bold))))
 '(ediff-fine-diff-B ((t (:background "white" :foreground "black"))))
 '(font-lock-comment-face ((nil (:foreground "red"))))
 '(font-lock-string-face ((t (:foreground "green"))))
 '(magit-diff-added ((t (:foreground "#335533"))))
 '(magit-diff-added-highlight ((t (:foreground "green"))))
 '(magit-diff-base ((t (:foreground "#ffffcc"))))
 '(magit-diff-base-highlight ((t (:foreground "#eeeebb"))))
 '(magit-diff-context-highlight ((t (:extend t :background "unspecified" :foreground "green"))))
 '(magit-diff-file-heading-highlight ((t nil)))
 '(magit-diff-hunk-heading ((t (:background "grey25" :foreground "blue" :weight bold))))
 '(magit-diff-hunk-heading-highlight ((t (:background "grey35" :foreground "blue" :weight bold))))
 '(magit-diff-none ((t nil)))
 '(magit-diff-removed ((t (:foreground "red"))))
 '(magit-diff-removed-highlight ((t (:foreground "red"))))
 '(magit-item-highlight ((t (:background "black" :foreground "white"))))
 '(magit-section-highlight ((t (:extend t :background "black"))))
 '(minibuffer-prompt ((t (:foreground "cyan")))))

;; had this earlier but it seemed to get overwritten by something else
(setq auto-mode-alist (cons '("\\.h$" .   c++-mode)  auto-mode-alist))
(setq auto-mode-alist (cons '("\\.txt$" .   markdown-mode)  auto-mode-alist))  ;; used to be conf-mode
(setq auto-mode-alist (cons '("SConstruct" .   python-mode)  auto-mode-alist))
(setq auto-mode-alist (cons '("SConscript" .   python-mode)  auto-mode-alist))
(setq-default major-mode 'conf-mode) ;; make conf-mode the default mode
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(setq-default indent-tabs-mode nil)
