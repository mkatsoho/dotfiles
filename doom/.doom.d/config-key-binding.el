;;; ../.dotfiles/doom/.doom.d/config-key-binding.el -*- lexical-binding: t; -*-

(map! :leader
      :desc "Capture something"
      "x" #'org-capture)

(map! :leader
      :desc "pop up a persisitent buffer"
      "X" #'doom/open-scratch-buffer)

(map! :leader
      (:prefix ("d" . "smerge")
       "n"  #'smerge-next
       "a"  #'smerge-keep-all
       "u"  #'smerge-keep-upper
       "l"  #'smerge-keep-lower
       ))
