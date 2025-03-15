;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; remap leader key for Evil insert mode and Emacs state
;;
;; The Doom default binding is "M-SPC" but Xfce already uses that binding (to
;; show the "Window operation menu"). M-m is the Spacemacs binding.
(setq doom-leader-alt-key "M-m")

;; remap leader key for major mode
;;
;; This is a Spacemacs binding I find more convenient than "SPC m"
(setq doom-localleader-key ",")

(after! ace-window
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

(defun revilify-magit-dispatch-popup()
  (interactive)
  (dolist (change evil-collection-magit-popup-changes)
    (when (eq 'magit-dispatch (car change))
      (apply #'evil-collection-magit-change-popup-key change))))

(after! lsp-mode
  (setq lsp-signature-render-documentation nil
        lsp-enable-symbol-highlighting nil))

(map! "C-c ;" #'embark-act)

(use-package! term-cursor
  :config (unless (display-graphic-p) (global-term-cursor-mode)))

;; remap ":leader SPC" to M-x
;;
;; This is a Spacemacs binding I find more convenient than ":leader :".

(map! :leader
      "SPC" nil ;; disable the original binding to projectile-find-file
      :desc "M-x" "SPC" #'execute-extended-command)


(set-popup-rule! "^\\*pytest\\*" :modeline t)

;; The next line to remove modeline hdandling doesn't seem to do anything.
;;
;; It's from the official documentation on how to disable hiding the modeline in
;; popups:
;;
;;     https://docs.doomemacs.org/v21.12/#/configuration/disabling-hidden-mode-line-popups
;; (remove-hook '+popup-buffer-mode-hook #'+popup-set-modeline-on-enable-h)
;;
;; The next line does disable hiding the modeline, its from
;;
;;     https://github.com/doomemacs/doomemacs/issues/6209#issuecomment-1075148196
;;(advice-add 'hide-mode-line-mode :around (lambda (orig &optional args) nil))

(remove-hook '+popup-buffer-mode-hook #'+popup-set-modeline-on-enable-h)
