;;; polymacs.el --- Incremental learning for self-study -*- coding: utf-8; lexical-binding: t; -*-

;; Copyright (C) 2025 P.M

;; Author: P.M (contact via github)
;; Version: 0.1
;; URL: https://github.com/pau-lin/polymacs
;; Package-Requires: ((emacs "26.1") (org "9.6"))

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; Polymacs is a SuperMemo-inspired Emacs package intended for
;; self-learners. SuperMemo (https://www.super-memory.com/) is a
;; learning method and software developed by Piotr Woźniak since 1985,
;; which has introduced and implemented many techniques for lifelong
;; and autodidactic learners, such as incremental learning and spaced
;; repetition. We have adapted some of these techniques into the Emacs
;; environment, taking advantage of its rich ecosystem.
;
;; Polymacs aims to be fast, scalable, future-proof, and modular,
;; providing a robust open-source solution for self-taught learners,
;; adaptable to their individual needs.

;;; Code:
(require 'seq)
(require 'cl-lib)

(require 'org)
(require 'org-id)

;;; Options
(defgroup polymacs nil
  "Incremental learning for self-study"
  :group 'applications
  :prefix "polymacs-"
  :link '(url-link :tag "Github" "https://github.com/pau-lin/polymacs"))

(defcustom polymacs-resources-directory (expand-file-name "polymacs-resources/" org-directory)
  "Path to directory containing polymacs resource files."
  :type 'directory
  :group 'polymacs)

;;; Declarations
(defconst polymacs-pkg-directory
  (file-name-directory (or load-file-name buffer-file-name))
  "Path to Polymacs source code.")

(defvar polymacs--new-resources-cache nil
  "Holds newly imported and unregistered resources.")

;;; Library
(defun polymacs-install ()
  "Install dependencies of polymacs when installed from version
control."
  (interactive)
  (let* ((default-directory polymacs-pkg-directory)
         (script-path (expand-file-name
                       (if (eq system-type 'windows-nt)
                           "scripts/install.ps1"
                         "scripts/install.sh")
                       default-directory)))
    (if (file-exists-p script-path)
        (shell-command
         (if (eq system-type 'windows-nt)
             (concat "powershell -ExecutionPolicy Bypass -File "
                     (shell-quote-argument script-path))
           (concat "bash " (shell-quote-argument script-path))))
      (message "Install script not found: %s" script-path))))

;;; Package bootstrap
(provide 'polymacs)

(cl-eval-when (load eval)
  (require 'polymacs-resource)
  (require 'polymacs-file)
  (require 'polymacs-mode)
  (require 'polymacs-review))
