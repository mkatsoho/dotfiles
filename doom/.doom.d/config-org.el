;;; ../.dotfiles/doom/.doom.d/config-org.el -*- lexical-binding: t; -*-

;; (use-package! org-roam
;;   :custom
;;   (org-format-latex-options (plist-put org-format-latex-options :scale 4.0)))

;; (use-package org-html-themify
;;   :straight
;;   (org-html-themify
;;    :type git
;;    :host github
;;    :repo "DogLooksGood/org-html-themify"
;;    :files ("*.el" "*.js" "*.css"))
;;   :hook (org-mode . org-html-themify-mode)
;;   :custom
;;   (org-html-themify-themes
;;    '((dark . joker)
;;      (light . storybook))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org-babel
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package! ob-elixir)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org-agenda & gtd
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar +gtd-inbox-file "~/org/gtd/inbox.org")
(defvar +gtd-main-file "~/org/gtd/gtd.org")
(defvar +gtd-someday-file "~/org/gtd/someday.org")
(defvar +gtd-tickler-file "~/org/gtd/tickler.org")

(after! org

  (setq org-agenda-files `(,+gtd-inbox-file ,+gtd-main-file ,+gtd-tickler-file))

  (setq org-agenda-custom-commands
        '(("o" "At the office" tags-todo "@office"
           ((org-agenda-overriding-header "Office")
            (org-agenda-skip-function #'my-org-agenda-skip-all-siblings-but-first)))
          ("h" "At home" tags-todo "@home"
           ((org-agenda-overriding-header "Home")))))

  (setq org-refile-targets '((+gtd-main-file :maxlevel . 3)
                             (+gtd-someday-file :level . 1)
                             (+gtd-tickler-file :maxlevel . 2)))

  (setq org-capture-templates '(("t" "Todo [inbox]" entry
                                 (file+headline +gtd-inbox-file "Task")
                                 "* TODO %?\n%i\n%a" :prepend t)
                                ("T" "Tickler" entry
                                 (file+headline +gtd-tickler-file "Tickler")
                                 "* %i%? \n %U")
                                ("n" "Personal notes" entry
                                 (file+headline +org-capture-notes-file "Inbox")
                                 "* %u %?\n%i\n%a" :prepend t)
                                ("j" "Journal" entry
                                 (file+olp+datetree +org-capture-journal-file)
                                 "* %U %?\n%i\n%a" :prepend t)
                                ("p" "Templates for projects")
                                ("pt" "Project-local todo" entry
                                 (file+headline +org-capture-project-todo-file "Inbox")
                                 "* TODO %?\n%i\n%a" :prepend t)
                                ("pn" "Project-local notes" entry
                                 (file+headline +org-capture-project-notes-file "Inbox")
                                 "* %U %?\n%i\n%a" :prepend t)
                                ("pc" "Project-local changelog" entry
                                 (file+headline +org-capture-project-changelog-file "Unreleased")
                                 "* %U %?\n%i\n%a" :prepend t)
                                ("o" "Centralized templates for projects")
                                ("ot" "Project todo" entry #'+org-capture-central-project-todo-file "* TODO %?\n %i\n %a" :heading "Tasks" :prepend nil)
                                ("on" "Project notes" entry #'+org-capture-central-project-notes-file "* %U %?\n %i\n %a" :heading "Notes" :prepend t)
                                ("oc" "Project changelog" entry #'+org-capture-central-project-changelog-file "* %U %?\n %i\n %a" :heading "Changelog" :prepend t)))

  ;; https://emacs.cafe/emacs/orgmode/gtd/2017/06/30/orgmode-gtd.html
  (defun my-org-agenda-skip-all-siblings-but-first ()
    "Skip all but the first non-done entry."
    (let (should-skip-entry)
      (unless (org-current-is-todo)
        (setq should-skip-entry t))
      (save-excursion
        (while (and (not should-skip-entry) (org-goto-sibling t))
          (when (org-current-is-todo)
            (setq should-skip-entry t))))
      (when should-skip-entry
        (or (outline-next-heading)
            (goto-char (point-max))))))

  (defun org-current-is-todo ()
    (string= "TODO" (org-get-todo-state)))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org-roam
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar-local +org-last-in-latex nil)

(defun +org-post-command-hook ()
  (ignore-errors
    (let ((in-latex (rime-predicate-org-latex-mode-p)))
      (if (and +org-last-in-latex (not in-latex))
          (progn (org-latex-preview)
                 (setq +org-last-in-latex nil)))

      (when-let ((ovs (overlays-at (point))))
        (when (->> ovs
                (--map (overlay-get it 'org-overlay-type))
                (--filter (equal it 'org-latex-overlay)))
          (org-latex-preview)
          (setq +org-last-in-latex t)))

      (when in-latex
        (setq +org-last-in-latex t)))))

;; (define-minor-mode org-latex-auto-toggle
;;   "Auto toggle latex overlay when cursor enter/leave."
;;   nil
;;   nil
;;   nil
;;   (if org-latex-auto-toggle
;;       (add-hook 'post-command-hook '+org-post-command-hook nil t)
;;     (remove-hook 'post-command-hook '+org-post-command-hook t)))
