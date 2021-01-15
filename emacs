;;===================
;;  Global Settings
;;===================

;; Minor modes
(savehist-mode t)
(show-paren-mode t)
(column-number-mode t)
(delete-selection-mode t)
(if window-system (tool-bar-mode 0))

;; Variables
(setq inhibit-startup-message t)
(setq initial-scratch-message "")
(setq-default indicate-empty-lines t)
(setq-default indent-tabs-mode nil)
(setq-default show-trailing-whitespace t)
(setq-default make-backup-files nil)
(setq scroll-conservatively 1000)
(setq mouse-wheel-scroll-amount (quote (1)))
(setq require-final-newline 'visit-save)
(setq-default fill-column 80)

(set-variable 'sentence-end "\\. ")
(put 'downcase-region 'disabled nil)

;; InteractivelyDoThings
(ido-mode t)
(ido-everywhere t)
(setq ido-enable-flex-matching t)

;; Browse kill ring (M-y)
(require 'browse-kill-ring)
(browse-kill-ring-default-keybindings)
(setq browse-kill-ring-highlight-current-entry t)
(setq browse-kill-ring-highlight-inserted-item t)
(setq browse-kill-ring-show-preview t)

;; Unique buffer names
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

;; Better expand
(global-set-key (kbd "M-/") 'hippie-expand)
(add-to-list 'hippie-expand-try-functions-list 'ispell-complete-word t)

;; Paths
(setq abbrev-file-name "~/.emacs.d/abbrev")
(setq desktop-path '("~/.emacs.d"))
(setq desktop-base-file-name "desktop")

;;==========================
;;  Mode-Specific Settings
;;==========================

;; C code indentation style
(setq c-default-style "linux"
      c-basic-offset 4)

;; Org-mode
;(global-set-key "\C-cl" 'org-store-link)
;(global-set-key "\C-ca" 'org-agenda)
;(global-set-key "\C-cb" 'org-iswitchb)
(setq org-agenda-files (list "~/notes/todo.org"))
(setq org-enforce-todo-checkbox-dependencies t)
(setq org-enforce-todo-dependencies t)
(setq org-log-states-order-reversed nil)
(setq org-log-into-drawer t)
(setq org-log-done 'time)
(setq org-log-done-with-time nil)
(setq org-src-fontify-natively t)
(setq org-src-tab-acts-natively t)
(setq org-latex-listings t)

; allow both single and double quotes in the border
(require 'org)
(setf (nth 2 org-emphasis-regexp-components) " \t\r\n,")

; define a new onlyenv environment with shortcut O
(require 'ox-beamer)
(add-to-list 'org-beamer-environments-extra
             '("onlyenv" "O" "\\begin{onlyenv}%a" "\\end{onlyenv}"))

(add-hook 'org-mode-hook
          (lambda ()
            (local-set-key "\M-\C-n" 'outline-next-visible-heading)
            (local-set-key "\M-\C-p" 'outline-previous-visible-heading)
            (local-set-key "\M-\C-f" 'outline-forward-same-level)
            (local-set-key "\M-\C-b" 'outline-backward-same-level)
            (local-set-key "\M-\C-u" 'outline-up-heading)
            ;; table
            (local-set-key "\M-\C-w" 'org-table-copy-region)
            (local-set-key "\M-\C-y" 'org-table-paste-rectangle)
            (local-set-key "\M-\C-l" 'org-table-sort-lines)
            ;; display images
            (local-set-key "\M-I" 'org-toggle-iimage-in-org)))

;; All text-mode-based modes
(add-hook 'text-mode-hook (lambda ()
                            (turn-on-auto-fill)
                            (text-mode-hook-identify)
                            (flyspell-mode t)
                            (abbrev-mode t)
                            ))

;; LaTeX (auctex)
(add-hook 'LaTeX-mode-hook (lambda ()
                             (turn-on-reftex)
                             (TeX-fold-mode)
                             (LaTeX-math-mode)
                             (TeX-PDF-mode)
                             ;; (TeX-source-correlate-mode)
                             ))
(setq TeX-view-program-list '(("Evince" "evince --page-label=%(outpage) %o")))
(setq TeX-view-program-selection '((output-pdf "Evince")))
;;(setq TeX-source-correlate-start-server t)

;; Use cleveref
(defun reftex-format-cref (label def-fmt)
  (format "\\cref{%s}" label))
(setq reftex-format-ref-function 'reftex-format-cref)

;; Fill sentences in latex documents. Line per sentence.
(defun auto-fill-by-sentences ()
  (if (looking-back (sentence-end))
      ;; Break at a sentence
      (progn
        (LaTeX-newline)
        t)
    ;; Fall back to the default
    (do-auto-fill)))
(add-hook 'LaTeX-mode-hook (lambda () (setq auto-fill-function 'auto-fill-by-sentences)))

(defadvice LaTeX-fill-region-as-paragraph (around LaTeX-sentence-filling)
  "Start each sentence on a new line."
  (let ((from (ad-get-arg 0))
        (to-marker (set-marker (make-marker) (ad-get-arg 1)))
        tmp-end)
    (while (< from (marker-position to-marker))
      (forward-sentence)
      ;; might have gone beyond to-marker --- use whichever is smaller:
      (ad-set-arg 1 (setq tmp-end (min (point) (marker-position to-marker))))
      ad-do-it
      (ad-set-arg 0 (setq from (point)))
      (unless (or
               (bolp)
               (looking-at "\\s *$"))
        (LaTeX-newline)))
    (set-marker to-marker nil)))
(ad-activate 'LaTeX-fill-region-as-paragraph)

;; VHDL-mode
(setq vhdl-clock-edge-condition (quote function))
(setq vhdl-standard (quote (93 nil)))

;; Associate .md files with markdown-mode
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; Haskell-mode
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)

;;=======================
;;  Global Key Bindings
;;=======================

;; Alt-<arrow> moves between windows
(windmove-default-keybindings 'meta)

;; Use Ibuffer for Buffer List
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; Use Scroll-Lock key to toggle scroll-lock-mode
(global-set-key (quote [Scroll_Lock]) 'scroll-lock-mode)

;; Single-line scrolling without moving the point
(global-set-key [(control down)] (lambda () (interactive) (scroll-up   1)) )
(global-set-key [(control up  )] (lambda () (interactive) (scroll-down 1)) )

;;====================
;;  Clipboard Tweaks
;;====================

;; Stops selection with a mouse being immediately injected to the kill ring
(setq mouse-drag-copy-region nil)
;; Stops killing/yanking interacting with primary X11 selection
(setq x-select-enable-primary nil)
;; Makes killing/yanking interact with clipboard X11 selection
(setq x-select-enable-clipboard t)
;; Active region sets primary X11 selection
(setq select-active-regions t)
;; Make mouse middle-click only paste from primary X11 selection, not
;; clipboard and kill ring.
(global-set-key [mouse-2] 'mouse-yank-primary)

;;========================
;;  Compatibility Tweaks
;;========================

;; Fix keys in screen
(global-set-key [select] 'end-of-line-nomark)

(mapc (lambda (map)
        (define-key function-key-map
          (read-kbd-macro (cadr map))
          (read-kbd-macro (car map))))
      '(("<S-up>"       "ESC [1;2A")
        ("<S-down>"     "ESC [1;2B")
        ("<S-right>"    "ESC [1;2C")
        ("<S-left>"     "ESC [1;2D")

        ("<M-up>"       "ESC [1;3A")
        ("<M-down>"     "ESC [1;3B")
        ("<M-right>"    "ESC [1;3C")
        ("<M-left>"     "ESC [1;3D")

        ("<M-S-up>"     "ESC [1;4A")
        ("<M-S-down>"   "ESC [1;4B")
        ("<M-S-right>"  "ESC [1;4C")
        ("<M-S-left>"   "ESC [1;4D")

        ("<C-up>"       "ESC [1;5A")
        ("<C-down>"     "ESC [1;5B")
        ("<C-right>"    "ESC [1;5C")
        ("<C-left>"     "ESC [1;5D")

        ("<C-S-up"      "ESC [1;6A")
        ("<C-S-down"    "ESC [1;6B")
        ("<C-S-right>"  "ESC [1;6C")
        ("<C-S-left>"   "ESC [1;6D")

        ("<C-home>"     "ESC [1;5H")
        ("<C-end>"      "ESC [1;5F")

        ("<S-home>"     "ESC [1;2H")
        ("<S-end>"      "ESC [1;2F")

        ("<C-S-home>"   "ESC [1;6H")
        ("<C-S-end>"    "ESC [1;6F")
        ))

;;=====================
;;  Third-Party Modes
;;=====================

;; Undo Tree
;;   http://www.dr-qubit.org/emacs.php#undo-tree
(require 'undo-tree)
(global-undo-tree-mode)

;;========================
;;  Third-Party Packages
;;========================

;; Package repositories
(package-initialize)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(load-theme 'zenburn t)

;; web-mode
(setq standard-indent 2)
(setq web-mode-enable-current-element-highlight t)
(setq web-mode-enable-current-column-highlight t)
