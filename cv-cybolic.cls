\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{cv-cybolic}[2023/03/10 Class for my CV, loosely matching Europass]

%% Colors
\RequirePackage{xcolor}
\definecolor{shadecolor} {HTML} {353744}  % almost black | used for secondary information (labels, subheadings, etc.)
\definecolor{fadecolor}  {HTML} {f3f3f3}  % almost white | used for visual background distinction (odd rows)
\definecolor{asidecolor} {HTML} {666666}  % gray         | used for secondary listings (keywords, etc.)
\definecolor{maincolor}  {HTML} {00AB44}  % green        | used for headlines (not title)
\definecolor{accentcolor}{HTML} {9900FF}  % purple       | used for highlights / tags

\newcommand{\headlinecolor}{\color{maincolor}}
\newcommand{\accentcolor}{\color{accentcolor}}
\newcommand{\maincolor}{\color{black}}

%% Class Options
\DeclareOption{headlinecolor}{\renewcommand{\headlinecolor}{\color{headlinecolor}}}
\DeclareOption{accentcolor}{\renewcommand{\accentcolor}{\color{accentcolor}}}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass[10pt,a4paper,english]{article}

%% Layout
\RequirePackage[english]{babel}
\RequirePackage[a4paper, portrait, margin=25mm]{geometry}
\RequirePackage{fancyhdr}
\pagestyle{empty}
\fancyhfoffset{0mm}

%% PDF Output
\RequirePackage[bookmarks]{hyperref}
\RequirePackage{bookmark}

\AtBeginDocument{
    \hypersetup{
        pdftitle = {\@title},
        pdfauthor = {\@author},
        pdfsubject = {Curriculum Vitae},
        linkcolor=blue,
        filecolor=magenta,
        urlcolor=cyan,
    }
}

%% Icons
\RequirePackage[fixed]{fontawesome5}
\newcommand{\emailSymbol}{\faEnvelope[regular]}
\newcommand{\locationSymbol}{\faMapMarker*}
\newcommand{\infoSymbol}{\faInfo}
\newcommand{\linkedinSymbol}{\faLinkedinIn}
\newcommand{\phoneSymbol}{\faPhone*}
\newcommand{\githubSymbol}{\faGithub}
\newcommand{\stackoverflowSymbol}{\faStackOverflow}
\newcommand{\stackexchangeSymbol}{\faStackExchange}
\newcommand{\bitbucketSymbol}{\faBitbucket}
\newcommand{\mastodonSymbol}{\faMastodon}
\newcommand{\websiteSymbol}{\faLink}


%% Information Parsing
\RequirePackage{xfp}
\newcommand{\photo}[2][3cm]{\def\@photo{#2}\def\@photodiameter{#1}\def\@photodiameterhalf{\fpeval{0.5 * #1}}}

\newcommand{\setfromname}{%
    \ifdefined\givenname
        \ifdefined\surname
            \title{CV - \name}
            \author{\name}
        \fi
    \fi
}
%\RequirePackage{xstring}
\newcommand*{\givenname}[1]   {\def\@givenname{#1}\setfromname}
\newcommand*{\surname}[1]     {\def\@surname{#1}\setfromname}
\newcommand*{\tagline}[1]     {\def\@tagline{#1}}

\newcommand*{\about}[1]           {\def\@about{#1}}
\newcommand*{\contactinfo}[1]     {\def\@contactinfo{#1}}
\newcommand*{\contactemail}[1]    {\def\@contactemail{#1}}
\newcommand*{\contactwebsite}[1]  {\def\@contactwebsite{#1}}
\newcommand*{\contactphone}[1]    {\def\@contactphone{#1}}
\newcommand*{\contactmastodon}[1] {\def\@contactmastodon{#1}}
\newcommand*{\contactaddress}[1]  {\def\@contactaddress{#1}}

\newcommand{\name}            {\@givenname~\@surname}
\newcommand{\website}[1]      {\par{\websiteSymbol \url{#1}}}
\newcommand{\phone}[1]        {\par{\phoneSymbol \texttt{#1}}}
\newcommand{\address}[1]      {\par{\locationSymbol {#1}}}
\newcommand{\email}[1]        {\par{\emailSymbol \texttt{\href{mailto:#1?subject=Hi\%20\@givenname\%20\@surname,\%20...}{#1}}}}
\newcommand{\mastodon}[1]     {\par{\mastodonSymbol \texttt{#1}}}

%% Typeface, Header and Title Definitions
\RequirePackage[utf8]{inputenc}
\RequirePackage{nunito}
\RequirePackage{titlesec}
\RequirePackage{ragged2e}

\RequirePackage[
    backend=biber,
    style=numeric-comp,
    sorting=none,
]{biblatex}
\addbibresource{cv.bib}
\RequirePackage{etoolbox}

\titleformat{\section}{\headlinefont\bfseries\headlinecolor\uppercase}{}{0pt}{}
\titlespacing*{\section}{0pt}{*1.5}{*1}

\titleformat{\subsection}{\normalfont}{}{0pt}{}
\titlespacing*{\subsection}{0pt}{*1.5}{*1}

\defbibheading{bibliography}[\bibname]{%
   \section{\uppercase{#1}}%
   \markboth{#1}{#1}
}

\newcommand{\titlefont}   {\fontsize{24}{36}\fontseries{m}\selectfont}
\newcommand{\subtitlefont}{\fontsize{18}{27}\fontseries{m}\selectfont}
\newcommand{\headlinefont}{\fontsize{14}{21}\fontseries{b}\selectfont}

\RequirePackage{wrapfig}
% maketitle, autofilled with the variables set by \givenname, \surname, \tagline, \photo and \tagline
\renewcommand{\maketitle}{%
    \noindent
    \maincolor
    \titlefont
    \begin{wrapfigure}{R}{\@photodiameter}
        \vspace{-2em}
        \photoimage
    \end{wrapfigure}
    \@givenname~\@surname
    \ifdefined\@tagline
        \vskip 0em
        \noindent
        \headlinecolor
        \subtitlefont
        \@tagline
        \maincolor
        \vskip 0em
    \fi
    \normalsize
    \bigskip
    \ifdefined\@about
        \vspace{-0.5em}
        \section{About}
        \noindent
        \@about
    \fi
}

%% Sections
\newcommand{\makeabout}{%
    \section{About}
    {\@about}

}

\RequirePackage{array, tabularray, multirow, makecell}

% Contact Information section using the information in the @contact### variables
\newcommand{\makecontactinfo}{%
    \section{Contact Information}\vspace{-1em}%
    \noindent%
    \begin{tblr}{
        leftsep = 0pt, abovesep = -.5em, belowsep = 0pt, baseline = h,
        vspan = even,
        cells = {l, h},
        cell{3}{1} = {r=1,c=2}{},
    }%
        \email{\@contactemail} & \mastodon{\@contactmastodon} \\*
        \phone{\@contactphone} & \website{\@contactwebsite} \\*
        \address{\@contactaddress} &
    \end{tblr}
    \bigskip
}

% Experience sections, use either `jobexperience` (using "at") or `probonoexperience` (using "for")
\newcommand{\environmentrelatetext}{at}
\NewDocumentEnvironment{experiencesection}{m m m m m m m m +b}{
    \phantomsection
    \noindent
    \begin{tblr}{
        %vlines, hlines,
        leftsep = 0pt, rightsep = 0pt,
        colspec = {Q[5em] X},
        cell{1}{1} = {r=2}{c,h},
    }
        {
            \label{subsec:#1—#3: #6 \environmentrelatetext~#5}
            \small\color{shadecolor}\textbf{#3} \footnotesize{#4}\\%
            %\large\color{shadecolor}$\uparrow$\\%  narrow math arrow
            \large\color{gray8}\faLongArrowAltUp\\%  bold Font Awesome arrow
            \small\color{shadecolor}\textbf{#1} \footnotesize{#2}%
        } & {
            \large\color{shadecolor}%
            \textbf{\textsc{#6}} \environmentrelatetext~\emph{#5} (#7) \hfill \textbf{#8}%
        } \\*
          & \raisebox{0.5em}{\begin{minipage}[t]{\dimexpr\textwidth-5em}\color{black}#9\end{minipage}}
    \end{tblr}
    \addcontentsline{toc}{subsection}{#1—#3: #6 \environmentrelatetext~#5}
    \bigskip
}{}
\NewDocumentEnvironment{jobexperience}{m m m m m m m m +b}{
    \renewcommand{\environmentrelatetext}{at}
    \begin{experiencesection}{#1}{#2}{#3}{#4}{#5}{#6}{#7}{#8}#9\end{experiencesection}
}{}
\NewDocumentEnvironment{probonoexperience}{m m m m m m m m +b}{
    \renewcommand{\environmentrelatetext}{for}
    \begin{experiencesection}{#1}{#2}{#3}{#4}{#5}{#6}{#7}{#8}#9\end{experiencesection}
}{}

% Striped, two column table similar to a labelled itemize list
\NewDocumentEnvironment{tablelist}{+b}{
    \vskip .75em
    \begin{tblr}{%
        vspan = even,
        cell{even}{1,2} = {bg = fadecolor},
        cell{1-99}{1} = {preto = {•~~}, fg = shadecolor, font = \bfseries},
        colspec = {Q[7em] X}
    }
    #1
    \end{tblr}
}{}

% Inline list with items separated by a \cdot
\RequirePackage[inline]{enumitem}
\NewDocumentCommand{\keywords}{m}{
    \color{asidecolor}
    \begin{center}\begin{itemize*}[
        mode=unboxed,
        label={},
        afterlabel=\hspace{2pt},
        itemjoin={{ $\cdot$ }}
    ]
        \foreach \i in {#1}{%
            \item \i
        }
    \end{itemize*}\end{center}
}

% Quotation paragraph with Author and Title as arguments
\NewDocumentEnvironment{citedquote}{m m +b}{
    \noindent\indent\begin{Large}{\textquotedblleft}\end{Large}\textit{%
        #3%
    }\begin{Large}{\textquotedblright}\end{Large}%
    \vspace{-0.5em}\begin{flushright}\textemdash~\textbf{#1} \textendash~{#2}\end{flushright}
}{}


%% Commands

% Highlight (use like \emph, but only changes color)
\newcommand{\hl}[1]{{\color{accentcolor}#1}}

% Circular image using @photo and @photodiameter
\RequirePackage{tikz}
\newcommand\photoimage{
    \begin{tikzpicture}
    \clip (0,0) circle (\@photodiameter*0.5);
    \node[anchor=center] at (0,0) {\includegraphics[width=\@photodiameter]{\@photo}};
    \end{tikzpicture}
}
