augroup LaTeXTemplate
    autocmd!
    autocmd BufNewFile *.tex call SetLaTeXTemplate()
    autocmd BufRead *.tex if line('$') == 1 && getline(1) ==# '' | call SetLaTeXTemplate() | endif
augroup END

function! SetLaTeXTemplate()
    " 插入 LaTeX 模板内容
    put = '\documentclass[12pt]{book}'
    put = '\usepackage[utf8]{inputenc}'
    put = '\usepackage{xeCJK}'
    put = '\usepackage{titlesec}'
    put = '\usepackage{titletoc}'
    put = '\usepackage{setspace}'
    put = '\usepackage{geometry}'
    put = '\usepackage{amssymb}'
    put = '\usepackage{amsmath}'
    put = '\usepackage{listings}'
    put = '\usepackage{graphicx}'
    put = '\usepackage{tikz}'
    put = '\usepackage{float}'
    put = '\usepackage{caption}'
    put = '\usepackage{marginnote}'
    put = '\usepackage{hyperref}'
    put = '\usepackage{natbib}'
    put = '\usepackage{lipsum}'
    put = '\usepackage{datetime}'
    put = '\usepackage{minted}'
    put = '\usepackage{xcolor}'
    put = '\usepackage{zhnumber}'
    put = ''
    put = '% 重新定义 figure 的编号前缀'
    put = '\renewcommand{\figurename}{图}'
    put = ''
    put = '% 重新定义 listing 的编号前缀'
    put = '\renewcommand{\lstlistingname}{代码}'
    put = ''
    put = '% 重新定义 table 的编号前缀'
    put = '\renewcommand{\tablename}{表}'
    put = ''
    put = '\renewcommand{\contentsname}{目录}'
    put = '\renewcommand{\bibname}{参考文献}'
    put = ''
    put = '% 将公式编号设置为 (章节号.公式编号) 的格式'
    put = '\numberwithin{equation}{chapter}'
    put = ''
    put = '% 定义章节标题的格式'
    put = '\renewcommand\thechapter{\arabic{chapter}} % 只显示阿拉伯数字，不显示章节编号前缀'
    put = '\renewcommand\theequation{\thechapter.\arabic{equation}} % 设置公式编号格式'
    put = ''
    put = '\usemintedstyle{monokai}'
    put = ''
    put = '\newdateformat{mydateformat}{\THEYEAR 年 \THEMONTH 月 \THEDAY 日}'
    put = ''
    put = ''
    put = '% 设置页边距'
    put = '\geometry{top=2.54cm, bottom=2.54cm, left=3.18cm, right=3.18cm}'
    put = ''
    put = '% 设置行间距和段间距'
    put = '\setlength{\parskip}{1.25\baselineskip}  % 段间距为1.25倍行间距'
    put = ''
    put = '% 定义标题格式'
    put = '\titleformat{\section}{\bfseries\fontsize{14}{16}\selectfont}{\thesection}{1em}{}'
    put = '\titleformat{\paragraph}{\fontsize{12}{14}\selectfont}{\theparagraph}{1em}{}'
    put = ''
    put = '% 定义章节格式'
    put = '\titleformat{\chapter}[display]'
    put = '{\normalfont\huge\bfseries\centering}{第\,\zhnumber{\thechapter}\,章}{1em}{}'
    put = ''
    put = '% 定义目录格式'
    put = '\titlecontents{chapter}[0pt]'
    put = '{\addvspace{1ex}}'
    put = '{\bfseries 第\,\zhnumber{\thecontentslabel}\,章\quad}'
    put = '{} % 无需填写'
    put = '{\hfill\contentspage} % 在每个章节条目后添加页码'
    put = ''
    put = '\begin{document}'
    put = ''
    put = '% 标题页'
    put = '\begin{titlepage}'
    put = '    \begin{center}'
    put = '    {\bfseries\fontsize{28}{32}\selectfont 书名 \par}'
    put = '    \vspace{0.5cm}'
    put = '    {\fontsize{16}{18}\selectfont \textit{Camille Dolma} \par}'
    put = '    \vspace{0.314cm}'
    put = '    \vfill'
    put = '    {\fontsize{14}{16}\selectfont \textnormal{\mydateformat\today} \par}'
    put = '  \end{center}'
    put = '\end{titlepage}'
    put = ''
    put = '% 目录页'
    put = '\frontmatter'
    put = '\tableofcontents'
    put = '\newpage'
    put = ''
    put = ''
    put = ''
    put = '% 正文'
    put = '\mainmatter'
    put = '\chapter{Hello world}'
    put = '\section{Section 1}'
    put = '\paragraph{Paragraph 1}'
    put = ''
    put = ''
    put = ''
    put = ''
    put = ''
    put = '% 参考文献'
    put = '\begin{thebibliography}{9}'
    put = '\bibitem{sample} Author, Title, Journal, 1970-1-1.'
    put = '% 添加更多的参考文献'
    put = '\end{thebibliography}'
    put = ''
    put = '\end{document}'
    put = ''
    put = ''
    normal ggVG=
endfunction

" 在保存 LaTeX 文档时执行 xelatex 编译
autocmd BufWritePost *.tex call CompileLaTeX() | call CompileLaTeX() | echo "编译完成"

function! CompileLaTeX()
    " 获取当前文件名
    let l:current_file = expand('%')

    " 执行 xelatex 编译
    let l:compile_command = 'xelatex -interaction=nonstopmode -shell-escape ' . l:current_file

    " 打开终端执行 xelatex 命令，并提供换行符
    let l:compile_result = system(l:compile_command . ' < /dev/tty &')

    " 等待编译完成
    redraw!
    sleep 2000m

    " 如果编译成功，打开生成的 PDF
    if v:shell_error == 0
        call OpenPDF()
    else
        echo 'LaTeX compilation failed. Check the error messages.'
    endif
endfunction

function! OpenPDF()
    " 获取生成的 PDF 文件名
    let l:pdf_file = substitute(expand('%:r'), ' ', '\ ', 'g') . '.pdf'

    " 判断操作系统类型
    if has('win32') || has('win64')
        " Windows 上使用 start 命令
        let l:open_command = 'start ' . l:pdf_file
    else
        " POSIX 上使用 open 命令
        let l:open_command = 'open ' . l:pdf_file
    endif

    " 打开生成的 PDF
    call system(l:open_command)
endfunction


function! MoveCursorToEquation(target)
    " 保存当前光标位置
    let save_cursor = getpos('.')

    " 向上搜索目标
    call search(a:target, 'bW')

    " 如果找到了目标
    if search(a:target, 'bW') > 0
        " 将光标移到下一行开头
        normal! j0
    else
        " 如果未找到，还原光标位置
        call setpos('.', save_cursor)
    endif
endfunction

" 插入 LaTeX 代码模板函数
function! InsertLaTeXTemplate(command)
    let template = ''
    if a:command ==# 'e'
        let template = "\\begin{equation}\n\n\n\n\\end{equation}"
    elseif a:command ==# 'c'
        let template = "\\begin{listing}[htbp]\n\\begin{minted}[linenos, breaklines, numbersep=3pt, fontsize=\\small, tabsize=4, codetagify]{}\n\n\n\n\n\\end{minted}\n\\caption{}\n\\label{}\n\\end{listing}"
    elseif a:command ==# 'i'
        let template = "\\begin{figure}[htbp]\n\\centering\n\\includegraphics[width=0.8\\textwidth]{}\n\\caption{}\n\\label{}\n\\end{figure}"
    elseif a:command ==# 't'
        let template = "\\begin{table}\n\\caption{Table caption}\n\\centering\n\\begin{tabular}{|c|c|}\n\\hline\nHeader1 & Header2 \n\\hline\nContent1 & Content2 \n\\hline\n\\end{tabular}\n\\end{table}"
    elseif a:command ==# 'l'
        let template = "\\begin{itemize}\n\\item \n\\item \n\\end{itemize}"
    elseif a:command ==# 'lr'
        let template = "\\label{}"
    elseif a:command ==# 'fn'
        let template = "\footnote{}"
    elseif a:command ==# 'hl'
        let template = "\\href{http://www.example.com}{链接文本}"
    elseif a:command ==# 'mt'
        let template = "\\begin{theorem}\n\n\\end{theorem}"
    elseif a:command ==# 'ml'
        let template = "\\begin{lemma}\n\n\\end{lemma}"
    elseif a:command ==# '0'
        let template = "\\chapter{}"
    elseif a:command ==# '1'
        let template = "\\section{}"
    elseif a:command ==# '2'
        let template = "\\subsection{}"
    elseif a:command ==# '3'
        let template = "\\subsubsection{}"
    elseif a:command ==# '4'
        let template = "\\paragraph{}"
    elseif a:command ==# '5'
        let template = "\\subparagraph{}"
    elseif a:command ==# 'ac'
        let template = "\\begin{acronym}\n\\acro{GNU}{GNU's Not Unix}\n\\end{acronym}"
    endif

    if !empty(template)
        execute "normal i" . template
    endif
endfunction

nnoremap <C-o> :call LaTeXInsertMode()<CR>

function! LaTeXMoveCursorAutomatically(n)
    let current_line = line('.')

    let target_line = current_line - a:n

    execute 'normal! ' . target_line . 'G'

    startinsert
endfunction


function! LaTeXInsertMode()
    let command = input("输入 LaTeX 快捷命令：")
    let g:saved_line = line('.')
    let save_cursor = getpos('.')
    call InsertLaTeXTemplate(command)

    if command ==# 'e'
        call LaTeXMoveCursorAutomatically(2)
    elseif command ==# 'c'
        call LaTeXMoveCursorAutomatically(6)
    elseif command ==# 'i'
        call LaTeXMoveCursorAutomatically(3)
        normal! $a
    elseif command ==# '0'
        normal! $a
        startinsert
    elseif command ==# '1'
        normal! $a
        startinsert
    elseif command ==# '2'
        normal! $a
        startinsert
    elseif command ==# '3'
        normal! $a
        startinsert
    elseif command ==# '4'
        normal! $a
        startinsert
    elseif command ==# '5'
        normal! $a
        startinsert
    endif

endfunction



