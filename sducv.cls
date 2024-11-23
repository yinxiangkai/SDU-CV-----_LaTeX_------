% 加载必要的 LaTeX 包 `expl3` 和 `l3keys2e`，用于支持 LaTeX3 编程。
\RequirePackage{expl3,l3keys2e}
% 提供自定义文档类 `resume` 的基本信息，包括类名、版本日期、版本号及说明。
\ProvidesExplClass{sducv}
{2024-11-23}{0.1.0}{豈}

% 保持安静模式，避免 `xeCJK` 包产生多余的警告信息。
\PassOptionsToPackage{quiet}{xeCJK}
% 处理选项配置。
\ProcessOptions\relax
% 加载 `ctexart` 文档类，设置默认字号为小五号（zihao=5），自动缩进为 0.5em。
\LoadClass[zihao=5,autoindent=0.5em]{ctexart}

% 定义页面尺寸。
\RequirePackage{geometry}
% 去除默认的页眉和页脚样式。
\RequirePackage{fancyhdr}
% 加载 `enumitem` 包，用于重新定义列表样式。
\RequirePackage{enumitem}
% 将所有脚注排列在同一行。
\RequirePackage[para]{footmisc}
% 加载超链接功能，但隐藏链接样式。
\RequirePackage[colorlinks=false,hidelinks,]{hyperref}
% 提供 `\CJKunderline` 命令，用于生成中文下划线。
\RequirePackage{xeCJKfntef}
% 提供颜色支持。
\RequirePackage{xcolor}
% 提供图形支持
\RequirePackage{tikz}
\RequirePackage{graphicx}
\usepackage[absolute,overlay]{textpos} % 用于绝对定位
% 字体
\RequirePackage{fontspec}
\RequirePackage{fontawesome5}


% 清除页面样式（无页眉页脚）。
\pagestyle{empty}





% 使用 A4 页面格式，设置较小的页边距（1cm），并减小底边距至 0.5cm。
\geometry{a4paper,margin=1cm, bottom=0.5cm}

%%% 全局变量设置 %%%

% 定义一个全局序列变量，用于存储联系人信息。
\seq_new:N \g__resume_contacts_seq
% 定义一个全局文本变量，用于存储标题名称（通常是简历的名字）。
\tl_new:N \g__resume_title_name_tl

%%% 全局设置 %%%

% 取消页码显示。
\pagenumbering{gobble}

 % 定义自定义颜色 sdu_color（可以自定义为 RGB 或其他颜色模型）
\definecolor{sdu_color}{RGB}{148,20,27} % RGB 
% 字体设置
% \setmainfont[
%     Path=fonts/,
%     Extension=.otf,
%     BoldFont=*-Bold,
% ]{NotoSerifSC}

% 设置节标题样式。
\ctexset{
  section = {
    nameformat = {}, % 不设置节标题名称的格式。
    number = {}, % 取消节标题的编号。
    format = \noindent \zihao{3} \heiti \color{sdu_color} \__resume_section_title_format:n, % 设置节标题的格式：无缩进、小四号字体、黑体，并调用自定义的 `\__resume_section_title_format:n`。
    indent = -1em, % 取消标题缩进，向左移动 1em。
    afterskip = 0.5em, % 标题与后文的间距为 0.5em。
    beforeskip = 0.2em, % 标题与前文的间距为 0.2em。
  },
}

% 设置列表样式。
\setlist{
  labelsep=2pt, % 列表标记与文本之间的距离为 2pt。
  labelwidth=5pt, % 列表标记的宽度为 5pt。
  leftmargin=1.3em, % 列表左边距为 1.3em。
  itemsep=0em, % 列表项之间无额外间距。
  parsep=0.20em, % 列表段落之间的间距为 0.20em。
  topsep=0em, % 列表与上方内容之间无额外间距。
}

% 设置行间距为 1.15 倍。
\linespread{1.15}

% 定义一个新的计数器，用于生成书签。
\newcounter{resumebookmark}

%%% 用户命令定义 %%%



% 自定义节标题格式命令：为标题添加下划线及额外间距。
\cs_new:Npn \__resume_section_title_format:n #1
{#1 \vspace{3pt} \hrule}


% 自定义命令：将内容追加到联系人信息序列。
\cs_new:Npn \__resume_append_concat:n #1
{
  \seq_put_right:Nn \g__resume_contacts_seq {#1}
}
% 定义命令：添加单个联系人信息。
\NewDocumentCommand{\ResumeContact}{m}
{
  \__resume_append_concat:n {#1}
}

% 定义命令：设置简历标题（通常是名字）。
\NewDocumentCommand{\ResumeName}{m}
{
  \tl_set:Nn \g__resume_title_name_tl {#1}
}

% 定义命令：渲染简历标题。
\NewDocumentCommand{\ResumeTitle}{}
{
  \begin{center}
    \zihao{-2} \heiti \g__resume_title_name_tl
  \end{center}
  % 减小标题与后续内容的间距。
  \vspace{-1.4em}
  \begin{center}
    % 使用 `|` 分隔联系人信息，并输出到中心对齐的内容。
    \seq_use:Nnnn \g__resume_contacts_seq {~|~} {~|~} {~|~}
  \end{center}
}

% 定义命令：渲染节标题。
% 参数说明：
% #1（可选）：PDF 中用作书签的内容。
% #2：节标题名称。
% #3（可选）：节标题的附加信息。
% #4（可选）：右对齐显示的附加内容（通常是日期范围）。
\NewDocumentCommand{\ResumeItem}{omoo}
{
  {
    \zihao{-4} % 使用小四号字体。
    \par 
    \noindent % 无缩进。
    {
      \heiti % 使用黑体。
      #2 % 输出节标题。

      % 如果提供了参数 #1，则将其用作 PDF 书签；否则使用参数 #2。
      \IfValueTF{#1}
      {
        \pdfbookmark[2]{#1}{subsec:\arabic{resumebookmark}}
      }
      {
        \pdfbookmark[2]{#2}{subsec:\arabic{resumebookmark}}
      }
      \stepcounter{resumebookmark} % 书签计数器加 1。
    }
    % 如果提供了参数 #3，则输出附加信息（如为空则忽略）。
    \IfValueT{#3}{
      \tl_if_empty:nF {#3} {
        \ | % 使用竖线分隔。
        \textit{ % 使用斜体。
          #3
        }
      }
    }
    \hfill % 将接下来的内容右对齐。
    \IfValueT{#4}{
      #4 % 输出右对齐的内容。
    }
    \par
  }
}

% 定义命令：将内容显示为灰色。
\NewDocumentCommand{\GrayText}{m}
{
  \textcolor{gray}{#1}
}

% 定义命令：为超链接内容添加下划线并提供可点击功能。
\NewDocumentCommand{\ResumeUrl}{mm}
{
  \href{#1}{\CJKunderline{#2}}
}

\NewDocumentCommand{\ResumeInfop}{mm}
{
  \href{#1}{\CJKunderline{#2}}
}

% 定义个人信息展示命令（列内容对齐）
% 定义个人信息展示命令（整体偏左，右侧展示照片）
\newcommand{\personalInfoWithPhoto}[7]{%
    \hspace{2em}
    \begin{minipage}[t]{0.8\textwidth} % 左侧个人信息部分
     \begin{center}
            \textbf{\LARGE #1}\\ % 姓名
            
            \color{sdu_color}\rule[1em]{0.3\textwidth}{0.5pt} % 横线，宽度调整为0.8\textwidth
        \end{center}
        % 信息网格展示
         \renewcommand{\arraystretch}{1.5} % 设置行间距
         \zihao{5} % 设置表格内字体大小
        \begin{tabular}{lll}
            \textbf{性别}：#2 & \textbf{出生年月}：#3 & \textbf{政治面貌}：#4 \\
            \textbf{籍贯}：#5 & \textbf{电话号码}：#6 & \textbf{电子邮箱}：#7
        \end{tabular}
    \end{minipage}%
     \vspace{1em}
}



% 标记文档结束。
\endinput
