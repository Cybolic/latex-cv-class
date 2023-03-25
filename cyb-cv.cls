\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{cyb-cv}[2023/03/23 Styling for my CV]

% \LoadClass[8pt,a4paper]{article}
\LoadClass[a4paper]{article}


%% Colours
%%
\RequirePackage{xcolor}

\definecolor{accentcolor} {HTML} {43069A}  % purple       | used for highlights / tags
\definecolor{linkcolor}   {HTML} {265699}  % blue         | used for external links

\colorlet{graycolor}      {black!65!white}
\colorlet{secondarycolor} {black!70!white!5!accentcolor}

\newcommand{\maincolor}      {\color{black}}
\newcommand{\accentcolor}    {\color{accentcolor}}
\newcommand{\secondarycolor} {\color{accentcolor}}
\newcommand{\graycolor}      {\color{graycolor}}


%% Layout / Geometry
%%
\newlength\margin
\setlength\margin{25mm}
\RequirePackage[
 a4paper,
 noheadfoot,
 nomarginpar,
 margin=\margin,
]{geometry}

\setlength{\parindent}{0pt}


%% Titles and Typography
%%
\RequirePackage{fancyhdr}
\RequirePackage{titlesec}
\titleformat{\section}{\bfseries\uppercase}{}{0pt}{}
\titlespacing*{\section}{0pt}{*1.5}{*1}

\titleformat{\subsection}{\normalfont}{}{0pt}{}
\titlespacing*{\subsection}{0pt}{*1.5}{*1}

\renewcommand{\maketitle}{%
    \maincolor\Large
    \getbypath{basics.name}%
    %
    \large
    \separator%
    \secondarycolor%
    \getbypath{basics.label}
    \maincolor
    \medskip
    %
    \normalsize
}

\RequirePackage[colorlinks]{hyperref}
\AtBeginDocument{
    \pagestyle{empty}
    \fancyhf{}
    \fancyhfoffset{0mm}

    \makeatletter
    \hypersetup{
        pdftitle = {CV --- \getbypath{basics.name}},
        pdfauthor = {\getbypath{basics.name}},
        pdfsubject = {Curriculum Vitae},
        citecolor   = {red!40!black},  % citation color
        linkcolor   = {cyan!40!black}, % internal link color
        urlcolor    = {linkcolor},     % external link color
    }
    \makeatother
}


%% Common Elements
%%
\newcommand \separator{%
    \textcolor{gray!40!white}{\hspace{.5em}\textbar\hspace{.5em}}%
}

%% A horizontal split box where the left cell (#2) is #1 wide and the right cell (#3) takes the remainder of the page width
%% The right cell is always footnotesize
\newcommand\topicbox[3]{%
    \noindent%
    \begin{minipage}[t]{#1}%
        #2%
    \end{minipage}%
    \begin{minipage}[t]{\dimexpr(\linewidth-#1)}\begin{footnotesize}\begin{raggedright}%
        #3%
    \end{raggedright}\end{footnotesize}\end{minipage}%
}

\newenvironment{boldiscolor}[1][accentcolor]{%
    \renewcommand{\textbf}[1]{\textcolor{#1}{##1}}%
}

\newcommand\quotedtext[2][normalsize]{%
    \begin{#1}{\textquotedblleft}\end{#1}%
        \textit{#2}%
    \begin{#1}{\textquotedblright}\end{#1}%
}

\RequirePackage{microtype}

% vim: set filetype=tex tabstop=4 softtabstop=4 shiftwidth=4 expandtab :