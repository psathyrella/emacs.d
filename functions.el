(defun insert-dashed-comment-line()
 (interactive)
 (move-beginning-of-line nil)
 (insert "----------------------------------------------------------------------------------------
")
 (previous-line)
 (push-mark)
 (next-line)
 (comment-region (point) (mark))
 (previous-line)
;; (indent-for-tab-command)
)

(defun kill-line-backward()
 (interactive)
 (move-beginning-of-line nil)
 (kill-line)
)

(defun magit-refine-next-hunk()
  "Magit should do this by default!"
  (interactive)
  (search-forward "@@")
  (move-end-of-line nil)
  (diff-refine-hunk))

(defun insert-itemize ()
  "Insert itemize stuff at cursor point."
  (interactive)
  (set-mark (point))
  (insert "\\begin{itemize}
\\item
\\end{itemize}
"))

(defun insert-center ()
  "Insert center environment at cursor point."
  (interactive)
  (insert "\\begin{center} \\end{center}
"))

(defun insert-frame ()
  "Insert beamer frame at cursor point."
  (interactive)
  (insert "\\begin{frame}
  \\frametitle{}
  \\begin{itemize}
  \\item
  \\end{itemize}
  % \\includegraphics[scale=0.21]{plots/}
\\end{frame}
"))

(defun insert-columns ()
  "Insert beamer columns at cursor point."
  (interactive)
  (set-mark (point))
  (insert "\\begin{columns}
\\begin{column}{0.5\\textwidth}
\\end{column}
\\begin{column}{0.5\\textwidth}
\\end{column}
\\end{columns}
"))

(defun insert-beamer-url ()
  "Insert beamer url start"
  (interactive)
  (insert "{\\tiny {\\color{blue}\\url{"))

(defun insert-beamer-color ()
  (interactive)
  (insert "{\\color{}}"))

(defun insert-setw ()
  "Insert setw"
  (interactive)
  (insert "<< setw(12) << ")
  )

(defun insert-cendl ()
  "Insert basic cout line"
  (interactive)
  (insert "cout << \"\" << endl;")
  (backward-char 10)
  )

(defun move-ten-lines-up ()
  (interactive)
  (previous-line 10))
(defun move-ten-lines-down ()
  (interactive)
  (next-line 10))

(require 'ansi-color)
(defun display-ansi-colors ()
  (interactive)
    (ansi-color-apply-on-region (point-min) (point-max)))
