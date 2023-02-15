;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Kevin Rathbun"
      user-mail-address "kdrath@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
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

;; https://tecosaur.github.io/emacs-config/config.html
(setq doom-font (font-spec :family "Fira Code" :size 14)
      doom-big-font (font-spec :family "Fira Code" :size 36)
      doom-variable-pitch-font (font-spec :family "Overpass" :size 14))
;; https://github.com/tonsky/FiraCode/wiki/Emacs-instructions
; enable fira code ligatures
(mac-auto-operator-composition-mode)

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-moonlight)

;; start in fullscreen
(add-hook 'window-setup-hook #'toggle-frame-fullscreen)

;; SCHEME
(setq geiser-chez-binary "chez")
(setq geiser-default-implementation 'chez)

;; PROLOG
;;
;; use prolog instead of perl for .pl files
(add-to-list 'auto-mode-alist '("\\.\\(pl\\|pro\\|lgt\\)" . prolog-mode))

;; https://github.com/jamesnvc/lsp_server
(after! lsp-mode
  (lsp-register-client
   (make-lsp-client
    :new-connection
    (lsp-stdio-connection (list "swipl"
                                "-g" "use_module(library(lsp_server))."
                                "-g" "lsp_server:main"
                                "-t" "halt"
                                "--" "stdio"))
    :major-modes '(prolog-mode)
    :priority 1
    :multi-root t
    :server-id 'prolog-ls)))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
;; (setq display-line-numbers-type t)
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
;; (setq org-directory "~/org/")
;; could move this to Documents for cloud backup
(setq org-directory "/Volumes/dev/org/")

;; ELIDE COMMENTS
;; cribbed from hideshow.el
;; used to elide excessive comments in crafting interpreters java source
(defun comments-fold ()
  "comment"
  (interactive)
  (goto-char (point-min))
  (while (comment-search-forward (point-max) t)
    (let ((c-reg (hs-inside-comment-p)))
      (when (and c-reg (car c-reg))
        (hs-make-overlay (car c-reg) (cadr c-reg) 'comment)))))

;; someone reported simply doing this:
;; (if (eq system-type 'darwin) (add-hook 'c++-mode-hook (setq +cc-default-compiler-options "-isystem"))
;; henrik said it should actually be this:
;; (setf (alist-get 'c++-mode +cc-default-compiler-options) '("-std=c++1z" "-isystem/path/to/your/system/libs" ...))
(after! ccls
  (setq ccls-initialization-options
        '(:clang (:extraArgs ["-isystem/Library/Developer/CommandLineTools/usr/include/c++/v1"
                              "-isystem/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include"
                              "-isystem/usr/local/include"
                              "-isystem/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/11.0.0/include"
                              "-isystem/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include"
                              "-isystem/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include"
                              "-isystem/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks"]
                  :resourceDir "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/11.0.0"))))

;; (setq rustic-lsp-server 'rust-analyzer
;;       lsp-rust-server 'rust-analyzer)
;; (after! lsp-rust
;;   (set-lsp-priority! 'rust-analyzer 1))
;; (after! rustic
;;   (setq rustic-lsp-server 'rust-analzyer))
(setq rustic-lsp-server 'rust-analzyer)

;; would use this with 'recenter-position' usually bound to C-l but using 'zt' instead
;; (setq recenter-positions '(top middle bottom))

(add-hook 'persp-before-deactivate-functions #'deactivate-mark)

(add-hook 'clojure-mode-hook #'subword-mode) ; CamelCase support for editing Java names

(add-hook 'cider-mode-hook #'eldoc-mode)
(add-hook 'cider-repl-mode-hook #'eldoc-mode)

(add-hook 'cider-mode-hook #'company-mode)
(add-hook 'cider-repl-mode-hook #'company-mode)

;; skip warning when using gD to find all references
(setq cljr-warn-on-eval nil)

;; supports navigating to sources from stack trace
(setq cider-jdk-src-paths '("/Volumes/dev/java/adoptopenjdk-13.jdk"
                            "/Volumes/dev/clojure/sources/1.10.1"))

;; comment to see if this fixes indentation issues in repl after an exception
;; (add-hook 'cider-repl-mode-hook #'aggressive-indent-mode)

(setq cider-dynamic-indentation nil)

(setq cider-repl-pop-to-buffer-on-connect t)

;; When there's a cider error, show its buffer and switch to it
(setq cider-show-error-buffer t)
(setq cider-auto-select-error-buffer t)

(setq cider-repl-history-file (concat doom-cache-dir "cider-history"))
(setq cider-repl-wrap-history t)

(setq clojure-toplevel-inside-comment-form t)

(setq initial-major-mode 'emacs-lisp-mode)

(setq company-idle-delay 1.0) ;; was 0.5

;; not working as expected
;;(setq projectile-project-search-path (doom-files-in "/Volumes/dev" :depth 1 :type 'dirs :full t))

;; not working as expected
;;(setq projectile-globally-ignored-directories
;;      (append '(".DocumentRevisions-V100/") projectile-globally-ignored-directories))

;; to build pdf-tools
(setenv "PKG_CONFIG_PATH" "/usr/local/lib/pkgconfig:/usr/local/Cellar/libffi/3.2.1/lib/pkgconfig")

;; for pdf-tools on retina
(setq pdf-view-use-scaling t)
(setq-default pdf-view-display-size 'fit-width)

(setq confirm-kill-emacs nil)

;; startup size
(pushnew! initial-frame-alist
          '(width . 106)
          '(height . 64)
          '(left . 0)
          '(top . 0))

;; any of f/F/t/T/s/S will repeat the last search (after an initial one)
(after! evil-snipe (setq evil-snipe-repeat-keys t))

(display-time-mode t)

;; C-o will show a list of available actions in a hydra
(setq ivy-read-action-function #'ivy-hydra-read-action)

(defun +toggle-lsp-eldoc-enable-hover ()
  "Toggle lsp-eldoc-enable-hover"
  (interactive)
  (setq lsp-eldoc-enable-hover (unless lsp-eldoc-enable-hover t))
  (message "LSP eldoc enable hover %s"
           (if lsp-eldoc-enable-hover "enabled" "disabled")))

(defun +toggle-lsp-ui-sideline-show-hover ()
  "Toggle lsp-ui-sideline-show-hover"
  (interactive)
  (setq lsp-ui-sideline-show-hover (unless lsp-ui-sideline-show-hover t))
  (message "LSP ui sideline show hover %s"
           (if lsp-ui-sideline-show-hover "enabled" "disabled")))

;; with SPC SPC counsel-projectile-find-file has sorting disabled, which stuffs
;; up prescient's ordering, this is fix
(setq counsel-projectile-sort-files t)

;; fuzzy completion
(after! sly
  (setq sly-complete-symbol-function 'sly-flex-completions))

(setq mac-command-modifier 'super)
(setq mac-option-modifier  'meta)

(map! "s-q" nil)
(map! "s-w" nil)

(setq which-key-max-description-length 35)

;; ~/.emacs.d/.local/straight/repos/sly/contrib/sly-trace-dialog.el
;; (defvar sly-trace-dialog-mode-map
;;     (define-key map (kbd "G") 'sly-trace-dialog-fetch-traces)

;; map this to something else to keep consistent evil bindings
;; across buffers
;; (map!
;;  :after sly-trace-dialog
;;  :map evil-motion-state-map
;;  "G" nil
;;  :map sly-trace-dialog-mode-map
;;  "G" 'sly-trace-dialog-fetch-traces)

;; this doesn't work, the error buffer replaces the repl buffer
;; (after! cider (set-popup-rule! "^\\*cider-error*" :select nil))

;; (map!
;;  (:after clj-refactor
;;    :leader "r" clj-refactor-map))
;; (cljr-add-keybindings-with-prefix "r")

;; should this be inside of def-package! without the :after
;; (def-package! smartparens
;;  :config
;; or inside after!
;; (after! smartparens)

;; was working with (after! evil (define-key evil-normal-state-map (kbd "C-t") nil))

(map! :n "C-t" nil
      :n "C-h" #'evil-window-left
      :n "C-j" #'evil-window-down
      :n "C-k" #'evil-window-up
      :n "C-l" #'evil-window-right

      :m "gl" #'open-line)

;; may need an :after lsp here
;; not working, says lsp-ui-menu not a command
;; :leader
;; (:prefix "c"
;; :n "i" #'lsp-ui-imenu))

(map!
 (:after smartparens
  :leader
  :map smartparens-mode-map
  :prefix "r"
  :n "a"     #'sp-beginning-of-sexp
  :n "e"     #'sp-end-of-sexp

  :n "d"     #'sp-down-sexp
  ;; :n "bd"    #'sp-backward-down-sexp ; not very useful
  :n "]"     #'sp-up-sexp
  :n "["     #'sp-backward-up-sexp

  ;; :n "f"     #'sp-forward-sexp ; not so useful
  :n "p"     #'sp-backward-sexp

  :n "n"     #'sp-next-sexp ; useful with =.= repeater
  ;; :n "p"     #'sp-previous-sexp ; not so useful

  :n "m"     #'sp-forward-symbol
  ;; :n "bm"    #'sp-backward-symbol

  :n "s"     #'sp-forward-slurp-sexp
  :n "b"     #'sp-forward-barf-sexp
  ;; :n "bs"    #'sp-backward-slurp-sexp
  ;; :n "bf"    #'sp-backward-barf-sexp

  :n "t"     #'sp-transpose-sexp
  :n "k"     #'sp-kill-sexp
  :n "hk"    #'sp-kill-hybrid-sexp
  ;; :n "bk"    #'sp-backward-kill-sexp
  :n "c"     #'sp-copy-sexp
  ;; :n "l"     #'delete-sexp ;; getting wrong type argument

  ;; :n "bwk"   #'sp-backward-kill-word ;; just use M-DEL

  :n "u"     #'sp-unwrap-sexp
  ;; :n "bu"    #'sp-backward-unwrap-sexp

  ;; :n "o"     #'sp-transpose-hybrid-sexp ; not sure how to use

  :n "w"     #'sp-wrap-round
  :n "y"     #'sp-wrap-curly
  :n "r"     #'sp-wrap-square))

;; https://www.eigenbahn.com/2020/05/06/fast-clojure-deps-auto-reload
(defun prf/cider/send-to-repl (sexp &optional eval ns)
  "Send SEXP to Cider Repl. If EVAL is t, evaluate it.
   Optionally, we can change namespace by specifying NS."
  (cider-switch-to-repl-buffer ns)
  (goto-char cider-repl-input-start-mark)
  (delete-region (point) (point-max))
  (save-excursion
    (insert sexp)
    (when (equal (char-before) ?\n)
      (delete-char -1)))
  (when eval
    (cider-repl--send-input t)))

(defun prf/clj/pomegranate-dep (dep)
  "Format a Clojure Pomegranate dependency import for DEP."
  (concat
   (format
    "%s"
    ;; NB: this is clojure!
    `(use '[cemerick.pomegranate :only (add-dependencies)]))
   (s-replace-all
    `(("\\." . ".")
      ("mydep" . ,dep))
    (format
     "%S"
     ;; NB: this is clojure!
     `(add-dependencies :coordinates '[mydep]
                        :repositories (merge cemerick.pomegranate.aether/maven-central
                                             {"clojars" "https://clojars.org/repo"}))))))

(defun prf/cider/inject-pomegranate-dep (&optional dep ns)
  "Auto-import DEP in the current Clojure Repl using Pomegranate.
   Optionally, we can change namespace by specifying NS."
  (interactive)
  (setq dep (or dep (read-string "Dep: ")))
  (prf/cider/send-to-repl (prf/clj/pomegranate-dep dep) t ns))

;; https://tecosaur.github.io/emacs-config/config.html
(setq-default
 uniquify-buffer-name-style 'forward
 window-combination-resize t
 x-stretch-cursor t)

(setq
 undo-limit 80000000
 evil-want-fine-undo t)

(global-subword-mode 1)

(setq frame-title-format
      '(""
        ;; (:eval "%b") ;; %b shows buffer name
        (:eval
         (let ((project-name (projectile-project-name)))
           (unless (string= "-" project-name)
             (format (if (buffer-modified-p)  " ◉ %s" "  ●  %s") project-name))))))

;; added based on comment in doom python readme
(after! lsp-python-ms
  (set-lsp-priority! 'mspyls 1))


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
