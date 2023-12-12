augroup LaTeXTemplate
    autocmd!
    autocmd BufNewFile *.tex call SetLaTeXTemplate()
    autocmd BufRead *.tex if line('$') == 1 && getline(1) ==# '' | call SetLaTeXTemplate() | endif
augroup END

function! SetLaTeXTemplate()
    " 插入 LaTeX 模板内容
    put = '\documentclass[12pt]{article}'
    put = '\usepackage[utf8]{inputenc}'
    put = '\usepackage{xeCJK}'
    put = '\usepackage{titlesec}'
    put = '\usepackage{setspace}'
    put = '\usepackage{geometry}'
    put = '\usepackage{amsmath}  % 数学公式宏包'
    put = '\usepackage{amssymb}  % 数学符号宏包'
    put = '\usepackage{listings}  % 代码块宏包'
    put = '\usepackage{graphicx}  % 图像宏包'
    put = '\usepackage{float}  % 浮动体宏包'
    put = '\usepackage{caption}  % 图片标题宏包'
    put = '\usepackage{marginnote}  % 批注宏包'
    put = '\usepackage{hyperref}  % 超链接宏包'
    put = '\usepackage{natbib}  % 参考文献宏包'
    put = '\usepackage{lipsum}'
    put = '\usepackage[english, chinese]{babel}'
    put = '\usepackage{datetime2}'
    put = '\DTMlangsetup[en-US]{showdayofmonth=false}'
    put = '\DTMlangsetup[chinese]{showdayofmonth=false}'
    put = ''
    put = ''
    put = '% 设置中文字体'
    put = '\setCJKmainfont{SimSun}  % 使用宋体或其他合适的字体'
    put = ''
    put = '% 设置英文字体'
    put = '\setmainfont{Times New Roman}  % 使用 Times New Roman 或其他合适的字体'
    put = ''
    put = '% 设置页边距'
    put = '\geometry{top=2.54cm, bottom=2.54cm, left=3.18cm, right=3.18cm}'
    put = ''
    put = '% 设置行间距和段间距'
    put = '\onehalfspacing  % 行间距为1.5倍'
    put = '\setlength{\parskip}{1.25\baselineskip}  % 段间距为1.25倍行间距'
    put = ''
    put = '% 定义标题格式'
    put = '\titleformat{\section}{\bfseries\fontsize{14}{16}\selectfont}{\thesection}{1em}{}'
    put = '\titleformat{\paragraph}{\fontsize{12}{14}\selectfont}{\theparagraph}{1em}{}'
    put = ''
    put = '\begin{document}'
    put = ''
    put = '% 标题页'
    put = '\begin{titlepage}'
    put = '    \begin{center}'
    put = '        \bfseries\fontsize{28}{32}\selectfont 书名'
    put = ''
    put = '        \vspace{1cm}'
    put = ''
    put = '        \fontsize{16}{18}\selectfont Camille Dolma'
    put = ''
    put = '        \vspace{0.618cm}'
    put = ''       
    put = '        \fontsize{14}{16}\selectfont \DTMtoday  % 使用中文日期'
    put = ''
    put = '    \end{center}'
    put = '\end{titlepage}'
    put = ''
    put = '% 目录页'
    put = '\tableofcontents'
    put = '\newpage'
    put = ''
    put = '% 正文'
    put = '\section{Section 1}'
    put = '\paragraph{Paragraph 1}'
    put = '\lipsum[1]  % 使用 \lipsum 生成虚拟文本，可以删除'
    put = ''
    put = '\paragraph{Paragraph 2}'
    put = '\lipsum[2]'
    put = ''
    put = '\section{Section 2}'
    put = '\paragraph{Paragraph 1}'
    put = '\lipsum[3]'
    put = ''
    put = '\paragraph{Paragraph 2}'
    put = '\lipsum[4]'
    put = ''
    put = '% 参考文献'
    put = '\begin{thebibliography}{9}'
    put = '    \bibitem{sample} Author, Title, Journal, 1970-1-1.'
    put = '    % 添加更多的参考文献'
    put = '\end{thebibliography}'
    put = ''
    put = '\end{document}'
    put = ''
    normal ggVG=
endfunction

" 在保存 LaTeX 文档时执行 xelatex 编译
autocmd BufWritePost *.tex call CompileLaTeX()

function! CompileLaTeX()
    " 获取当前文件名
    let l:current_file = expand('%')

    " 执行 xelatex 编译
    let l:compile_command = 'xelatex -interaction=nonstopmode ' . l:current_file

    " 打开终端执行 xelatex 命令，并提供换行符
    let l:compile_result = system(l:compile_command . ' < /dev/tty &')

    " 等待编译完成
    redraw!
    sleep 2000m

    " 打印编译信息
    echo 'LaTeX compilation completed.'

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


" 插入 LaTeX 代码模板函数
function! InsertLaTeXTemplate(command)
    let template = ''
    if a:command ==# 'e'
        let template = "\\begin{equation}\n\t\n\n\\end{equation}"
    elseif a:command ==# 'c'
        let template = "\\begin{lstlisting}[language=, caption=]\n\t\n\\end{lstlisting}"
    elseif a:command ==# 'i'
        let template = "\\begin{figure}[h]\n\t\\centering\n\t\\includegraphics[width=0.5\\textwidth]{example-image}\n\t\\caption{示例图片}\n\t\\label{fig:example}\n\\end{figure}"
    elseif a:command ==# 't'
        let template = "\\begin{table}\n\t\\caption{Table caption}\n\t\\centering\n\t\\begin{tabular}{|c|c|}\n\t\t\\hline\n\t\tHeader1 & Header2 \\\\\n\t\t\\hline\n\t\tContent1 & Content2 \\\\\n\t\t\\hline\n\t\\end{tabular}\n\\end{table}"
    elseif a:command ==# 'l'
        let template = "\\begin{itemize}\n\t\\item \n\t\\item \n\\end{itemize}"
    elseif a:command ==# 'lr'
        let template = "\\label{}"
    elseif a:command ==# 'fn'
        let template = "\footnote{}"
    elseif a:command ==# 'hl'
        let template = "\\href{http://www.example.com}{链接文本}"
    elseif a:command ==# 'mt'
        let template = "\\begin{theorem}\n\t\n\\end{theorem}"
    elseif a:command ==# 'ml'
        let template = "\\begin{lemma}\n\t\n\\end{lemma}"
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
        let template = "\\begin{acronym}\n\t\\acro{GNU}{GNU's Not Unix}\n\\end{acronym}"
    endif

    if !empty(template)
        execute "normal i" . template
    endif
endfunction

nnoremap <C-o> :call LaTeXInsertMode()<CR>

function! LaTeXInsertMode()
    let command = input("输入 LaTeX 快捷命令：")
    call InsertLaTeXTemplate(command)
endfunction

